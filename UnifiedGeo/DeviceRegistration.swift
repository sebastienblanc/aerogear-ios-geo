/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

public class DeviceRegistration: NSObject, NSURLSessionTaskDelegate {
    
    struct DeviceRegistrationError {
        static let GeoErrorDomain = "GeoErrorDomain"
        static let NetworkingOperationFailingURLRequestErrorKey = "NetworkingOperationFailingURLRequestErrorKey"
        static let NetworkingOperationFailingURLResponseErrorKey = "NetworkingOperationFailingURLResponseErrorKey"
    }
    
    let serverURL: NSURL
    let session: NSURLSession!
    

    public init(serverURL: NSURL) {
        self.serverURL = serverURL;

        super.init()

        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    public func registerWithClientInfo(clientInfo: ((config: ClientDeviceInformation) -> Void)!,
        success:(() -> Void)!, failure:((NSError) -> Void)!) -> Void {
            
            // can't proceed with no configuration block set
            assert(clientInfo != nil, "configuration block not set")

            let clientInfoObject = ClientDeviceInformationImpl()
        
            clientInfo(config: clientInfoObject)
            
            assert(clientInfoObject.apiKey != nil, "'variantID' should be set")
            assert(clientInfoObject.apiSecret != nil, "'variantSecret' should be set");
            
            // set up our request
            let request = NSMutableURLRequest(URL: serverURL.URLByAppendingPathComponent("rest/installations"))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "POST"
            
            // apply HTTP Basic
            let basicAuthCredentials: NSData! = "\(clientInfoObject.apiKey!):\(clientInfoObject.apiSecret!)".dataUsingEncoding(NSUTF8StringEncoding)
            let base64Encoded = basicAuthCredentials.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
            
            request.setValue("Basic \(base64Encoded)", forHTTPHeaderField: "Authorization")
            
            // serialize request
            let postData = NSJSONSerialization.dataWithJSONObject(clientInfoObject.extractValues(), options:nil, error: nil)
            
            request.HTTPBody = postData
            
            let task = session.dataTaskWithRequest(request) {(data, response, error) in
                    if error != nil {
                        failure(error)
                        return
                    }
                    
                    // verity HTTP status
                    let httpResp = response as NSHTTPURLResponse

                    // did we succeed?
                    if httpResp.statusCode == 200 {
                        success()

                    } else { // nope, client request error (e.g. 401 /* Unauthorized */)
                        let userInfo = [NSLocalizedDescriptionKey : NSHTTPURLResponse.localizedStringForStatusCode(httpResp.statusCode),
                            DeviceRegistrationError.NetworkingOperationFailingURLRequestErrorKey: request,
                            DeviceRegistrationError.NetworkingOperationFailingURLResponseErrorKey: response];
                        
                        let error = NSError(domain:DeviceRegistrationError.GeoErrorDomain, code: NSURLErrorBadServerResponse, userInfo: userInfo)

                        failure(error)
                    }
            }
            
            task.resume()
    }
    
    /*
    // we need to cater for possible redirection
    //
    // NOTE:
    //      As per Apple doc, the passed req is 'the proposed redirected request'. But we cannot return it as it is. The reason is,
    //      user-agents (and in our case NSURLconnection) 'erroneous' after a 302-redirection modify the request's http method
    //      and sets it to GET if the client initially performed a POST (as we do here).
    //
    //      See  RFC 2616 (section 10.3.3) http://www.ietf.org/rfc/rfc2616.txt
    //      and related blog: http://tewha.net/2012/05/handling-302303-redirects/
    //
    //      We need to 'override' that 'default' behaviour to return the original attempted NSURLRequest
    //      with the URL parameter updated to point to the new 'Location' header.
    //
    */
    public func URLSession(session: NSURLSession!, task: NSURLSessionTask!, willPerformHTTPRedirection redirectResponse: NSHTTPURLResponse!, newRequest redirectReq: NSURLRequest!, completionHandler: ((NSURLRequest!) -> Void)!) {
        
        var request = redirectReq;

        if (redirectResponse != nil) { // we need to redirect
            // update URL of the original request
            // to the 'new' redirected one
            var origRequest = task.originalRequest.mutableCopy() as NSMutableURLRequest
            origRequest.URL = redirectReq.URL
            request = origRequest
        }
        
        completionHandler(request)
    }
}
