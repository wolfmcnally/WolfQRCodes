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

public typealias QRCodeMockBlock = () -> Data
public typealias QRCodeCaptureBlock = (Data) -> QRCodeCaptureAction

public struct CaptureQRCode: View {
    let title: String
    let onMock: QRCodeMockBlock?
    let onCaptureData: QRCodeCaptureBlock?

    public init(title: String, onMock: QRCodeMockBlock? = nil, onCaptureData: QRCodeCaptureBlock? = nil) {
        self.title = title
        self.onMock = onMock
        self.onCaptureData = onCaptureData
    }

    public var body: some View {
        UIQRCodeCapture(title: title, onMock: onMock, onCaptureData: onCaptureData)
    }
}

struct UIQRCodeCapture: UIViewControllerRepresentable {
    let title: String
    let onMock: QRCodeMockBlock?
    let onCaptureData: QRCodeCaptureBlock?

    init(title: String, onMock: QRCodeMockBlock? = nil, onCaptureData: QRCodeCaptureBlock? = nil) {
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

#endif
