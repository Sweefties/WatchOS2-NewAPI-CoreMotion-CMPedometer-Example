//
//  ViewController.swift
//  WatchOS2-NewAPI-CoreMotion-CMPedometer-Example
//
//  Created by Wlad Dicario on 03/09/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    // MARK: - Interface
    @IBOutlet weak var pedometerLabel: UILabel!
    
    // MARK: - Constants
    fileprivate let corePedometer = CMPedometer()
    
    // MARK: - Properties
    fileprivate var steps = String()
    fileprivate var floorsAsc = String()
    fileprivate var floorsDes = String()
    fileprivate var distance = String()
    fileprivate var cadence = String()
    fileprivate var pace = String()
    
    // MARK: - Calls
    override func viewDidLoad() {
        super.viewDidLoad()
        // start Pedometer updates
        setPedometer()
    }

    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Get Pedometer Updates
    func setPedometer(){
        // define start date
        let startDate = Date()
        
        // get the current pedometer updates
        if CMPedometer.isStepCountingAvailable() {
            self.corePedometer.startUpdates(from: startDate, withHandler: { (data:CMPedometerData?, error:NSError?) -> Void in
                
                // GCD perform
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if (error == nil) {
                        
                        // rounded distance value (kms)
                        let distance = data!.distance!.doubleValue.mtokm
                        let np = 2.0
                        let multiplier = pow(10.0, np)
                        let rounded = round(distance * multiplier) / multiplier
                        print("Distance standard rounding : \(rounded) km.")
                        
                        
                        // set values from CMPedometer Data
                        self.steps = "Steps : \(data!.numberOfSteps)\n"
                        self.floorsAsc = "Floors Ascended : \(data!.floorsAscended!)\n"
                        self.floorsDes = "Floors Descended : \(data!.floorsDescended!)\n"
                        self.distance = "Distance : \(rounded)kms\n"
                        
                        // states for availability
                        if #available(iOS 9.0, *) {
                            self.cadence = "Cadence : \(data!.currentCadence!)m/s\n"
                            self.pace = "Pace : \(data!.currentPace!)sec/m\n"
                        } else {
                            // Fallback on earlier versions
                            self.cadence = "Cadence : availability iOS 9.0+\n"
                            self.pace = "Pace : availability iOS 9.0+\n"
                        }
                        
                        // set text label
                        self.pedometerLabel.text = self.steps + self.floorsAsc + self.floorsDes + self.distance + self.cadence + self.pace
                    }
                })
            } as! CMPedometerHandler)
        }
    }

}

//MARK: - Double Units Extension
extension Double {
    var km: Double { return self * 1_000.0 }
    var mtokm: Double { return self / 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
