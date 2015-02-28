//
//  SettingTVC.swift
//  GPS Averager
//
//  Created by Mollie on 2/26/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class SettingTVC: UITableViewController {

    var currentSetting: [String:AnyObject]!
    var currentOptions: [String]!
    var currentSelection: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentSetting["setting"] as? String
        
        // NSUserDefaults
        if let currentSettingName = currentSetting["settingName"] as? String {
            currentSelection = defaults.objectForKey(currentSettingName) as? String
        } else {
            currentSelection = ""
        }
        
        currentOptions = currentSetting["options"] as? [String]
        
        if currentSetting == nil {
            
            currentSetting = [:]
            
        }

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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return currentOptions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = currentOptions[indexPath.row]
        
        if currentOptions[indexPath.row] == currentSelection {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell.accessoryView = UIImageView(image: UIImage(named: "Checkmark"))
        } else {
//            cell.accessoryView = UIImageView(image: UIImage(named: "Checkmark"))
            cell.accessoryView = nil
        }
        
        if currentSetting["setting"] as String == "Coordinate Format" {
            if let examples = currentSetting["examples"] as? [String] {
                cell.detailTextLabel?.text = examples[indexPath.row]
            }
        } else {
            cell.detailTextLabel?.text = ""
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // set NSUserDefaults
        let value = currentOptions[indexPath.row]
        let key = currentSetting["settingName"] as? String
        defaults.setValue(value, forKey: key!)
        
        // move checkmark
        currentSelection = value
        tableView.reloadData()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
