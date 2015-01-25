//
//  ViewController.swift
//  GPS Averager
//
//  Created by Mollie on 1/24/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import CoreLocation

var savedAverages = [[String:String]]()

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
    var isRunning:Bool!
    var mode:String!
    
    var latitudes = [Float]()
    var longitudes = [Float]()
    var altitudes = [Float]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isRunning = false
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
        self.isRunning = (self.autoOrManual.selectedSegmentIndex == 0) ? false : true
        self.startButton.setTitle(title, forState: UIControlState.Normal)
        
    }
    
    @IBAction func startWasPressed(sender: UIButton) {
        
        if self.mode == "Auto" && self.isRunning == false {
            
            // mode is auto and has not begun yet
            // start averaging and change button to "Stop"
            self.isRunning = true
            self.startButton.setTitle("Stop", forState: UIControlState.Normal)
            
            // change label colors and/or column heading text to indicate "current" point is current
            self.currentLabel.text = "Current"
            
        } else if self.mode == "Auto" && self.isRunning == true {
            
            // mode is auto and has been running
            // stop averaging and change button to "Start"
            // FIXME: decide if hitting the button again should restart or resume, and change text accordingly, and make sure it works properly
            
            self.isRunning = false
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
        
        if self.isRunning == true {
            
            // FIXME: Is there a better way of rounding so we don't have to do all this modulo stuff?
            // If not, move this code to its own function that will be run any time we need to return a string for a label.
            var decimalPlaces = 1000000.0
            var latitude = round(userLocation.coordinate.latitude * decimalPlaces) / decimalPlaces
            var longitude = round(userLocation.coordinate.longitude * decimalPlaces) / decimalPlaces
            
            var latZero:String
            var lonZero:String
            
            if latitude * decimalPlaces % 100 == 0 {
                latZero = "00"
            } else if latitude * decimalPlaces % 10 == 0 {
                latZero = "0"
            } else {
                latZero = ""
            }
            
            if longitude * decimalPlaces % 100 == 0 {
                lonZero = "00"
            } else if longitude * decimalPlaces % 10 == 0 {
                lonZero = "0"
            } else {
                lonZero = ""
            }
            
            currentLatLabel.text = "\(latitude)\(latZero) \u{00B0}"
            currentLonLabel.text = "\(longitude)\(lonZero) \u{00B0}"
            currentAltLabel.text = "\(userLocation.altitude) m"
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

