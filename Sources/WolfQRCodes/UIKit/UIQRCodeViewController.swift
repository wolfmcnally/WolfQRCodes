//
//  UIQRCodeViewController.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 12/20/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import UIKit
import WolfAutolayout
import WolfPipe
import WolfViews
import WolfWith
import WolfStrings
import WolfNesting
import WolfConcurrency

class UIQRCodeViewController: AppViewController {
    init(data: Data, caption: String = "", title: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        self.caption = caption
        syncColor()
        titleLabel.attributedText = title§ |> sectionStyle |> withForegroundColor(.black)
        sync()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setup() {
        super.setup()
        hidesBottomBarWhenPushed = true
    }

    private lazy var titleLabel = Label() |> textAlignment(.center) |> numberOfLines(0)

    private lazy var qrCodeView = UIQRCodeView() • { (🍒: UIQRCodeView) in
        🍒.constrainAspect()
    }

    private lazy var captionLabel = Label() |> textAlignment(.center) |> numberOfLines(0)

    private lazy var actionButton = Button() |> setAction { [unowned self] in self.actionButtonTapped() }

    private lazy var enclosedQRCodeView = encloseCenteredHorizontally <| qrCodeView

    private lazy var stackView = StackView() |> columnStyle |> addArrangedSubviews([
        titleLabel,
        enclosedQRCodeView,
        captionLabel,
        actionButton
        ])

    private lazy var stackViewContainer = encloseCenteredVertically <| stackView

    override func build() {
        super.build()

        dismissButtonItem = UIBarButtonItem(barButtonSystemItem: .done)

        view => [
            stackViewContainer
        ]

        stackViewContainer.constrainFrameToMargins()

        Constraints(
            qrCodeView.widthAnchor == view.layoutMarginsGuide.widthAnchor =&= .defaultHigh,
            qrCodeView.widthAnchor <= view.layoutMarginsGuide.widthAnchor,
            qrCodeView.widthAnchor <= 500,
            stackView.heightAnchor <= view.layoutMarginsGuide.heightAnchor
        )
    }

    var data: Data! {
        didSet { syncData() }
    }

    var caption: String! {
        didSet { syncCaption() }
    }

    var color: UIColor! {
        didSet { syncColor() }
    }

    var action: Block?
    var actionTitle: String? {
        didSet { syncActionTitle() }
    }

    private func syncData() {
        qrCodeView.data = data
    }

    private func syncCaption() {
        captionLabel.attributedText = caption§ |> normalStyle |> withForegroundColor(.black)
    }

    private func syncActionTitle() {
        guard let actionTitle = actionTitle else { return }
        _ = actionButton |> textStyle(actionTitle)
    }

    private func syncColor() {
        qrCodeView.color = .black
    }

    private func sync() {
        syncData()
        syncCaption()
        syncColor()
        syncActionTitle()
    }

    private func actionButtonTapped() {
        action?()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
    }
}
