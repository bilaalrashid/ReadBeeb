//
//  UIDevice+ModelIdentifier.swift
//  ReadBeeb
//
//  Created by Bilaal Rashid on 04/11/2023.
//

import UIKit

extension UIDevice {
    /// The model identifier of the device e.g. `iPhone15,2`.
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }
}
