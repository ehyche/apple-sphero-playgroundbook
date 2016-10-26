//: ## Control a Sphero device with your iPad!
//:
//: When you hit the "Run My Code" button on this page you can tilt your iPad
//: to make the Sphero go.
//:

// A Sphero object which is automatically set to the nearest device.
var sphero: Sphero?

//#-editable-code
let viewController = SpheroViewController()

viewController.joystickMoved = { angle, magnitude in
    let rollForce = UInt8(magnitude * 0.5 * Double(UInt8.max))
    let rollAngle = UInt16(radiansToDegrees(angle))

    sphero?.roll(speed: rollForce, heading: rollAngle)
}

viewController.colorSelected = { color in
    sphero?.setColor(color)
}

import PlaygroundSupport

PlaygroundPage.current.liveView = viewController
//#-end-editable-code

//#-hidden-code
import UIKit
DispatchQueue.main.async {

    //#-end-hidden-code
    sphero = Sphero.nearest()
    //#-hidden-code
    if sphero == nil {
        let alertController = UIAlertController(title: "Unable to find a Sphero device", message: "No Sphero devices were in range.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            PlaygroundPage.current.finishExecution()
        })
        viewController.present(alertController, animated: true, completion: nil)
    }
}
//#-end-hidden-code
