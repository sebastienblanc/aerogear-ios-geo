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
 * Represents the set of allowed device metadata.
 */
@objc 
public protocol AGClientDeviceInformation {
    
       
    /**
     * The ID of the mobile Variant, for which this client will be registered.
     */
    var variantID: String? { get set }
    
    /**
     * The mobile Variant's secret.
     */
    var variantSecret: String? { get set }
    
    /**
     * Application specific alias to identify users with the system.
     * E.g. email address or username
     */
    var alias: String? { get set }
    
    /**
    * Device's longitude
    */
    var longitude: NSNumber? { get set }

    /**
    * Device's latitude
    */
    var latitude: NSNumber? { get set }

    
    
}