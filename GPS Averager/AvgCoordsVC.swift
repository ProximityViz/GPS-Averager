////
////  AvgCoordsVC.swift
////  GPS Averager
////
////  Created by Mollie on 1/25/15.
////  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
////
//
//import UIKit
//import MapKit
//
//class AvgCoordsVC: UIViewController, MKMapViewDelegate {
//
//    @IBOutlet weak var avgLatLabel: UILabel!
//    @IBOutlet weak var avgLonLabel: UILabel!
//    @IBOutlet weak var avgAltLabel: UILabel!
//    @IBOutlet weak var avgPointsLabel: UILabel!
//    
//    @IBOutlet weak var mapView: MKMapView!
//    
//    @IBOutlet weak var changeFormatButton: UIBarButtonItem!
//    @IBOutlet weak var shareButton: UIBarButtonItem!
//    
//    var lat:String!
//    var lon:String!
//    
//    var coordsToDisplay = [String : AnyObject]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // aesthetics
//        changeFormatButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15.0)!], forState: UIControlState.Normal)
//        shareButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15.0)!], forState: UIControlState.Normal)
//    
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        
//        if coordsToDisplay == [:] {
//            coordsToDisplay = savedAverages.first as [String:String]
//        }
//        
//        if (defaults.objectForKey("coordFormat") != nil) {
//            coordFormat = defaults.objectForKey("coordFormat") as String
//        }
//        
//        let latToDisplay = coordsToDisplay["Latitude"]!
//        let lonToDisplay = coordsToDisplay["Longitude"]!
//        
//        displayCoords(latToDisplay: latToDisplay, lonToDisplay: lonToDisplay)
//        
//        // MARK: map point
//        let mapLat:CLLocationDegrees = NSString(string: latToDisplay).doubleValue
//        let mapLon:CLLocationDegrees = NSString(string: lonToDisplay).doubleValue
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        
//        mapView.setRegion(region, animated: true)
//        mapView.addAnnotation(annotation)
//        
//        
//    }
//
//    @IBAction func menuWasPressed(sender: AnyObject) {
//        
//        let navC = storyboard?.instantiateViewControllerWithIdentifier("SavedCoordsNavC") as UINavigationController
//        presentViewController(navC, animated: true, completion: nil)
//        
//    }
//    
//    @IBAction func shareWasPressed(sender: UIBarButtonItem) {
//        
//        let shareText = "Averaged coordinates: Latitude: \(lat), Longitude: \(lon)"
//        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
//        presentViewController(activityViewController, animated: true, completion: nil)
//        
//    }
//    
//    @IBAction func addWasPressed(sender: AnyObject) {
//        
//        let rootVC = storyboard?.instantiateViewControllerWithIdentifier("RootVC") as? UINavigationController
//        UIApplication.sharedApplication().keyWindow?.rootViewController = rootVC
//        
//    }
//    
//    func displayCoords(#latToDisplay: String, lonToDisplay: String) {
//        
//        let LatLon = Functions.formatCoordinateString(lat: (latToDisplay as NSString).doubleValue, lon: (lonToDisplay as NSString).doubleValue)
//        
//        lat = LatLon.latString
//        lon = LatLon.lonString
//        
//        avgLatLabel.text = lat
//        avgLonLabel.text = lon
//        avgAltLabel.text = coordsToDisplay["Altitude"]
//        avgPointsLabel.text = coordsToDisplay["Points"]
//        
//    }
//    
//    // MARK: - Navigation
//    
//    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
//        
//        let latToDisplay = coordsToDisplay["Latitude"]!
//        let lonToDisplay = coordsToDisplay["Longitude"]!
//        
//        displayCoords(latToDisplay: latToDisplay, lonToDisplay: lonToDisplay)
//        
//    }
//
//}
