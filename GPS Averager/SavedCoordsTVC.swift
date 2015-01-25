//
//  SavedCoordsTVC.swift
//  GPS Averager
//
//  Created by Mollie on 1/25/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class SavedCoordsTVC: UITableViewController {
    
    var sendCoords = [String : String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // TODO: Make sections by month or day
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedAverages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // TODO: reverse order of cells (make sure to also reverse in willSelectRowAtIndexPath, if needed
        
        var coordsForCell = savedAverages[indexPath.row]
        
        let latToDisplay = coordsForCell["Latitude"]!
        let lonToDisplay = coordsForCell["Longitude"]!
        
        let LatLon = Functions.formatCoordinateString((latToDisplay as NSString).doubleValue, lon: (lonToDisplay as NSString).doubleValue)
        
        
        cell.textLabel?.text = "\(LatLon.latString), \(LatLon.lonString)"
        cell.detailTextLabel?.text = coordsForCell["Date"]

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        sendCoords = savedAverages[indexPath.row]
//        
//        println(sendCoords["Points"])
//        
//    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        sendCoords = savedAverages[indexPath.row]
        
        return indexPath
        
    }
    
    // TODO: in either prepareForSegue or didSelectRowAtIndexPath,
    // pass along coordsToDisplay to the AvgCoordsVC
    // can be based on the date displayed in the cell

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showSaved") {
            let newVC = segue.destinationViewController as AvgCoordsVC
            
            newVC.coordsToDisplay = sendCoords
            
        }
    }

}
