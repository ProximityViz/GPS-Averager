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

class NewVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentLatLabel: UILabel!
    @IBOutlet weak var currentLonLabel: UILabel!
    @IBOutlet weak var currentAltLabel: UILabel!
    @IBOutlet weak var currentAccuracyLabel: UILabel!
    @IBOutlet weak var avgLatLabel: UILabel!
    @IBOutlet weak var avgLonLabel: UILabel!
    @IBOutlet weak var avgAltLabel: UILabel!
    @IBOutlet weak var avgAccuracyLabel: UILabel!
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
    var accuracies = [Float]()
    
    var manualLats = [Double]()
    var manualLons = [Double]()
    var manualAlts = [Float]()
    var manualAccuracies = [Float]()
    
    let regularColor = UIColor.blackColor()
    let boldColor = UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBarHidden = true
        
        // reset mapView
        mapView.removeAnnotations(mapView.annotations)
        
        // reset labels
        resetLabels()
        
        // MARK: NSUserDefaults
        
        if defaults.objectForKey("savedAverages") != nil {
            savedAverages = defaults.objectForKey("savedAverages") as [[String:AnyObject]]
        }
        baseMap = defaults.objectForKey("baseMap") as String
        trackingMode = defaults.objectForKey("trackingMode") as String
        coordFormat = defaults.objectForKey("coordFormat") as String
        
        var mapTypes = ["Standard","Satellite","Hybrid"]
        let baseMapsIndex = UInt(find(mapTypes, baseMap)!)
        mapView.mapType = MKMapType(rawValue: baseMapsIndex)!
        
        var title = "Start"
        if trackingMode == "Auto" {
            currentLabel.text = "Most Recent"
            isRunning = false
        } else {
            title = "Add Point"
            currentLabel.text = "Current"
            isRunning = true
        }
        startButton.setTitle(title, forState: UIControlState.Normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        commentTextField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        
        commentTextField.layer.cornerRadius = 4
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor.grayColor().CGColor
        
        startButton.layer.cornerRadius = 4
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = (UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)).CGColor
        
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        // hide keyboard
        commentTextField.resignFirstResponder()
        
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
        
        finishButton.layer.borderColor = (UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)).CGColor
        finishButton.setTitleColor(UIColor(red:0.99, green:0.13, blue:0.15, alpha:1), forState: UIControlState.Normal)
        
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
            manualAccuracies.append(Float(userLocation.horizontalAccuracy))
            
            currentLatLabel.textColor = boldColor
            currentLonLabel.textColor = boldColor
            currentAltLabel.textColor = boldColor
            currentAccuracyLabel.textColor = boldColor
            
            // change "average" labels
            let avgCoords = Functions.averageCoordinates(manualLats, longitudes: manualLons)
            let latLonString = Functions.formatCoordinateString(lat: avgCoords.avgLat, lon: avgCoords.avgLon)
            let avgAlt = Functions.averageOf(manualAlts)
            let avgAccuracies = Functions.averageOf(manualAccuracies)
            
            avgLatLabel.text = latLonString.latString
            avgLonLabel.text = latLonString.lonString
            avgAltLabel.text = "\(avgAlt) m"
            avgAccuracyLabel.text = "\(avgAccuracies) m"
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
        var avgAccuracy:Float = 0.0
        var points:Int = 0
        
        if trackingMode == "Auto" {
            
            isRunning = false
            
            avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
            
            // average the altitudes
            avgAlt = Functions.averageOf(altitudes)
            avgAccuracy = Functions.averageOf(accuracies)
            points = latitudes.count
            
        } else {
            
            avgCoords = Functions.averageCoordinates(manualLats, longitudes: manualLons)
            avgAlt = Functions.averageOf(manualAlts)
            avgAccuracy = Functions.averageOf(manualAccuracies)
            points = manualLats.count
            
        }
        
        // only save if there are points
        if latitudes.count != 0 || manualLats.count != 0 {
            
            savedAverages.insert([
                "Latitude" : "\(avgCoords.avgLat)",
                "Longitude" : "\(avgCoords.avgLon)",
                "Altitude": "\(avgAlt) m",
                "Accuracy": "\(avgAccuracy) m",
                "Points" : "\(points)",
                "All Points": [latitudes, longitudes, altitudes, accuracies],
                "Comment": commentTextField.text,
                "Date" : "\(formattedDate)"
                ], atIndex: 0)
            defaults.setValue(savedAverages, forKey: "savedAverages")
            
        }
        
        // reset
        resetPoints()
        avgPointsLabel.text = ""
        
        finishButton.layer.borderColor = UIColor.grayColor().CGColor
        finishButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        userLocation = locations[0] as CLLocation
        
        // MARK: Center and zoom
        if isRunning == true || (latitudes.count == 0 && manualLats.count == 0) {
            
            // zoom and center map to userLocation
            let mapLat:CLLocationDegrees = userLocation.coordinate.latitude
            let mapLon:CLLocationDegrees = userLocation.coordinate.longitude
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            mapView.setRegion(region, animated: true)
            
        }
        
        // MARK: Collect points
        if isRunning == true {
            
            LatLon = Functions.formatCoordinateString(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
            
            // change "current" labels
            currentLatLabel.textColor = regularColor
            currentLonLabel.textColor = regularColor
            currentAltLabel.textColor = regularColor
            currentAccuracyLabel.textColor = regularColor
            currentLatLabel.text = LatLon.latString
            currentLonLabel.text = LatLon.lonString
            currentAltLabel.text = "\(round(userLocation.altitude * 1000) / 1000) m"
            currentAccuracyLabel.text = "\(userLocation.horizontalAccuracy) m"
            
            // MARK: Change labels and map points for Auto mode
            if trackingMode == "Auto" {
                
                // MARK: Add point to arrays
                latitudes.append(LatLon.latitude)
                longitudes.append(LatLon.longitude)
                altitudes.append(Float(userLocation.altitude))
                accuracies.append(Float(userLocation.horizontalAccuracy))
                
                // change "average" labels
                let avgCoords = Functions.averageCoordinates(latitudes, longitudes: longitudes)
                let latLonString = Functions.formatCoordinateString(lat: avgCoords.avgLat, lon: avgCoords.avgLon)
                let avgAlt = Functions.averageOf(altitudes)
                let avgAccuracy = Functions.averageOf(accuracies)
                
                avgLatLabel.text = latLonString.latString
                avgLonLabel.text = latLonString.lonString
                avgAltLabel.text = "\(avgAlt) m"
                avgAccuracyLabel.text = "\(avgAccuracy) m"
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
        
        currentLatLabel.text = ""
        currentLonLabel.text = ""
        currentAltLabel.text = ""
        currentAccuracyLabel.text = ""
        avgLatLabel.text = ""
        avgLonLabel.text = ""
        avgAltLabel.text = ""
        avgAccuracyLabel.text = ""
        avgPointsLabel.text = ""
        commentTextField.text = ""
        
    }
    
    func resetPoints() {
        
        latitudes = []
        longitudes = []
        altitudes = []
        accuracies = []
        manualLats = []
        manualLons = []
        manualAlts = []
        manualAccuracies = []
        mapView.removeAnnotations(mapView.annotations)
        isRunning = false
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if latitudes.count != 0 || manualLats.count != 0 {
            
            var i = 0
            
            isRunning = false
            
            // find the index of the tab tapped on and pass that along to the displayAlert
            for vC in tabBarController.viewControllers as [UIViewController] {
                
                if vC == viewController { break }
                
                i++
            }
            
            displayAlert(i)
            return false
            
        } else {
            return true
        }
        
        
    }
    
    func displayAlert(navigatingTo: Int) {
        
        let alertController = UIAlertController(title: "Your Points Have Not Been Saved", message: "Would you like to save them now?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            // reset points
            self.resetPoints()
            self.resetLabels()
            
            // segue to whatever was tapped on:
            self.tabBarController?.selectedIndex = navigatingTo
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            self.finishWasPressed(self)
            self.performSegueWithIdentifier("finishSegue", sender: self)
            
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        self.finishButton.layer.borderColor = UIColor.grayColor().CGColor
        self.finishButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
    }
    
    func displayFinishAlert() {
        
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


