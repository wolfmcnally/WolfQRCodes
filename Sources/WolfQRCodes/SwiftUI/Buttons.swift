//
//  Buttons.swift
//  
//
//  Created by Wolf McNally on 1/22/20.
//

import SwiftUI

public struct CaptureQRCodeButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "qrcode.viewfinder").imageScale(.large)
        }
    }
}

public struct DisplayQRCodeButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "qrcode").imageScale(.large)
        }
    }
}
