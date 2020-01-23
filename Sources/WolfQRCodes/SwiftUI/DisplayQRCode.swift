//
//  DisplayQRCode.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 12/8/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI
import WolfPipe
import WolfFoundation

#if DEBUG
import WolfLorem
#endif

struct DisplayQRCode: View {
    let data: Data
    let caption: String?
    let title: String
    @Binding var isActive: Bool

    init(data: Data, caption: String? = nil, title: String = "QR Code", isActive: Binding<Bool>) {
        self.data = data
        self.caption = caption
        self.title = title
        self._isActive = isActive
    }

    var body: some View {
        VStack {
            Spacer()
            QRCode(data: data)
            Spacer()
            if caption != nil {
                Text(caption!)
            }
        }
        .padding()
        .background(Color.white)
        .lightMode()
        .navigationBarItems(leading: BackButton() {
            self.isActive = false
        })
            .navigationBarTitle(title)
    }
}

#if DEBUG
struct DisplayQRCode_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            DisplayQRCode(data: "Hello" |> toUTF8, caption: Lorem.sentence(), title: Lorem.shortTitle(), isActive: .constant(true))
        }
    }

    static var previews: some View {
        NavigationView {
            Preview()
        }
        .darkMode()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
#endif

#endif
