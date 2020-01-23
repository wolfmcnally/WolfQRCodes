//
//  QRCode.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 12/20/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI
import WolfImage
import WolfFoundation
import WolfPipe

struct QRCode: View {
    let data: Data
    let color: Color

    init(data: Data, color: Color = .white) {
        self.data = data
        self.color = color
    }

    var body: some View {
        Image(uiImage: QRCodeGeneratorFilter(data: data, correctionLevel: .low) |> (orientation: .up, scale: 1))
            .interpolation(.none)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .colorMultiply(color)
    }
}

#if DEBUG
struct QRCode_Previews: PreviewProvider {
    static var previews: some View {
        QRCode(data: "Hello" |> toUTF8, color: .red)
    }
}
#endif

#endif
