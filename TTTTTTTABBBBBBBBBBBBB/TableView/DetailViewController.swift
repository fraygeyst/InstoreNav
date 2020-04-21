//
//  DetailViewController.swift
//  TTTTTTTABBBBBBBBBBBBB
//
//  Created by Zintel, Marc on 12.12.19.
//  Copyright © 2019 Zintel, Marc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailnameLabel: UILabel!
    @IBOutlet weak var detailbrandLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var CoordinatesLabel: UILabel!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var NavigateBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBtnLayout()
        detailnameLabel.text = data[myIndex]
        detailbrandLabel.text = "Info"
        CoordinatesLabel.text = longitudedetailview[myIndex] + ", " + latitudedetailview[myIndex]
    }
    
    @IBAction func BackBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func NavBtnLayout() {
        NavigateBtn.layer.cornerRadius = 5
    }
    
}
