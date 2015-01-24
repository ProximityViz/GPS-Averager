//
//  ViewController.swift
//  GPS Averager
//
//  Created by Mollie on 1/24/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var autoOrManual: UISegmentedControl!
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentLatLabel: UILabel!
    @IBOutlet weak var currentLonLabel: UILabel!
    @IBOutlet weak var currentAltLabel: UILabel!
    @IBOutlet weak var avgLatLabel: UILabel!
    @IBOutlet weak var avgLonLabel: UILabel!
    @IBOutlet weak var avgAltLabel: UILabel!
    @IBOutlet weak var avgPointsLabel: UILabel!
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var manager:CLLocationManager!
    var autoIsRunning:Bool!
    var mode:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.autoIsRunning = false
        self.mode = "Auto"
        
        //MARK: Aesthetics
        
        self.startButton.layer.cornerRadius = 4
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = (UIColor (red:0.94, green:0.45, blue:0, alpha:1)).CGColor
        
        self.finishButton.layer.cornerRadius = 4
        self.finishButton.layer.borderWidth = 1
        self.finishButton.layer.borderColor = (UIColor (red:0.94, green:0.45, blue:0, alpha:1)).CGColor
        
        //MARK: Geolocation
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    @IBAction func changeMode(sender: UISegmentedControl) {
        
        var title = (self.autoOrManual.selectedSegmentIndex == 0) ? "Start" : "Add Point"
        self.mode = (self.autoOrManual.selectedSegmentIndex == 0) ? "Auto" : "Manual"
        self.startButton.setTitle(title, forState: UIControlState.Normal)
        
    }
    
    @IBAction func startWasPressed(sender: UIButton) {
        
        if self.mode == "Auto" && self.autoIsRunning == false {
            
            // mode is auto and has not begun yet
            // start averaging and change button to "Stop"
            self.autoIsRunning = true
            self.startButton.setTitle("Stop", forState: UIControlState.Normal)
            
            // change label colors and/or column heading text to indicate "current" point is current
            self.currentLabel.text = "Current"
            
        } else if self.mode == "Auto" && self.autoIsRunning == true {
            
            // mode is auto and has been running
            // stop averaging and change button to "Start"
            // FIXME: decide if hitting the button again should restart or resume, and change text accordingly, and make sure it works properly
            
            self.autoIsRunning = false
            self.startButton.setTitle("Start", forState: UIControlState.Normal)
            // TODO: maybe change button color?
            
            // change label colors and/or column heading text to indicate "current" point is old
            self.currentLabel.text = "Most Recent"

            
        } else if self.mode == "Manual" {
            
            // FIXME: Manual mode not working yet
            // have the currentlat, currentlon, and currentalt flash briefly in a different color when "Add Point" is pressed
            // add point to array for averaging
        }
        
    }
    
    @IBAction func finishWasPressed(sender: UIButton) {

    
    
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as CLLocation
        
        if self.autoIsRunning == true {
            
            // TODO: Make sure lat & lon have same number of digits and are right-aligned, so decimals will line up
            currentLatLabel.text = "\(userLocation.coordinate.latitude) \u{00B0}"
            currentLonLabel.text = "\(userLocation.coordinate.longitude) \u{00B0}"
            currentAltLabel.text = "\(userLocation.altitude) m"
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

