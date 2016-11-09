//
//  HexToUIColorConverter.swift
//  MyBus
//
//  Created by Lisandro Falconi on 9/2/16.
//  Copyright © 2016 Spark Digital. All rights reserved.
//

import UIKit

extension UIColor {
    // Creates a UIColor from a Hex string.
    convenience init(hexString: String) {
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }

        if (cString.characters.count != 6) {
            self.init(white: 0.5, alpha: 1.0)
        } else {
            let rString: String = (cString as NSString).substringToIndex(2)
            let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
            let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)

            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)

            self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
    }
}
