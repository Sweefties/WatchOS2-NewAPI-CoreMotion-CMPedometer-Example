//
//  InterfaceController.swift
//  WatchOS2-NewAPI-CoreMotion-CMPedometer-Example WatchKit Extension
//
//  Created by Wlad Dicario on 03/09/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {

    // MARK: - Interface
    @IBOutlet var stepsLbl: WKInterfaceLabel!
    @IBOutlet var stepsCount: WKInterfaceLabel!
    @IBOutlet var floorsAscLbl: WKInterfaceLabel!
    @IBOutlet var floorsAscCount: WKInterfaceLabel!
    @IBOutlet var floorsDesLbl: WKInterfaceLabel!
    @IBOutlet var floorsDesCount: WKInterfaceLabel!
    @IBOutlet var distanceLbl: WKInterfaceLabel!
    @IBOutlet var distanceCount: WKInterfaceLabel!
    @IBOutlet var cadenceLbl: WKInterfaceLabel!
    @IBOutlet var cadenceCount: WKInterfaceLabel!
    @IBOutlet var paceLbl: WKInterfaceLabel!
    @IBOutlet var paceCount: WKInterfaceLabel!
    
    // MARK: - Properties
    fileprivate let corePedometer = CMPedometer()
    
    
    // MARK: - Context Initializer
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        // set text labels
        self.stepsCount.setText("-")
        self.floorsAscCount.setText("-")
        self.floorsDesCount.setText("-")
        self.distanceCount.setText("- m.")
        self.cadenceCount.setText("- m/s")
        self.paceCount.setText("- sec/m")
    }
    

    // MARK: - Calls
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // to start pedometer updates..
        startPedometerUpdates()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        // to stop pedometer updates.. eg:now offscreen
        self.corePedometer.stopUpdates()
    }
    
    
    // MARK: - Get Pedometer Updates
    func startPedometerUpdates(){
        // define start date
        let startDate = Date()
        
        // get CMPedometerData updates from startDate
        if CMPedometer.isPaceAvailable() {
            
            self.corePedometer.startUpdates(from: startDate, withHandler: { (data:CMPedometerData?, error:NSError?) -> Void in
                
                if (error == nil) {
                    
                    // rounded distance value (in meter eg: 12.54)
                    let distance = data!.distance!.doubleValue.m
                    let np = 2.0
                    let multi = pow(10.0, np)
                    let rounded = round(distance * multi) / multi
                    print("Distance standard rounding : \(rounded)m")
                    
                    // set text labels
                    self.stepsCount.setText("\(data!.numberOfSteps)")
                    self.floorsAscCount.setText("\(data!.floorsAscended!)")
                    self.floorsDesCount.setText("\(data!.floorsDescended!)")
                    self.distanceCount.setText("\(rounded)m.")
                    self.cadenceCount.setText("\(data!.currentCadence!)m/s")
                    self.paceCount.setText("\(data!.currentPace!)sec/m")
                }
            } as! CMPedometerHandler)
        }
    }

}


//MARK: - Double Units Extension
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
