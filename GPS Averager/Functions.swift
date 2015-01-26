//
//  Functions.swift
//  GPS Averager
//
//  Created by Mollie on 1/25/15.
//  Copyright (c) 2015 Proximity Viz LLC. All rights reserved.
//

import UIKit

class Functions: NSObject {
    
    class func formatCoordinateString(#lat: Double, lon: Double) -> (latitude: Double, longitude: Double, latString: String, lonString: String) {
        
        // FIXME: Is there a better way of rounding so we don't have to do all this modulo stuff?
        
        var decimalPlaces = 1000000.0
        var latitude = round(lat * decimalPlaces) / decimalPlaces
        var longitude = round(lon * decimalPlaces) / decimalPlaces
        
        var latZero:String
        var lonZero:String
        
        if latitude * decimalPlaces % 100 == 0 {
            latZero = "00"
        } else if latitude * decimalPlaces % 10 == 0 {
            latZero = "0"
        } else {
            latZero = ""
        }
        
        if longitude * decimalPlaces % 100 == 0 {
            lonZero = "00"
        } else if longitude * decimalPlaces % 10 == 0 {
            lonZero = "0"
        } else {
            lonZero = ""
        }
        
        var latString = "\(latitude)\(latZero)\u{00B0}"
        var lonString = "\(longitude)\(lonZero)\u{00B0}"
        
        return (latitude, longitude, latString, lonString)
        
    }
    
    class func averageCoordinates(latitudes: [Double], longitudes: [Double]) -> (avgLat: Double, avgLon: Double) {
        
        let π = M_PI
        
        var avgX = 0 as Double
        var avgY = 0 as Double
        var avgZ = 0 as Double
        var avgLat = 0 as Double
        var avgLon = 0 as Double
        
        for (var i = 0; i < latitudes.count; i++) {
            
            // calculate cartesian coordinates
            var radLat = latitudes[i] * π / 180
            var radLon = longitudes[i] * π / 180
            
            // w1 & w2 = 0
            // calculate weighted average
            avgX += (cos(radLat) * cos(radLon))
            avgY += (cos(radLat) * sin(radLon))
            avgZ += sin(radLat)
            
        }
        
        // divide to get average
        avgX /= Double(latitudes.count)
        avgY /= Double(latitudes.count)
        avgZ /= Double(latitudes.count)
        
        // convert to lat & long, in degrees
        avgLat = atan2(avgZ, sqrt(avgX * avgX + avgY * avgY)) * 180 / π
        avgLon = atan2(avgY, avgX) * 180 / π
        
        
        return (avgLat, avgLon)
    }
    
    
    class func averageOf(numbers: [Float]) -> Float {
        
        if numbers.count == 0 {
            return 0
        }
        
        var sum:Float = 0
        
        for number in numbers {
            sum += number
        }
        
        return (sum / Float(numbers.count))
        
    }
    
   
}
