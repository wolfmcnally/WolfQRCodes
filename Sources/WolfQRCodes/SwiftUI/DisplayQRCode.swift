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
import WolfSwiftUI

public struct DisplayQRCode: View {
    let data: Data
    let caption: String?
    let title: String
    @Binding var isPresented: Bool

    public init(data: Data, caption: String? = nil, title: String, isPresented: Binding<Bool>) {
        self.data = data
        self.caption = caption
        self.title = title
        self._isPresented = isPresented
    }

    public var body: some View {
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
        .navigationBarTitle(title)
        .navigationBarItems(leading: DoneButton() {
            self.isPresented = false
        })
    }
}

#if DEBUG
struct DisplayQRCode_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            DisplayQRCode(data: "Hello" |> toUTF8, caption: randomWords(7), title: randomWords(3), isPresented: .constant(true))
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

func randomWord() -> String {
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let count = (2...10).randomElement()!
    let letters = (0..<count).map { _ in alphabet.randomElement()! }
    return String(letters)
}

func randomWords(_ count: Int) -> String {
    return (0..<count).map({ _ in randomWord() }).joined(separator: " ")
}

#endif

#endif
