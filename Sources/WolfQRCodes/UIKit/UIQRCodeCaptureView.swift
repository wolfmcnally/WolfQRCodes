//
//  UIQRCodeCaptureView.swift
//  CryptoWallet
//
//  Created by Wolf McNally on 9/23/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import UIKit
import AVFoundation
import WolfViews
import WolfConcurrency
import WolfPipe
import WolfWith
import WolfNesting
import WolfFoundation
import WolfApp
import WolfAutolayout
import WolfSwiftUI

public class UIQRCodeCaptureView: View {
    public var onMockButtonPressed: Block?
    public var onReceivedCode: ((Data) -> Void)?

    private var lastReceivedCode: Data?

    var count: Int? = nil {
        didSet { syncCount() }
    }

    private lazy var messageOverlayView = MessageOverlayView() • { (🍒: MessageOverlayView) in
        🍒.size = CGSize(width: 140, height: 140)
        🍒.font = .boldSystemFont(ofSize: 60)
        🍒.highlightMessageChange = true
        🍒.hide()
    }

    public var messageOverlayImage: UIImage? {
        get { messageOverlayView.image }
        set { messageOverlayView.image = newValue }
    }

    public var messageOverlayGlowImage: UIImage? {
        get { messageOverlayView.glowImage }
        set { messageOverlayView.glowImage = newValue }
    }

    private func syncCount() {
        if let count = count {
            messageOverlayView.message = String(count)
            messageOverlayView.show(animated: true)
        } else {
            messageOverlayView.hide(animated: true)
        }
    }

    private func configureCaptureDevice(_ device: AVCaptureDevice) {
//        try! device.lockForConfiguration()
//        if device.isAutoFocusRangeRestrictionSupported {
//            device.autoFocusRangeRestriction = .near
//        }
//        device.setExposureModeCustom(duration: CMTime(value: 1, timescale: 60), iso: 100)
//        device.unlockForConfiguration()
    }

    private lazy var backCaptureDevice: AVCaptureDevice? = {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            return nil
        }
        configureCaptureDevice(device)
        return device
    }()

    private lazy var frontCaptureDevice: AVCaptureDevice? = {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
            return nil
        }
        configureCaptureDevice(device)
        return device
    }()

//    private lazy var defaultCaptureDevice = frontCaptureDevice ?? backCaptureDevice
    private lazy var defaultCaptureDevice = backCaptureDevice ?? frontCaptureDevice
    private lazy var isVideoCaptureSupported: Bool = self.defaultCaptureDevice != nil
    private lazy var deviceInput: AVCaptureDeviceInput = try! .init(device: defaultCaptureDevice!)
    private lazy var metadataOutput: AVCaptureMetadataOutput = .init() • { 🍒 in
        🍒.setMetadataObjectsDelegate(self, queue: backgroundQueue)
    }

    private lazy var captureSession: AVCaptureSession = .init() • { 🍒 in
        🍒.addInput(self.deviceInput)
        🍒.addOutput(self.metadataOutput)
        self.metadataOutput.metadataObjectTypes = [.qr]
    }

    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = .init(session: self.captureSession) • { 🍒 in
        🍒.videoGravity = .resizeAspectFill
        🍒.frame = bounds
    }

    private var mockButtonAction: ControlAction<Button>?

    private lazy var mockButton = Button(type: .system) • { 🍒 in
        🍒.setTitle("Mock", for: [])
        mockButtonAction = addTouchUpInsideAction(to: 🍒) { [unowned self] _ in
            self.onMockButtonPressed?()
        }
    }

    public override func setup() {
        super.setup()
        backgroundColor = UIColor(white: 0.5, alpha: 0.1)

        self => [
            messageOverlayView
        ]
        messageOverlayView.constrainCenterToCenter()
    }

    public func startVideoCapture() {
        guard isVideoCaptureSupported else {
            self => [
                mockButton
            ]

            mockButton.constrainCenterToCenter()
            return
        }

        layer.insertSublayer(videoPreviewLayer, at: 0)

        dispatchOnBackground {
            self.captureSession.startRunning()
        }
    }

    public func stopVideoCapture() {
        guard isVideoCaptureSupported else {
            mockButton.removeFromSuperview()
            return
        }
        captureSession.stopRunning()
    }

    private var didChangeOrientationNotificationAction: NotificationAction!

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if superview != nil {
            didChangeOrientationNotificationAction = NotificationAction(name: UIDevice.orientationDidChangeNotification) { [unowned self] _ in
                self.setNeedsLayout()
            }
        } else {
            didChangeOrientationNotificationAction = nil
        }
    }

    private func handleQRCodeData(_ data: Data) {
        guard data != lastReceivedCode else {
            return
        }
        lastReceivedCode = data
        onReceivedCode?(data)
    }

    private func updateVideoOrientation() {
        guard isVideoCaptureSupported else { return }

        func updatePreviewLayer(connection: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
            connection.videoOrientation = orientation
            videoPreviewLayer.frame = bounds
        }

        guard let connection = videoPreviewLayer.connection else { return }
        guard connection.isVideoOrientationSupported else { return }

        let currentDevice = UIDevice.current
        let orientation = currentDevice.orientation

        switch orientation {
        case .portrait:
            updatePreviewLayer(connection: connection, orientation: .portrait)
        case .landscapeRight:
            updatePreviewLayer(connection: connection, orientation: .landscapeLeft)
        case .landscapeLeft:
            updatePreviewLayer(connection: connection, orientation: .landscapeRight)
        case .portraitUpsideDown:
            updatePreviewLayer(connection: connection, orientation: .portraitUpsideDown)
        default:
            updatePreviewLayer(connection: connection, orientation: .portrait)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateVideoOrientation()
    }
}

extension UIQRCodeCaptureView: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let machineReadableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        guard machineReadableCode.type == AVMetadataObject.ObjectType.qr else { return }
        guard let stringValue = machineReadableCode.stringValue else { return }
        let data = stringValue |> toUTF8
        dispatchOnMain {
            self.handleQRCodeData(data)
        }
    }
}
