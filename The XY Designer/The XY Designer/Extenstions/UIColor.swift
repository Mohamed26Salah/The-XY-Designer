//
//  UIColor.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 11/04/2023.
//

import Foundation
import UIKit

extension UIColor {
    var hexString: String {
        let components = cgColor.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = (components?.count ?? 0) > 2 ? components?[2] : g
        let a = cgColor.alpha

        let rgba: Int = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b!*255)<<8 | (Int)(a*255)
        return String(format: "#%08x", rgba)
    }
    convenience init?(hexString: String) {
            let r, g, b, a: CGFloat

            if hexString.hasPrefix("#") {
                let start = hexString.index(hexString.startIndex, offsetBy: 1)
                let hexColor = String(hexString[start...])

                if hexColor.count == 8 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        a = CGFloat(hexNumber & 0x000000ff) / 255

                        self.init(red: r, green: g, blue: b, alpha: a)
                        return
                    }
                }
            }

            return nil
        }
}


