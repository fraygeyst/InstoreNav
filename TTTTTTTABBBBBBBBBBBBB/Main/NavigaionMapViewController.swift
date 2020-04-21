//
//  NavigaionMapViewController.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 23.01.20.
//  Copyright © 2020 Zintel, Marc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ARKit


class NavigaionMapViewController: UIViewController {
  fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var myLoc: MKMapView!
    @IBOutlet weak var CancelView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var arSwitch: UISwitch!
    @IBOutlet weak var navtoprod: UILabel!
    
    @IBOutlet weak var CancelNo: UIButton!
    @IBOutlet weak var CancelYes: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CancelView.isHidden = true
        mapCalls()
        navtoprod.text = data[myIndex]
    
        }
    

}

extension NavigaionMapViewController: CLLocationManagerDelegate {
    
    func mapCalls() {
           let annotation = MKPointAnnotation()
           locationManager.delegate = self
           locationManager.requestWhenInUseAuthorization()
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.distanceFilter = kCLDistanceFilterNone
           locationManager.startUpdatingLocation()
           locationManager.startUpdatingHeading()
           myLoc.userTrackingMode = .follow
           myLoc.showsUserLocation = true
        annotation.coordinate = CLLocationCoordinate2D(latitude: 49.273254, longitude: 7.109302)
           myLoc.addAnnotation(annotation)

       }
       
       private func locationManager(_ manager: CLLocationManager, didUpdatingHeading newHeading: CLHeading) {
              myLoc.camera.heading = newHeading.magneticHeading
              myLoc.setCamera(myLoc.camera, animated: true)
          }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        CancelView.isHidden = false
    }
    
    @IBAction func CancelYes(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func CancelNo(_ sender: Any) {
        CancelView.isHidden = true
       }
    
    @IBAction func arSwitch(_ sender: UISwitch) {
        if (sender.isOn) == true {
            myLoc.isHidden = true
        }
        else {
            myLoc.isHidden = false
        }
      }
      
    
}
