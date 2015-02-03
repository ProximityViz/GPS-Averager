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

var coordFormat:String!

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
    var mode:String!
    
    var LatLon: (latitude: Double, longitude: Double, latString: String, lonString:String)!
    var userLocation:CLLocation!
    
    var latitudes = [Double]()
    var longitudes = [Double]()
    var altitudes = [Float]()
    
    var manualLats = [Double]()
    var manualLons = [Double]()
    var manualAlts = [Float]()
    
    let regularColor = UIColor.blackColor()
    let boldColor = UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewWillAppear(animated: Bool) {
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
        // reset labels
        resetLabels()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: These defaults will change once the user has the option of defaulting to manual mode
        isRunning = false
        mode = "Auto"
        startButton.setTitle("Start", forState: UIControlState.Normal)
        
        if coordFormat == nil {
            coordFormat = "Decimal degrees"
        }
        
        // MARK: NSUserDefaults
//        if (defaults.objectForKey("savedAverages") != nil) {
            savedAverages = defaults.objectForKey("savedAverages") as Array
//        }
        
        // MARK: Geolocation
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
        // MARK: Aesthetics
        startButton.layer.cornerRadius = 4
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = (UIColor (red:1.00, green:0.23, blue:0.19, alpha:1)).CGColor
        
        finishButton.layer.cornerRadius = 4
        finishButton.layer.borderWidth = 1
        finishButton.layer.borderColor = (UIColor (red:1.00, green:0.23, blue:0.19, alpha:1)).CGColor
        
    }
    
    @IBAction func changeMode(sender: UISegmentedControl) {
        
        // check for unsaved data
        if latitudes.count != 0 {
            
            isRunning = false
            displayAlert("changeMode")
            
        } else {
            
            // TODO: make sure part of this also runs when you click "no" on the alert
            
            var title = (autoOrManual.selectedSegmentIndex == 0) ? "Start" : "Add Point"
            mode = (autoOrManual.selectedSegmentIndex == 0) ? "Auto" : "Manual"
            currentLabel.text = (autoOrManual.selectedSegmentIndex == 0) ? "Most Recent" : "Current"
            isRunning = (autoOrManual.selectedSegmentIndex == 0) ? false : true
            startButton.setTitle(title, forState: UIControlState.Normal)
            
        }
        
    }
    
    @IBAction func startWasPressed(sender: UIButton) {
        
        if mode == "Auto" && isRunning == false {
            
            // mode is auto and has not begun yet
            // start averaging and change button to "Stop"
            isRunning = true
            startButton.setTitle("Pause", forState: UIControlState.Normal)
            
            // change label colors and/or column heading text to indicate "current" point is current
            currentLabel.text = "Current"
            
        } else if mode == "Auto" && isRunning == true {
            
            // mode is auto and has been running
            // stop averaging and change button
            isRunning = false
            startButton.setTitle("Resume", forState: UIControlState.Normal)
            
            currentLabel.text = "Most Recent"

            
        } else if mode == "Manual" {
            
            // MARK: Change labels and map points for Manual mode
            manualLats.append(LatLon.latitude)
            manualLons.append(LatLon.longitude)
            manualAlts.append(Float(userLocation.altitude))
            
            currentLatLabel.textColor = boldColor
            currentLonLabel.textColor = boldColor
            currentAltLabel.textColor = boldColor
            
            // change "average" labels
            let avgCoords = Functions.averageCoordinates(manualLats, longitudes: manualLons)
            let latLonString = Functions.formatCoordinateString(lat: avgCoords.avgLat, lon: avgCoords.avgLon)
            let avgAlt = Functions.averageOf(manualAlts)
            
            avgLatLabel.text = latLonString.latString
            avgLonLabel.text = latLonString.lonString
            avgAltLabel.text = "\(avgAlt)"
            avgPointsLabel.text = "\(manualLats.count)"
            
            // map points
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
    
    @IBAction func finishWasPressed(sender: AnyObject) {
        
        // format date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .LongStyle
        let formattedDate = dateFormatter.stringFromDate(NSDate())
        
        var avgCoords: (avgLat: Double, avgLon: Double)!
        var avgAlt:Float = 0.0
        var points:Int = 0
        
        if mode == "Auto" {
            
            isRunning = false
            
            avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
            
            // average the altitudes
            avgAlt = Functions.averageOf(altitudes)
            points = latitudes.count
            
        } else {
            
            avgCoords = Functions.averageCoordinates(manualLats, longitudes: manualLons)
            avgAlt = Functions.averageOf(manualAlts)
            points = manualLats.count
            
        }
        
        savedAverages.insert(["Latitude" : "\(avgCoords.avgLat)", "Longitude" : "\(avgCoords.avgLon)", "Altitude": "\(avgAlt) m", "Points" : "\(points)", "Date" : "\(formattedDate)"], atIndex: 0)
        defaults.setValue(savedAverages, forKey: "savedAverages")
        
        // reset
        resetPoints()
        avgPointsLabel.text = ""
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        userLocation = locations[0] as CLLocation
        
        // MARK: Center and zoom
        if latitudes.count == 0 && manualLats.count == 0 {
            
            // zoom and center map to userLocation
            var mapLat:CLLocationDegrees = userLocation.coordinate.latitude
            var mapLon:CLLocationDegrees = userLocation.coordinate.longitude
            var span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
            var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            mapView.setRegion(region, animated: true)
            
        } else {
            
            // zoom to annotations
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
        
        // MARK: Collect points
        if isRunning == true {
            
            LatLon = Functions.formatCoordinateString(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
            
            // MARK: Add point to arrays
            latitudes.append(LatLon.latitude)
            longitudes.append(LatLon.longitude)
            altitudes.append(Float(userLocation.altitude))
            
            // change "current" labels
            currentLatLabel.textColor = regularColor
            currentLonLabel.textColor = regularColor
            currentAltLabel.textColor = regularColor
            currentLatLabel.text = LatLon.latString
            currentLonLabel.text = LatLon.lonString
            currentAltLabel.text = "\(userLocation.altitude) m"
            
            // MARK: Change labels and map points for Auto mode
            if mode == "Auto" {
                
                // change "average" labels
                let avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
                let latLonString = Functions.formatCoordinateString(lat: avgCoords.avgLat, lon: avgCoords.avgLon)
                let avgAlt = Functions.averageOf(altitudes)
                
                avgLatLabel.text = latLonString.latString
                avgLonLabel.text = latLonString.lonString
                avgAltLabel.text = "\(avgAlt)"            
                avgPointsLabel.text = "\(latitudes.count)"
                
                // map points
                var mapLat:CLLocationDegrees = userLocation.coordinate.latitude
                var mapLon:CLLocationDegrees = userLocation.coordinate.longitude
                var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
                var annotation = MKPointAnnotation()
                annotation.coordinate = location
                
                mapView.addAnnotation(annotation)
                
            }
            
        }
        
    }
    
    func resetLabels() {
    
        // should this reset to "current"?
        //        currentLabel.text = ""
        currentLatLabel.text = ""
        currentLonLabel.text = ""
        currentAltLabel.text = ""
        avgLatLabel.text = ""
        avgLonLabel.text = ""
        avgAltLabel.text = ""
        avgPointsLabel.text = ""
        startButton.setTitle("Start", forState: UIControlState.Normal)
        
    }
    
    func resetPoints() {
        
        latitudes = []
        longitudes = []
        altitudes = []
        manualLats = []
        manualLons = []
        manualAlts = []
        
    }
    
    func displayAlert(navigatingTo: String) {
        
        let alertController = UIAlertController(title: "Your Points Have Not Been Saved", message: "Would you like to save them now?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            // reset points
            self.resetPoints()
            self.resetLabels()
            
            // segue to whatever was tapped on:
            if navigatingTo == "changeMode" {
                self.changeMode(self.autoOrManual)
            } else if navigatingTo == "savedCoords" {
                self.performSegueWithIdentifier("savedCoordsSegue", sender: self)
            }
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            self.finishWasPressed(self)
            self.performSegueWithIdentifier("finishSegue", sender: self)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier! == "savedCoordsSegue" {
            
//            displayAlert("savedCoords")
            
            // check for unsaved data
            if latitudes.count != 0 {

                isRunning = false
                displayAlert("savedCoords")
                return false

            } else {
                return true
            }
            
            
        }
        
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

