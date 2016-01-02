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
        let currentSettingName = currentSetting["settingName"] as! String
        currentSelection = defaults.objectForKey(currentSettingName) as! String
        
        currentOptions = currentSetting["options"] as? [String]
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
    }
    
    // go back to main view when another tab button is pressed
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.popToRootViewControllerAnimated(false)
        
    }
    
    // MARK: Cell separators
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOptions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = currentOptions[indexPath.row]
        
        if currentOptions[indexPath.row] == currentSelection {
            cell.accessoryView = UIImageView(image: UIImage(named: "Checkmark"))
        } else {
            cell.accessoryView = nil
        }
        
        if currentSetting["setting"] as! String == "Coordinate Format" {
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

}
