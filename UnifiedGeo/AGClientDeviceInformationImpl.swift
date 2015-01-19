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

/**
 * Internal implementation of the AGClientDeviceInformation protocol
 */
class AGClientDeviceInformationImpl: NSObject, AGClientDeviceInformation {
    
    var variantID: String?
    var variantSecret: String?
    var alias: String?
    var longitude: NSNumber?
    var latitude: NSNumber?
    
    override init() {
        super.init()        
    }
    
    func extractValues() -> [String: AnyObject] {
        var jsonObject =  [String: AnyObject]()
        
        jsonObject["alias"] = alias
        jsonObject["longitude"] = longitude
        jsonObject["latitude"] = latitude
        
        return jsonObject;
    }
    
       
}