//: ## Control a Sphero device with your iPad!
//:
//: When you hit the "Run My Code" button on this page you can tilt your iPad
//: to make the Sphero go.
//:
import PlaygroundSupport
import UIKit

// A Sphero object which is automatically set to the nearest device.
var sphero: Sphero?

let viewController = SpheroViewController()

// When Core Motion detects that the attitude of the iPad has changed, then this closure is called.
viewController.directionVectorChanged = { angle, magnitude in
    print("angle=\(angle) magnitude=\(magnitude)")
    let rollForce = UInt8(magnitude * 0.5 * Double(UInt8.max))
    let rollAngle = UInt16(radiansToDegrees(angle))

    sphero?.roll(speed: rollForce, heading: rollAngle)
}

// When the user taps one of the color buttons, then this closure is called, and we stop the Sphero
viewController.colorSelected = { color in
    sphero?.setColor(color)
}

// We set the live view in the same process as the Contents.swift
PlaygroundPage.current.liveView = viewController

DispatchQueue.main.async {

    // This calls the Core Bluetooth APIs to detect a Sphero SPRK+ via Bluetooth LE APIs
    // This method blocks until it returns.
    sphero = Sphero.nearest()
    if sphero == nil {
        // We didn't find a Sphero. It must be a Sphero that supports Bluetooth LE.
        let alertController = UIAlertController(title: "Unable to find a Sphero device", message: "No Sphero devices were in range.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            PlaygroundPage.current.finishExecution()
        })
        viewController.present(alertController, animated: true, completion: nil)
    }
}
