////
////  SavedTableView.swift
////  GPS Averager
////
////  Created by Mollie on 2/27/15.
////  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
////
//
//import UIKit
//import MapKit
//
//class SavedTableView: UITableView, MKMapViewDelegate {
//    
//    @IBOutlet weak var mapView: MKMapView!
//    
//    var sendCoords = [String : AnyObject]()
//    
//    let defaults = NSUserDefaults.standardUserDefaults()
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // TODO: Make sections by month or day
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return savedAverages.count
//    }
//    
//    // MARK: Cell separators
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 60.0
//    }
//    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.separatorInset = UIEdgeInsetsZero
//        cell.layoutMargins = UIEdgeInsetsZero
//        cell.preservesSuperviewLayoutMargins = false
//    }
//    
//    // MARK: Cells
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//        
//        cell.backgroundColor = UIColor.clearColor()
//        cell.accessoryView = UIImageView(image: UIImage(named: "accessory"))
//        
//        let coordsForCell = savedAverages[indexPath.row]
//        
//        let latToDisplay = coordsForCell["Latitude"] as String
//        let lonToDisplay = coordsForCell["Longitude"] as String
//        
//        let LatLon = Functions.formatCoordinateString(lat: (latToDisplay as NSString).doubleValue, lon: (lonToDisplay as NSString).doubleValue)
//        
//        
//        cell.textLabel?.text = "\(LatLon.latString), \(LatLon.lonString)"
//        cell.detailTextLabel?.text = coordsForCell["Date"] as String
//        
//        return cell
//    }
//    
//    //  to support editing the table view.
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            savedAverages.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            defaults.setValue(savedAverages, forKey: "savedAverages")
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    
//    // MARK: - Navigation
//    
//    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        
//        // this needs to be in willSelect so it will run before prepareForSegue runs
//        sendCoords = savedAverages[indexPath.row]
//        
//        return indexPath
//        
//    }
//    
//}
