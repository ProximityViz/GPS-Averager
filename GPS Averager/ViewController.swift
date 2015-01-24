//
//  ViewController.swift
//  GPS Averager
//
//  Created by Mollie on 1/24/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var autoOrManual: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startButton.layer.cornerRadius = 4
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = (UIColor (red:0.94, green:0.45, blue:0, alpha:1)).CGColor
        
        self.finishButton.layer.cornerRadius = 4
        self.finishButton.layer.borderWidth = 1
        self.finishButton.layer.borderColor = (UIColor (red:0.94, green:0.45, blue:0, alpha:1)).CGColor
        
    }
    
    @IBAction func changeMode(sender: UISegmentedControl) {
        
        var title = (self.autoOrManual.selectedSegmentIndex == 0) ? "Start" : "Add"
        self.startButton.setTitle(title, forState: UIControlState.Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

