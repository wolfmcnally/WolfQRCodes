//
//  UIQRCodeView.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 9/22/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import UIKit
import WolfImage
import WolfViews
import WolfPipe

public class UIQRCodeView: ImageView {
    public var data: Data! {
        didSet { sync() }
    }

    public var color = UIColor.black {
        didSet { sync() }
    }

    override public func setup() {
        super.setup()
        layer.magnificationFilter = .nearest
    }

    private func sync() {
        guard let data = data else { return }
        let image = QRCodeGeneratorFilter(data: data, correctionLevel: .low) |> (orientation: .up, scale: 1)
        let maskImage = UIImage(cgImage: image.newMask())
        let tintedImage = maskImage.tinted(with: color)
        self.image = tintedImage
    }
}

func color(_ color: UIColor) -> (_ v: UIQRCodeView) -> UIQRCodeView {
    return { v in
        v.color = color
        return v
    }
}
