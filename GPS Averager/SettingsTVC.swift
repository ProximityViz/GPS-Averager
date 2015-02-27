//
//  SettingsTVC.swift
//  GPS Averager
//
//  Created by Mollie on 2/26/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

// array of dictionaries
let settings = [
    ["setting": "Tracking Mode", "settingName": "trackingMode", "options": ["Auto", "Manual"]],
    ["setting": "Base Map", "settingName": "baseMap", "options": ["Standard", "Hybrid", "Satellite"]],
    ["setting": "Coordinate Format", "settingName": "coordFormat", "options": ["Decimal degrees", "Decimal minutes", "Degrees, minutes, seconds"], "examples": ["Example: 33.7518732°, -84.3914068°", "Example: 33°45.11239', -84°23.48441'", "Example: 33°45'06.74\", -84°23'29.06\""]]
]

//        [["Name" : "Decimal degrees", "Example" : "Example: 33.7518732°, -84.3914068°"],
//            ["Name" : "Decimal minutes", "Example" : "Example: 33°45.11239', -84°23.48441'"],
//            ["Name" : "Degrees, minutes, seconds", "Example" : "Example: 33°45'06.7435\", -84°23'29.0645\""]

class SettingsTVC: UITableViewController {
    
    var currentSetting: [String:AnyObject] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Cell separators
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return settings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = settings[indexPath.row]["setting"] as? String
        cell.accessoryView = UIImageView(image: UIImage(named: "accessory"))
        
        if let currentSettingName = settings[indexPath.row]["settingName"] as? String {
            if let currentSetting = defaults.objectForKey(currentSettingName) as? String {
                if currentSetting == "Degrees, minutes, seconds" {
                    cell.detailTextLabel?.text = "DMS"
                } else {
                    cell.detailTextLabel?.text = currentSetting
                }
            } else {
                cell.detailTextLabel?.text = ""
            }
        } else {
            cell.detailTextLabel?.text = ""
        }

        return cell
    }

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            currentSetting = settings[indexPath.row] as [String:AnyObject]
            let vc: SettingTVC = segue.destinationViewController as SettingTVC
            vc.currentSetting = currentSetting
        }
        
    }

}
