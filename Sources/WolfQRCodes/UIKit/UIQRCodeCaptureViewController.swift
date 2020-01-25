//
//  UIQRCodeCaptureViewController.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 1/14/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

import UIKit
import WolfViews
import WolfWith
import WolfPipe
import WolfAutolayout
import WolfStrings
import WolfNesting
import WolfConcurrency
import WolfViewControllers
import SwiftUI
import WolfSwiftUI

public enum QRCodeCaptureAction {
    case dismiss
    case `continue`
    case displayCount(Int, Bool)
}

public class UIQRCodeCaptureViewController: PackageViewController {
    public var onCaptureData: ((Data) -> QRCodeCaptureAction)?
    public var onMock: (() -> Data)?

    public var messageOverlayImage: UIImage? {
        get { qrCodeCaptureView.messageOverlayImage }
        set { qrCodeCaptureView.messageOverlayImage = newValue }
    }

    public var messageOverlayGlowImage: UIImage? {
        get { qrCodeCaptureView.messageOverlayGlowImage }
        set { qrCodeCaptureView.messageOverlayGlowImage = newValue }
    }

    private lazy var contentArea = View()

    public init(title: String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        hidesBottomBarWhenPushed = true
        isModal = true
    }

    lazy var reticleViewController = SwiftUIHostingController(self) { Reticle() }
    lazy var reticleView = reticleViewController.view!

    private lazy var qrCodeCaptureView = UIQRCodeCaptureView()

    override public func viewDidLoad() {
        super.viewDidLoad()

        qrCodeCaptureView.onReceivedCode = { [unowned self] data in
            self.handleReceivedData(data)
        }

        qrCodeCaptureView.onMockButtonPressed = { [unowned self] in
            if let onMock = self.onMock {
                self.handleReceivedData(onMock())
            }
        }
    }

    override public func build() {
        super.build()

        dismissButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel)

        view.backgroundColor = .darkGray

        view => [
            qrCodeCaptureView,
            contentArea => [
                reticleView
            ]
        ]

        qrCodeCaptureView.constrainFrameToFrame()
        contentArea.constrainFrameToSafeArea()
        reticleView.constrainCenterToCenter()

        Constraints(
            reticleView.heightAnchor == contentArea.heightAnchor * 0.7 =&= .defaultHigh,
            reticleView.widthAnchor == contentArea.widthAnchor * 0.7 =&= .defaultHigh,
            reticleView.widthAnchor <= 500
        )
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrCodeCaptureView.startVideoCapture()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrCodeCaptureView.stopVideoCapture()
    }

    private func handleReceivedData(_ data: Data) {
        switch onCaptureData?(data) ?? .dismiss {
        case .dismiss:
            dismiss()
        case .continue:
            qrCodeCaptureView.count = nil
        case .displayCount(let count, let dismiss):
            qrCodeCaptureView.count = count
            if dismiss {
                dispatchOnMain(afterDelay: 0.7) {
                    self.dismiss()
                }
            }
        }
    }
}
