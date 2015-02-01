//
//  CoordFormatTVC.swift
//  GPS Averager
//
//  Created by Mollie on 1/26/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class CoordFormatTVC: UITableViewController {
    
    let coordFormatList = [["Name" : "Decimal degrees", "Example" : "Example: 33.7518732°, -084.3914068°"],
        ["Name" : "Decimal minutes", "Example" : "Example: 33°45.11239', -084°23.48441'"],
        ["Name" : "Degrees, minutes, seconds", "Example" : "Example: 33°45'06.7435\", -084°23'29.0645\""]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordFormatList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = coordFormatList[indexPath.row]["Name"]
        cell.detailTextLabel?.text = coordFormatList[indexPath.row]["Example"]

        return cell
    }
    
    // MARK: - Navigation
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        coordFormat = coordFormatList[indexPath.row]["Name"]
        performSegueWithIdentifier("unwind", sender: self)
        
    }

}
