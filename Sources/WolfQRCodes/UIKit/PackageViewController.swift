//
//  PackageViewController.swift
//  
//
//  Created by Wolf McNally on 1/24/20.
//

import WolfViewControllers
import UIKit
import WolfViews

public class PackageViewController: ViewController {
    public var isModal = false
    public var dismissButtonItem: UIBarButtonItem?
    private var dismissAction: BarButtonItemAction!

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let dismissButtonItem = dismissButtonItem {
            navigationItem.leftBarButtonItem = dismissButtonItem
            dismissAction = dismissButtonItem.addAction { [unowned self] in
                if self.isModal {
                    self.dismiss()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
