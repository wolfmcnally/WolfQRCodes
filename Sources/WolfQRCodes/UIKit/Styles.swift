//
//  Styles.swift
//  
//
//  Created by Wolf McNally on 1/24/20.
//

import UIKit
import WolfPipe
import WolfStrings
import WolfAutolayout
import WolfViews
import WolfNesting

func normalStyle(_ string: AttributedString?) -> AttributedString? {
    guard let string = string else { return nil }
    return string |> withForegroundColor(.normalText)
}

func appFont(_ string: AttributedString?) -> AttributedString? {
    guard let string = string else { return nil }
    let fontFace = UIFont.appFont.fontName
    let updatedDesc = string.font.fontDescriptor.withFace(fontFace)
    let updatedFont = UIFont(descriptor: updatedDesc, size: 0)
    string.font = updatedFont
    return string
}

func sectionStyle(_ string: AttributedString?) -> AttributedString? {
    return string |> appFont |> withBold |> withPointSize(UIFont.nameFieldFontSize) |> withForegroundColor(.titleText)
}

func enclose(_ view: UIView) -> UIView {
    return View() |> { (🍒: View) in
        🍒 => [
            view
        ]
    }
}

func encloseCenteredHorizontally(_ view: UIView) -> UIView {
    let enclosingView = view |> enclose
    Constraints(
        view.centerXAnchor == enclosingView.centerXAnchor,
        view.topAnchor == enclosingView.topAnchor,
        view.bottomAnchor == enclosingView.bottomAnchor
    )
    return enclosingView
}

func encloseCenteredVertically(_ view: UIView) -> UIView {
    let enclosingView = view |> enclose
    Constraints(
        view.centerYAnchor == enclosingView.centerYAnchor,
        view.leadingAnchor == enclosingView.leadingAnchor,
        view.trailingAnchor == enclosingView.trailingAnchor
    )
    return enclosingView
}

func stackStyle<V: UIStackView>(_ view: V) -> V {
    return view |> spacing(10)
}

func columnStyle<V: UIStackView>(_ view: V) -> V {
    return view |> stackStyle |> vertical
}

func textStyle<B: UIButton>(_ title: String, font: UIFont = .buttonFont, normal: UIColor = .activeElement, highlighted: UIColor = .highlightedActiveElement, disabled: UIColor = .disabledActiveElement) -> (_ button: B) -> B {
    return { button in
        button.setTitle(title, font: font, normal: normal, highlighted: highlighted, disabled: disabled)
        return button
    }
}
