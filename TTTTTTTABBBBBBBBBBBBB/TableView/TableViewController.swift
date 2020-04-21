//
//  TableViewController.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 12.12.19.
//  Copyright © 2019 Zintel, Marc. All rights reserved.
//
// Controller für das Befüllen und Initialisieren der TableView

import UIKit
import MapKit
    

// Beispiel Daten in verschiedenen Arrays, weil es ja andauernd diese TableView Probleme gab
// nicht sehr elegant aber immerhin hat es so funktioniert
    var data = ["Schrauben", "Dübel", "Holzleim", "Fliesen", "Blumenerde", "Sanitär", "Topfpflanze"]
    var randomoldprice = ["1.70", "0.60", "2.31", "7.50", "2.00", "34.70", "4,99"]
    var randomprice = ["1.40", "0.45", "2.00", "6.50", "1.80", "29.99", "4,98"]
    var longitudedetailview = ["49.273254", "49.273254", "49.273254", "49.273254", "49.273254", "49.273254", "49.273254"]
    var latitudedetailview = ["7.109302", "7.109302", "7.109302", "7.109302", "7.109302", "7.109302", "7.109302"]
    let reuseIdentifier = "reuseIdentifier"
    var myIndex = Int()
    let latitudes:[CLLocationDegrees] = [60.444, 44.555, 55.2, 21.222, 3.33]
    let longitudes:[CLLocationDegrees] = [60.444, 44.555, 55.2, 21.222, 3.33]
    //let coordinates = CLLocationCoordinate2DMake(latitudes, longitudes)
    

class TableViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewdelegates()
    }

}


//MARK: EXTENSIONS
//Delegates und Standard-TableView Befüllung
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        myIndex = indexPath.row
        cell.nameProd.text = data[indexPath.row]
        cell.brandProd.text = "Info"
        cell.priceLabel.text = randomprice[indexPath.row]+"€"
        cell.oldPriceLabel.text = randomoldprice[indexPath.row]+"€"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    
    func tableViewdelegates() {
        myTableView.delegate = self
        myTableView.dataSource = self
        
    }

}
