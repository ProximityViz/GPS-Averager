//
//  AveragedVC.swift
//  GPS Averager
//
//  Created by Mollie on 1/25/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

class AveragedVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avgLatLabel: UILabel!
    @IBOutlet weak var avgLonLabel: UILabel!
    @IBOutlet weak var avgAltLabel: UILabel!
    @IBOutlet weak var avgAccuracyLabel: UILabel!
    @IBOutlet weak var avgPointsLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    var lat:String!
    var lon:String!
    
    var coordsToDisplay: [String:AnyObject] = [:]
    var coordsToDisplayIndex = 0
    
    var originalCenter:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // aesthetics
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareWasPressed:")
        
        commentTextField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        
        saveButton.layer.cornerRadius = 4
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = (UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)).CGColor
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBarHidden = false
        
        if coordsToDisplay.isEmpty {
            coordsToDisplay = savedAverages.first!
        }
        
        if (defaults.objectForKey("coordFormat") != nil) {
            coordFormat = defaults.objectForKey("coordFormat") as! String
        }
        if defaults.objectForKey("baseMap") != nil {
            baseMap = defaults.objectForKey("baseMap") as! String
        } else {
            defaults.setValue("Standard", forKey: "baseMap")
            baseMap = "Standard"
        }
        
        let mapTypes = ["Standard","Satellite","Hybrid"]
        let baseMapsIndex = UInt(mapTypes.indexOf(baseMap)!)
        mapView.mapType = MKMapType(rawValue: baseMapsIndex)!
        
        let latToDisplay = coordsToDisplay["Latitude"] as! String
        let lonToDisplay = coordsToDisplay["Longitude"] as! String
        
        displayCoords(latToDisplay: latToDisplay, lonToDisplay: lonToDisplay)
        
        // MARK: map point
        let mapLat:CLLocationDegrees = NSString(string: latToDisplay).doubleValue
        let mapLon:CLLocationDegrees = NSString(string: lonToDisplay).doubleValue
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
        
        
    }
    
    // MARK: Keyboard sliding
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // go back to main view when another tab button is pressed
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.popToRootViewControllerAnimated(false)
        
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
        
        commentConstraint.constant = 8
        saveButton.hidden = false
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // minimize keyboard on tap outside
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func shareWasPressed(sender: UIBarButtonItem) {
        
        let altitude = coordsToDisplay["Altitude"] as? String
        let shareText = "Coordinates from GPS Averager: Latitude: \(lat), Longitude: \(lon), Altitude: \(altitude)"
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    func displayCoords(latToDisplay latToDisplay: String, lonToDisplay: String) {
        
        let LatLon = Functions.formatCoordinateString(lat: (latToDisplay as NSString).doubleValue, lon: (lonToDisplay as NSString).doubleValue)
        
        lat = LatLon.latString
        lon = LatLon.lonString
        
        dateLabel.text = coordsToDisplay["Date"] as? String
        avgLatLabel.text = lat
        avgLonLabel.text = lon
        avgAltLabel.text = coordsToDisplay["Altitude"] as? String
        avgAccuracyLabel.text = coordsToDisplay["Accuracy"] as? String
        avgPointsLabel.text = coordsToDisplay["Points"] as? String
        if let comment = coordsToDisplay["Comment"] as? String {
            commentTextField.text = comment
        }
        
    }

    
    @IBAction func saveComment(sender: AnyObject) {
        
        if commentTextField.text != "" {
            // save comment
            if defaults.objectForKey("savedAverages") != nil {
                savedAverages = defaults.objectForKey("savedAverages") as! Array
                savedAverages[coordsToDisplayIndex]["Comment"] = commentTextField.text
                defaults.setValue(savedAverages, forKey: "savedAverages")
            }
        }
        
        // hide keyboard
        view.endEditing(true)
        
        // change button
        saveButton.hidden = true
        
        commentConstraint.constant = -100
        
    }

}
