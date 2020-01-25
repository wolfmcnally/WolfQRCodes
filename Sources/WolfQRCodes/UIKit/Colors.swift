//
//  Colors.swift
//  
//
//  Created by Wolf McNally on 1/24/20.
//

import UIKit

extension UIColor {
    static let gold = try! UIColor(string: "#FCE900")

    static let transparentDarkBackground = black.withAlphaComponent(0.7)

    static let titleText = label
    static let normalText = label

    static let activeElement = UIColor(light: orange, dark: gold)
    static let disabledActiveElement = UIColor(light: orange.withAlphaComponent(0.4), dark: gold.withAlphaComponent(0.4))
    static let highlightedActiveElement = UIColor(light: black, dark: white)
}
