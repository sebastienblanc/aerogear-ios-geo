# aerogear-ios-geo

**iOS Location Registration SDK for the AeroGear UnifiedGeo Server**

A small and handy library written in [Swift](https://developer.apple.com/swift/) that helps to register iOS applications with the AeroGear UnifiedGeo Server.

## Adding the library to your project 

TODO

### 1. Clone this repository

TODO

### 2. Add `AeroGearPush.xcodeproj` to your application target

TODO

### 4. Start writing your app!

If you run into any problems, please [file an issue](http://issues.jboss.org/browse/AEROGEAR) and/or ask our [user mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-users). You can also join our [dev mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-dev).  

## Example Usage

```swift
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        var localValue:CLLocationCoordinate2D = manager.location.coordinate
        
        let registration = AGDeviceRegistration(serverURL: NSURL(string: "http://192.168.1.19:8080/unified-geo-server")!)
        
        // attemp to register
        registration.registerWithClientInfo({ (clientInfo: AGClientDeviceInformation!) in
            // setup configuration
            clientInfo.alias = "sebI"
            clientInfo.apiKey = "fa7612b4-329c-417a-80e5-2a48eb44dde4"
            clientInfo.apiSecret = "8e82aaca-f733-4fbf-9834-16291d9eb726"
            
            
            clientInfo.longitude = localValue.longitude
            clientInfo.latitude = localValue.latitude
            },
            
            success: {
                println("UnifiedGeo Server registration succeeded")
                self.locationManager.stopUpdatingLocation()
            },
            failure: {(error: NSError!) in
                println("failed to register, error: \(error.description)")
        })

    }

}
```

