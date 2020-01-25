//
//  Fonts.swift
//  
//
//  Created by Wolf McNally on 1/24/20.
//

import UIKit
import WolfPipe
import WolfStrings

extension UIFont {
    static let appFont: UIFont = .systemFont(ofSize: 12)

    static let nameFieldFontSize: CGFloat = 24

    static let buttonFontSize: CGFloat = 18
    static let buttonFont = .appFont |> withPointSize(buttonFontSize)
}
