//
//  ViewController.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 12.12.19.
//  Copyright © 2019 Zintel, Marc. All rights reserved.
//  sollte alles soweit selbsterklärend sein

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {

    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var myLoc: MKMapView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.isHidden = true
        mapCalls()
        removeSearchLogo()
        
    }
}


// MARK: Extension
extension ViewController: CLLocationManagerDelegate, UISearchBarDelegate {
    
    func mapCalls() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        myLoc.userTrackingMode = .follow
        myLoc.showsUserLocation = true
    }
    
    private func locationManager(_ manager: CLLocationManager, didUpdatingHeading newHeading: CLHeading) {
           myLoc.camera.heading = newHeading.magneticHeading
           myLoc.setCamera(myLoc.camera, animated: true)
    
    }
       
    func removeSearchLogo() {
        searchBar.delegate = self
        // Remove the icon in search bar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffset(horizontal: 10, vertical: 0)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
            menuBtn.isHidden = true
            menuView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        menuBtn.isHidden = false
    }


    @IBAction func menuBtn(_ sender: Any) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        menuBtn.isHidden = false
        menuView.isHidden = !menuView.isHidden
        
    }
    
}
