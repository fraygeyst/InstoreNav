//
//  AppDelegate.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 12.12.19.
//  Copyright © 2019 Zintel, Marc. All rights reserved.
//

import UIKit
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, UNUserNotificationCenterDelegate, EILBackgroundIndoorLocationManagerDelegate {

        var window: UIWindow?
        let beaconManager = ESTBeaconManager()
        let center = UNUserNotificationCenter.current()

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
      
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            //indoor Location aufsetzen
            let locationBuilder = EILLocationBuilder()
            locationBuilder.setLocationName("Estimote's Marcs office")

            locationBuilder.setLocationBoundaryPoints([
            EILPoint(x: 0.00, y: 0.00),
            EILPoint(x: 0.00, y: 9.85),
            EILPoint(x: 4.56, y: 9.85),
            EILPoint(x: 4.56, y: 0.00)])
        
            //Eckpunkte festlegen
            locationBuilder.addBeacon(withIdentifier: "F83BE8EA-5059-1A94-49A5-8B5B3A739236",
                atBoundarySegmentIndex: 0, inDistance: 3.5, fromSide: .LeftSide) //D5
            locationBuilder.addBeacon(withIdentifier: "A278A6C4-E3FF-5078-5C74-1478149D0B0F",
                atBoundarySegmentIndex: 1, inDistance: 1.1, fromSide: .RightSide) //D3
            locationBuilder.addBeacon(withIdentifier: "0C20261C-E4C0-1D72-2204-63865F272225",
                atBoundarySegmentIndex: 2, inDistance: 5.7, fromSide: .LeftSide)  //D1
            locationBuilder.addBeacon(withIdentifier: "05cf51b88a49856923f22b50ab1cdf24",
                atBoundarySegmentIndex: 3, inDistance: 2.4, fromSide: .RightSide) //D2
            
            locationBuilder.setLocationOrientation(50)

            //Build
            let location = locationBuilder.build()!

            //App über Estimote Cloud
            ESTConfig.setupAppID("<tttttttabbbbbbbbbbbbb-33l>", andAppToken: "acdfd3ae0d396ed937c3743c81775f0c")
            let addLocationRequest = EILRequestAddLocation(location: location)
            addLocationRequest.sendRequest { (location, error) in
                if error != nil {
                    NSLog("Error when saving location: \(error)")
                } else {
                    NSLog("Location saved successfully: \(location.identifier)")
                }
            }
        
        
            UIApplication.shared.registerUserNotificationSettings(
            UIUserNotificationSettings(types: .alert, categories: nil))

            self.beaconManager.delegate = self
            self.beaconManager.requestAlwaysAuthorization()
            
            //Beispiel Beacon
            self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: UUID(uuidString: "F83BE8EA-5059-1A94-49A5-8B5B3A739236")!,
            major: 56722, minor: 32976, identifier: "Estimote D5"))
           
        return true
    }

    //Eine Beispiel-Pushbenachrichtigung, weiss jedoch nicht ob sowas notwendig wäre, theoretisch aber möglich
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        let notification = UILocalNotification()
        notification.alertBody =
            "Toastbrot ist leer."
        UIApplication.shared.presentLocalNotificationNow(notification)
    }

    //s. Anmerkung obendrüber, eher nicht notwendig
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Toastbrot leer"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")

            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                break

            default:
                break
            }
        }

        //Kompletten Handler aufrufen wenn fertig
        completionHandler()
    }
    
    //Indoormap ab hier
    let backgroundIndoorManager = EILBackgroundIndoorLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ESTConfig.setupAppID("<tttttttabbbbbbbbbbbbb-33l>", andAppToken: "acdfd3ae0d396ed937c3743c81775f0c")

        self.backgroundIndoorManager.delegate = self
        self.backgroundIndoorManager.requestAlwaysAuthorization()

        let fetchLocation = EILRequestFetchLocation(locationIdentifier: "my-kitchen")
        fetchLocation.sendRequest { (location, error) in
            if let location = location {
                self.backgroundIndoorManager.startPositionUpdates(for: location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }

    func backgroundIndoorLocationManager(
            _ locationManager: EILBackgroundIndoorLocationManager,
            didFailToUpdatePositionWithError error: Error) {
        print("failed to update position: \(error)")
    }

    func backgroundIndoorLocationManager(
            _ manager: EILBackgroundIndoorLocationManager,
            didUpdatePosition position: EILOrientedPoint,
            with positionAccuracy: EILPositionAccuracy,
            in location: EILLocation) {
    }


}

