![](https://img.shields.io/badge/build-pass-brightgreen.svg?style=flat-square)
![](https://img.shields.io/badge/platform-WatchOS2-ff69b4.svg?style=flat-square)
![](https://img.shields.io/badge/Require-XCode%208-lightgrey.svg?style=flat-square)


# WatchOS2 - New API - Core Motion CMPedometer - Example
WatchOS 2 Experiments - New API Components - Pedometer with Core Motion.

## Example

![](https://raw.githubusercontent.com/Sweefties/WatchOS2-NewAPI-CoreMotion-CMPedometer-Example/master/source/Apple_Watch_template-CoreMotion-CMPedometer.jpg)


## Requirements

- >= XCode 8.0.
- >= Swift 3.

Tested on WatchOS2, iOS 9.0 Simulators, iPhone 6 8.4, Watch.

## Important

this is the Xcode 8 / Swift 3 updated project.

## Usage

To run the example project, download or clone the repo.

## Caution
CMPedometerData only work on Hardware (your apple watch!), not on simulators..

### Example Code!


Configure :

- Drag and drop more WKInterfaceLabel to Interface Controller (Storyboard)
- connect your WKInterfaceLabel to your Interface Controller class
- import CoreMotion to your Interface Controller class
- put code to your controller class.

```swift
// create pedometer object
let corePedometer = CMPedometer()
```

- in willActivate() method

```swift
// define start date
let startDate = NSDate()

// get CMPedometerData updates from startDate
if CMPedometer.isPaceAvailable() {

	self.corePedometer.startPedometerUpdatesFromDate(startDate, withHandler: { (data:CMPedometerData?, error:NSError?) -> Void in

		if (error == nil) {

            // rounded distance value (in meter eg: 12.54)
            let distance = data!.distance!.doubleValue.m
            let np = 2.0
            let multi = pow(10.0, np)
            let rounded = round(distance * multi) / multi
            print("Distance standard rounding : \(rounded)m")

            // set text labels
            self.stepsCount.setText("\(data!.numberOfSteps ?? 0)")
            self.floorsAscCount.setText("\(data!.floorsAscended! ?? 0)")
            self.floorsDesCount.setText("\(data!.floorsDescended! ?? 0)")
            self.distanceCount.setText("\(rounded ?? 0)m.")
            self.cadenceCount.setText("\(data!.currentCadence! ?? 0)m/s")
            self.paceCount.setText("\(data!.currentPace! ?? 0)sec/m")
		}
	})
}
```


Build and Run on your Hardware!
