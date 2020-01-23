//
//  CaptureQRCode.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 12/8/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI
import WolfWith

struct CaptureQRCode: UIViewControllerRepresentable {
    typealias MockBlock = () -> Data
    typealias CaptureBlock = (Data) -> CaptureAction

    let title: String
    let onMock: MockBlock?
    let onCaptureData: CaptureBlock?

    init(title: String, onMock: MockBlock? = nil, onCaptureData: CaptureBlock? = nil) {
        self.title = title
        self.onMock = onMock
        self.onCaptureData = onCaptureData
    }

    func makeUIViewController(context: Context) -> UIQRCodeCaptureViewController {
        UIQRCodeCaptureViewController(title: title) • {
            $0.onMock = onMock
            $0.onCaptureData = onCaptureData
        }
    }

    func updateUIViewController(_ uiViewController: UIQRCodeCaptureViewController, context: Context) {
    }
}

//#if DEBUG
//struct CaptureQRCode_Previews: PreviewProvider {
//    static var previews: some View {
//        CaptureQRCode()
//    }
//}
//#endif

#endif
