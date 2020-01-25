//
//  QRCodeUtils.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 1/19/20.
//  Copyright © 2020 Blockchain Commons. All rights reserved.
//

import UIKit
import WolfFoundation
import WolfPipe
import WolfImage

public func makeQRCode(_ data: String, color: UIColor = .black) -> UIImage {
    let data = data |> toUTF8
    let image = QRCodeGeneratorFilter(data: data, correctionLevel: .high).outputImage()
    let maskImage = UIImage(cgImage: image.newMask())
    return maskImage.tinted(with: color)
}
