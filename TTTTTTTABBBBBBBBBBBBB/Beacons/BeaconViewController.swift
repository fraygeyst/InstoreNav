//
//  BeaconViewController.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 16.12.19.
//  Copyright © 2019 Zintel, Marc. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

    
class BeaconViewController: UIViewController {

    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        //Generiert von Estimote Cloud zur Verknüpfung
        proximityUUID: UUID(uuidString: "F83BE8EA-5059-1A94-49A5-8B5B3A739236")!,
        identifier: "Estimote D5")
  
    
    var locationManager: CLLocationManager!
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var enabled = false
    let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: false)]
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              self.beaconManager.startRangingBeacons(in: self.beaconRegion)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
              super.viewDidDisappear(animated)
              self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
        
    }
    
    
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return nearbyContent.count
        }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath)

            let titleLabel = cell.viewWithTag(1) as! UILabel
            let subtitleLabel = cell.viewWithTag(2) as! UILabel

            let title = nearbyContent[indexPath.item].title
            let subtitle = nearbyContent[indexPath.item].subtitle

            cell.backgroundColor = Utils.color(forColorName: title)

            titleLabel.text = title
            subtitleLabel.text = subtitle

            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let maxWidth = collectionView.frame.width - 20
            let maxHeight = collectionView.frame.height - (collectionView.layoutMargins.top + collectionView.layoutMargins.bottom)
            let singleCellHeight = maxHeight / CGFloat(nearbyContent.count) - (collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing

            return CGSize(width: maxWidth, height: singleCellHeight)
        }
    
    
}


extension BeaconViewController: CLLocationManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate, CBCentralManagerDelegate, UIApplicationDelegate, ESTBeaconManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "")")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOff {
            stopBroadcasting()
        }
    }
    
    func stopBroadcasting() {
        peripheralManager.stopAdvertising()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("connect")
    }
    
    //delegates etc um sie in einer einzigen Klasse beim Appstart auszuführen. Übersichtlichkeit im Main Code
    func helper() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        centralManager.delegate = self
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    

    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
            case .immediate:
                self.view.backgroundColor = UIColor.red
            case .near:
                self.view.backgroundColor = UIColor.orange
            case .far:
                self.view.backgroundColor = UIColor.black
            @unknown default:
                self.view.backgroundColor = UIColor.gray
            }
        }
    }
    
    //Looking for closest beacon
    func placesNearBeacon(_ beacon: CLBeacon) -> [String]? {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sorted { $0.1 < $1.1 }.map { $0.0 }
            return sortedPlaces
        }
        return nil
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],in region: CLBeaconRegion) {
        if let nearestBeacon = beacons.first, let places = placesNearBeacon(nearestBeacon) {
           print(places) // TODO: remove after implementing the UI
       }
   }
    
}
