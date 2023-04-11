//
//  UIColor.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 11/04/2023.
//

import Foundation
import UIKit

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

extension Array where Element == UIColor {
    func toStringArray() -> [String] {
        return self.map { color in
            let rgba = color.rgba
            return "red: \(rgba.red), green: \(rgba.green), blue: \(rgba.blue), alpha: \(rgba.alpha)"
        }
    }
}

extension Array where Element == String {
    func toColorArray() -> [UIColor] {
        return self.compactMap { string -> UIColor? in
            let components = string.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count == 4 else { return nil }
            let redString = components[0].split(separator: ":")[1].trimmingCharacters(in: .whitespaces)
            let greenString = components[1].split(separator: ":")[1].trimmingCharacters(in: .whitespaces)
            let blueString = components[2].split(separator: ":")[1].trimmingCharacters(in: .whitespaces)
            let alphaString = components[3].split(separator: ":")[1].trimmingCharacters(in: .whitespaces)
            guard let red = NumberFormatter().number(from:redString)?.doubleValue,
                  let green = NumberFormatter().number(from:greenString)?.doubleValue,
                  let blue = NumberFormatter().number(from:blueString)?.doubleValue,
                  let alpha = NumberFormatter().number(from:alphaString)?.doubleValue else { return nil }
            return UIColor(red:red/255.0 ,green:green/255.0 ,blue :blue/255.0 ,alpha :alpha)
        }
    }
}
