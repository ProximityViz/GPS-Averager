//
//  SettingsTVC.swift
//  GPS Averager
//
//  Created by Mollie on 2/26/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

let settings = [
    ["setting": "Tracking Mode", "settingName": "trackingMode", "options": ["Auto", "Manual"]],
    ["setting": "Base Map", "settingName": "baseMap", "options": ["Standard", "Hybrid", "Satellite"]],
    ["setting": "Coordinate Format", "settingName": "coordFormat", "options": ["Decimal degrees", "Decimal minutes", "Degrees, minutes, seconds"], "examples": ["Example: 33.7518732°, -84.3914068°", "Example: 33°45.11239', -84°23.48441'", "Example: 33°45'06.74\", -84°23'29.06\""]]
]

class SettingsTVC: UITableViewController {
    
    var currentSetting: [String:AnyObject] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            currentSetting = settings[indexPath.row] as! [String:AnyObject]
            let vc: SettingTVC = segue.destinationViewController as! SettingTVC
            vc.currentSetting = currentSetting
        }
        
    }

}
