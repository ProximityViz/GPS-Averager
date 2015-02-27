//
//  NewVC.swift
//  GPS Averager
//
//  Created by Mollie on 1/24/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var savedAverages = [[String:AnyObject]]()

var coordFormat:String!
var trackingMode:String!
var baseMap:String!

// NSUserDefaults:

// "savedAverages": [String:String]
// "coordFormat": String
// "trackingMode": String
let defaults = NSUserDefaults.standardUserDefaults()

class NewVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentLatLabel: UILabel!
    @IBOutlet weak var currentLonLabel: UILabel!
    @IBOutlet weak var currentAltLabel: UILabel!
    @IBOutlet weak var avgLatLabel: UILabel!
    @IBOutlet weak var avgLonLabel: UILabel!
    @IBOutlet weak var avgAltLabel: UILabel!
    @IBOutlet weak var avgPointsLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var manager:CLLocationManager!
    var isRunning:Bool!
    
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
    
    override func viewWillAppear(animated: Bool) {
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
        // reset labels
        resetLabels()
        
        // MARK: NSUserDefaults
        // TODO: Refactor this
        if defaults.objectForKey("savedAverages") != nil {
            savedAverages = defaults.objectForKey("savedAverages") as Array
        }
        if defaults.objectForKey("baseMap") != nil {
            baseMap = defaults.objectForKey("baseMap") as String
        } else {
            defaults.setValue("Standard", forKey: "baseMap")
            baseMap = "Standard"
        }
        if defaults.objectForKey("trackingMode") != nil {
            trackingMode = defaults.objectForKey("trackingMode") as String
        } else {
            defaults.setValue("Auto", forKey: "trackingMode")
            trackingMode = "Auto"
        }
        if defaults.objectForKey("coordFormat") != nil {
            coordFormat = defaults.objectForKey("coordFormat") as String
        } else {
            defaults.setValue("Decimal degrees", forKey: "coordFormat")
            coordFormat = "Decimal degrees"
        }
        if defaults.objectForKey("baseMap") != nil {
            baseMap = defaults.objectForKey("baseMap") as String
        } else {
            defaults.setValue("Streets", forKey: "baseMap")
            baseMap = "Streets"
        }
        
        // TODO: refactor?
        switch baseMap {
        case "Hybrid":
            mapView.mapType = MKMapType.Hybrid
        case "Satellite":
            mapView.mapType = MKMapType.Satellite
        default:
            mapView.mapType = MKMapType.Standard
        }
        
        // TODO: Refactor this: if trackingMode == Auto then a bunch of things
        var title = (trackingMode == "Auto") ? "Start" : "Add Point"
        currentLabel.text = (trackingMode == "Auto") ? "Most Recent" : "Current"
        isRunning = (trackingMode == "Auto") ? false : true
        startButton.setTitle(title, forState: UIControlState.Normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: These defaults will change once the user has the option of defaulting to manual mode
        isRunning = false
        startButton.setTitle("Start", forState: UIControlState.Normal)
        
        // MARK: Geolocation
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        tabBarController?.delegate = self
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
        // MARK: Aesthetics
        commentTextField.layer.cornerRadius = 4
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor.grayColor().CGColor
        
        startButton.layer.cornerRadius = 4
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = (UIColor (red:1.00, green:0.23, blue:0.19, alpha:1)).CGColor
        
        finishButton.layer.cornerRadius = 4
        finishButton.layer.borderWidth = 1
        finishButton.layer.borderColor = UIColor.grayColor().CGColor
        
    }
    
    // MARK: Keyboard sliding
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if let tabBarHeight = tabBarController?.tabBar.frame.height {
                    view.frame.origin.y = -(keyboardSize.height - tabBarHeight)
                    
                } else {
                    view.frame.origin.y = -keyboardSize.height
                }
            }
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    // MARK: Buttons
    @IBAction func startWasPressed(sender: UIButton) {
        
        // TODO: change color of "Finish" button to red here & grey by default
        
        finishButton.layer.borderColor = (UIColor (red:1.00, green:0.23, blue:0.19, alpha:1)).CGColor
        finishButton.setTitleColor(UIColor (red:1.00, green:0.23, blue:0.19, alpha:1), forState: UIControlState.Normal)
        
        if trackingMode == "Auto" && isRunning == false {
            
            // mode is auto and has not begun yet
            // start averaging and change button to "Stop"
            isRunning = true
            startButton.setTitle("Pause", forState: UIControlState.Normal)
            
            // change label colors and/or column heading text to indicate "current" point is current
            currentLabel.text = "Current"
            
        } else if trackingMode == "Auto" && isRunning == true {
            
            // mode is auto and has been running
            // stop averaging and change button
            isRunning = false
            startButton.setTitle("Resume", forState: UIControlState.Normal)
            
            currentLabel.text = "Most Recent"
            
            
        } else if trackingMode == "Manual" {
            
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
            let mapLat:CLLocationDegrees = userLocation.coordinate.latitude
            let mapLon:CLLocationDegrees = userLocation.coordinate.longitude
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    @IBAction func finishWasPressed(sender: AnyObject) {
        
        if latitudes.count == 0 && manualLats.count == 0 {
            
            // transition and don't save anything
            displayFinishAlert()
            
        }
        
        // format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .LongStyle
        let formattedDate = dateFormatter.stringFromDate(NSDate())
        
        var avgCoords: (avgLat: Double, avgLon: Double)!
        var avgAlt:Float = 0.0
        var points:Int = 0
        
        if trackingMode == "Auto" {
            
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
        
        // only save if there are points
        if latitudes.count != 0 || manualLats.count != 0 {
            
            savedAverages.insert([
                "Latitude" : "\(avgCoords.avgLat)",
                "Longitude" : "\(avgCoords.avgLon)",
                "Altitude": "\(avgAlt) m",
                "Points" : "\(points)",
                "All Points": [latitudes, longitudes, altitudes],
                "Comment": commentTextField.text,
                "Date" : "\(formattedDate)"
                ], atIndex: 0)
            defaults.setValue(savedAverages, forKey: "savedAverages")
            
        }
        
        // reset
        resetPoints()
        avgPointsLabel.text = ""
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        userLocation = locations[0] as CLLocation
        
        // MARK: Center and zoom
        if latitudes.count == 0 && manualLats.count == 0 {
            
            // zoom and center map to userLocation
            let mapLat:CLLocationDegrees = userLocation.coordinate.latitude
            let mapLon:CLLocationDegrees = userLocation.coordinate.longitude
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            mapView.setRegion(region, animated: true)
            
        } else {
            
            // zoom to annotations
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
        
        // MARK: Collect points
        if isRunning == true {
            
            LatLon = Functions.formatCoordinateString(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
            
            // change "current" labels
            currentLatLabel.textColor = regularColor
            currentLonLabel.textColor = regularColor
            currentAltLabel.textColor = regularColor
            currentLatLabel.text = LatLon.latString
            currentLonLabel.text = LatLon.lonString
            currentAltLabel.text = "\(userLocation.altitude) m"
            
            // MARK: Change labels and map points for Auto mode
            if trackingMode == "Auto" {
                
                // MARK: Add point to arrays
                latitudes.append(LatLon.latitude)
                longitudes.append(LatLon.longitude)
                altitudes.append(Float(userLocation.altitude))
                
                // change "average" labels
                let avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
                let latLonString = Functions.formatCoordinateString(lat: avgCoords.avgLat, lon: avgCoords.avgLon)
                let avgAlt = Functions.averageOf(altitudes)
                
                avgLatLabel.text = latLonString.latString
                avgLonLabel.text = latLonString.lonString
                avgAltLabel.text = "\(avgAlt)"
                avgPointsLabel.text = "\(latitudes.count)"
                
                // map points
                let mapLat:CLLocationDegrees = userLocation.coordinate.latitude
                let mapLon:CLLocationDegrees = userLocation.coordinate.longitude
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                
                mapView.addAnnotation(annotation)
                
            }
            
        }
        
    }
    
    func resetLabels() {
        
        // FIXME: should this reset to "current"?
        //        currentLabel.text = ""
        currentLatLabel.text = ""
        currentLonLabel.text = ""
        currentAltLabel.text = ""
        avgLatLabel.text = ""
        avgLonLabel.text = ""
        avgAltLabel.text = ""
        avgPointsLabel.text = ""
        commentTextField.text = ""
        // FIXME: maybe this shouldn't always be start?
        startButton.setTitle("Start", forState: UIControlState.Normal)
        
    }
    
    func resetPoints() {
        
        latitudes = []
        longitudes = []
        altitudes = []
        manualLats = []
        manualLons = []
        manualAlts = []
        mapView.removeAnnotations(mapView.annotations)
        isRunning = false
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if latitudes.count != 0 || manualLats.count != 0 {
            
            isRunning = false
            displayAlert("") // can the alert return us to this function to return true if they hit "No"
            return false
            
        } else {
            return true
        }
        
        
    }
    
    // TODO: remove navigatingTo?
    func displayAlert(navigatingTo: String) {
        //    func displayAlert() {
        
        let alertController = UIAlertController(title: "Your Points Have Not Been Saved", message: "Would you like to save them now?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            // reset points
            self.resetPoints()
            self.resetLabels()
            
            //            // segue to whatever was tapped on:
            //            if navigatingTo == "changeMode" {
            //                self.changeMode(self.autoOrManual)
            //            } else if navigatingTo == "savedCoords" {
            //                self.performSegueWithIdentifier("savedCoordsSegue", sender: self)
            //            }
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            self.finishWasPressed(self)
            self.performSegueWithIdentifier("finishSegue", sender: self)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displayFinishAlert() {
        
        // FIXME: What does "continue" mean?
        let alertController = UIAlertController(title: "No points have been collected.", message: nil, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


