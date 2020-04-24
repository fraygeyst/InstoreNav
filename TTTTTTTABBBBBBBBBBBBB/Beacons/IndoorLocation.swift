//
//  IndoorLocation.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 25.03.20.
//  Copyright © 2020 Zintel, Marc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth


class IndoorLocation: UIViewController, EILIndoorLocationManagerDelegate  {

        let locationManager = EILIndoorLocationManager()
        var location: EILLocation!


    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.locationManager.delegate = self
            
            
            //connection to Estimote Cloud, bei einer neuen App muss AppToken und setupID von Estimote Cloud neu generiert werden und diese hier ersetzen
            ESTConfig.setupAppID("<tttttttabbbbbbbbbbbbb-33l>", andAppToken: "acdfd3ae0d396ed937c3743c81775f0c")

            let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "baumarkt")
            fetchLocationRequest.sendRequest { (location, error) in
                if location != nil {
                    self.location = location!
                } else {
                    print("can't fetch location: \(error)")
                }
            }
        }
    
    

   func indoorLocationManager(manager: EILIndoorLocationManager!,
                               didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }

    func indoorLocationManager(manager: EILIndoorLocationManager!,
                               didUpdatePosition position: EILOrientedPoint!,
                               withAccuracy positionAccuracy: EILPositionAccuracy,
                               inLocation location: EILLocation!) {
        var accuracy: String!
        switch positionAccuracy {
            case .veryHigh: accuracy = "+/- 1.00m"
            case .high:     accuracy = "+/- 1.62m"
            case .medium:   accuracy = "+/- 2.62m"
            case .low:      accuracy = "+/- 4.24m"
            case .veryLow:  accuracy = "+/- ? :-("
            case .unknown:  accuracy = "unknown"
        }
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
            position.x, position.y, position.orientation, accuracy))
    }
    


}



   
