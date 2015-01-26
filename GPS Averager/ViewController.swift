//
//  ViewController.swift
//  GPS Averager
//
//  Created by Mollie on 1/24/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var savedAverages = [[String:String]]()

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var autoOrManual: UISegmentedControl!
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentLatLabel: UILabel!
    @IBOutlet weak var currentLonLabel: UILabel!
    @IBOutlet weak var currentAltLabel: UILabel!
    @IBOutlet weak var avgLatLabel: UILabel!
    @IBOutlet weak var avgLonLabel: UILabel!
    @IBOutlet weak var avgAltLabel: UILabel!
    @IBOutlet weak var avgPointsLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var manager:CLLocationManager!
    var isRunning:Bool!
    var mapCentered:Bool!
    var mode:String!
    
    var latitudes = [Double]()
    var longitudes = [Double]()
    var altitudes = [Float]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewWillAppear(animated: Bool) {
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: These defaults will change once the user has the option of defaulting to manual mode
        self.isRunning = false
        self.mapCentered = false
        self.mode = "Auto"
        self.startButton.setTitle("Start", forState: UIControlState.Normal)
        savedAverages = defaults.objectForKey("savedAverages") as Array
        
        // MARK: Geolocation
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
        // MARK: Aesthetics
        
        self.startButton.layer.cornerRadius = 4
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = (UIColor (red:1.00, green:0.23, blue:0.19, alpha:1)).CGColor
        
        self.finishButton.layer.cornerRadius = 4
        self.finishButton.layer.borderWidth = 1
        self.finishButton.layer.borderColor = (UIColor (red:1.00, green:0.23, blue:0.19, alpha:1)).CGColor
        
    }
    
    @IBAction func changeMode(sender: UISegmentedControl) {
        
        var title = (self.autoOrManual.selectedSegmentIndex == 0) ? "Start" : "Add Point"
        self.mode = (self.autoOrManual.selectedSegmentIndex == 0) ? "Auto" : "Manual"
        self.currentLabel.text = (self.autoOrManual.selectedSegmentIndex == 0) ? "Most Recent" : "Current"
        self.isRunning = false
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
        
        self.isRunning = false
        
        let avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
        
        // average the altitudes
        // FIXME: is there a built-in average function?
        let avgAlt = Functions.averageOf(altitudes)
        
        // format date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .LongStyle
        let formattedDate = dateFormatter.stringFromDate(NSDate())
        
        
        savedAverages.append(["Latitude" : "\(avgCoords.avgLat)", "Longitude" : "\(avgCoords.avgLon)", "Altitude": "\(avgAlt) m", "Points" : "\(latitudes.count)", "Date" : "\(formattedDate)"])
//        defaults.setObject(savedAverages, forKey: "savedAverages")
        defaults.setValue(savedAverages, forKey: "savedAverages")
        
        // reset
        latitudes = []
        longitudes = []
        altitudes = []
        self.avgPointsLabel.text = ""
        
    
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as CLLocation
        
        if !mapCentered {
            
            // MARK: Zoom and center map
            var mapLat:CLLocationDegrees = userLocation.coordinate.latitude
            var mapLon:CLLocationDegrees = userLocation.coordinate.longitude
            var span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            mapView.setRegion(region, animated: true)
            mapCentered = true
            
        }
        
        
        // MARK: Collect points
        if self.isRunning == true {
            
            let LatLon = Functions.formatCoordinateString(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
            
            currentLatLabel.text = LatLon.latString
            currentLonLabel.text = LatLon.lonString
            currentAltLabel.text = "\(userLocation.altitude) m"
            
            // MARK: Add point to arrays
            latitudes.append(LatLon.latitude)
            longitudes.append(LatLon.longitude)
            altitudes.append(Float(userLocation.altitude))
            
            // MARK: Change "average" labels
            let avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
            let latLonString = Functions.formatCoordinateString(lat: avgCoords.avgLat, lon: avgCoords.avgLon)
            let avgAlt = Functions.averageOf(altitudes)
            
            avgLatLabel.text = latLonString.latString
            avgLonLabel.text = latLonString.lonString
            avgAltLabel.text = "\(avgAlt)"            
            avgPointsLabel.text = "\(latitudes.count)"
            
            // MARK: map points
            var mapLat:CLLocationDegrees = userLocation.coordinate.latitude
            var mapLon:CLLocationDegrees = userLocation.coordinate.longitude
            // TODO: change span to reflect where points are
            var span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            var annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(annotation)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

