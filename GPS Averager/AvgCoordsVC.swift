//
//  AvgCoordsVC.swift
//  GPS Averager
//
//  Created by Mollie on 1/25/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

class AvgCoordsVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var avgLatLabel: UILabel!
    @IBOutlet weak var avgLonLabel: UILabel!
    @IBOutlet weak var avgAltLabel: UILabel!
    @IBOutlet weak var avgPointsLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var lat:String!
    var lon:String!
    
    var coordsToDisplay = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if coordsToDisplay == [:] {
            
            coordsToDisplay = savedAverages[savedAverages.count - 1]
            
        }
        
        // FIXME: This VC should actually display whatever coords it's given, not always the most recent ones
//        var coordsToDisplay = savedAverages[savedAverages.count - 1]
        
        let latToDisplay = coordsToDisplay["Latitude"]!
        let lonToDisplay = coordsToDisplay["Longitude"]!
        
        let LatLon = Functions.formatCoordinateString((latToDisplay as NSString).doubleValue, lon: (lonToDisplay as NSString).doubleValue)
        
        lat = LatLon.latString
        lon = LatLon.lonString
        
        avgLatLabel.text = lat
        avgLonLabel.text = lon
        avgAltLabel.text = coordsToDisplay["Altitude"]
        avgPointsLabel.text = coordsToDisplay["Points"]
        
        // MARK: map point
        var mapLat:CLLocationDegrees = NSString(string: latToDisplay).doubleValue
        var mapLon:CLLocationDegrees = NSString(string: lonToDisplay).doubleValue
        var span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLat, mapLon)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    
    }

    @IBAction func shareWasPressed(sender: UIBarButtonItem) {
        
        var shareText = "Averaged coordinates: Latitude \(lat), Longitude \(lon)"
        var activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
