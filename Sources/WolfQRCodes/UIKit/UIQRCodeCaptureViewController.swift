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
import SwiftUI
import WolfSwiftUI

enum CaptureAction {
    case dismiss
    case `continue`
    case displayCount(Int, Bool)
}

class UIQRCodeCaptureViewController: AppViewController {
    var onCaptureData: ((Data) -> CaptureAction)?
    var onMock: (() -> Data)?

    private lazy var titleBackground = View() • { (🍒: WolfViews.View) in
        🍒.backgroundColor = .transparentDarkBackground
        🍒.isUserInteractionEnabled = false
    }

    private lazy var titleLabel = Label() • { (🍒: Label) in
        _ = 🍒 |> resistVerticalCompression
        🍒.numberOfLines = 0
        🍒.textAlignment = .center
    }

    private lazy var contentArea = View()

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.attributedText = title§ |> sectionStyle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        hidesBottomBarWhenPushed = true
    }

    lazy var reticleViewController = SwiftUIHostingController(self) { Reticle() }
    lazy var reticleView = reticleViewController.view!

    private lazy var qrCodeCaptureView = UIQRCodeCaptureView()

    override func viewDidLoad() {
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

    override func build() {
        super.build()

        dismissButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel)

        view => [
            qrCodeCaptureView,
            titleBackground => [
                titleLabel
            ],
            contentArea => [
                reticleView
            ]
        ]

        qrCodeCaptureView.constrainFrameToFrame()

        let titleMargin: CGFloat = 15

        Constraints(
            titleBackground.leadingAnchor == view.leadingAnchor,
            titleBackground.trailingAnchor == view.trailingAnchor,
            titleBackground.topAnchor == view.safeAreaLayoutGuide.topAnchor,
            titleBackground.bottomAnchor == titleLabel.bottomAnchor + titleMargin,

            titleLabel.leadingAnchor == titleBackground.leadingAnchor + titleMargin,
            titleLabel.trailingAnchor == titleBackground.trailingAnchor - titleMargin,
            titleLabel.topAnchor == titleBackground.topAnchor + titleMargin,
            titleLabel.bottomAnchor == titleBackground.bottomAnchor - titleMargin,

            contentArea.topAnchor == titleBackground.bottomAnchor,
            contentArea.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor,
            contentArea.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor,
            contentArea.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor
        )

        reticleView.constrainCenterToCenter()
        Constraints(
            reticleView.heightAnchor == contentArea.heightAnchor * 0.7 =&= .defaultHigh,
            reticleView.widthAnchor == contentArea.widthAnchor * 0.7 =&= .defaultHigh,
            reticleView.widthAnchor <= 500
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrCodeCaptureView.startVideoCapture()
    }

    override func viewWillDisappear(_ animated: Bool) {
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

    override func dismiss() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss()
    }
}
