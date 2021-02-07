//
//  UIViewController+Ext.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import UIKit

public extension UIViewController {
    func embed(_ childViewController: UIViewController, to parentView: UIView) {
        childViewController.view.frame = parentView.bounds
        parentView.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }

    func disembed(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}
