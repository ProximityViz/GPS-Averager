//
//  AppDelegate.swift
//  GPS Averager
//
//  Created by Mollie on 1/24/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit
import MapKit

var savedAverages = [[String:AnyObject]]()

var coordFormat:String!
var trackingMode:String!
var baseMap:String!

let defaults = NSUserDefaults.standardUserDefaults()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // MARK: NSUserDefaults
        if defaults.objectForKey("savedAverages") != nil {
            savedAverages = defaults.objectForKey("savedAverages") as! [[String:AnyObject]]
        }
        if defaults.objectForKey("baseMap") != nil {
            baseMap = defaults.objectForKey("baseMap") as! String
        } else {
            defaults.setValue("Standard", forKey: "baseMap")
            baseMap = "Standard"
        }
        if defaults.objectForKey("trackingMode") != nil {
            trackingMode = defaults.objectForKey("trackingMode") as! String
        } else {
            defaults.setValue("Auto", forKey: "trackingMode")
            trackingMode = "Auto"
        }
        if defaults.objectForKey("coordFormat") != nil {
            coordFormat = defaults.objectForKey("coordFormat") as! String
        } else {
            defaults.setValue("Decimal degrees", forKey: "coordFormat")
            coordFormat = "Decimal degrees"
        }
        
        // MARK: aesthetics
        UIBarButtonItem.appearance().tintColor = UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)
        UINavigationBar.appearance().tintColor = UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)
        UITabBar.appearance().tintColor = UIColor(red:0.99, green:0.13, blue:0.15, alpha:1)
        UINavigationBar.appearance().backgroundColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20.0)!]
        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15.0)!], forState: UIControlState.Normal)
        UITextField.appearance().layer.borderColor = UIColor.blackColor().CGColor
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

