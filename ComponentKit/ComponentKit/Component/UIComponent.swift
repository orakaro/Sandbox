//
//  UIComponent.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import UIKit

protocol UIComponent: AnyObject {
    associatedtype Content: UIViewController
    associatedtype Parent: UIViewController
    var contentView: UIView { get }
    var content: Content? { get set }
    var parent: Parent? { get set }
}

extension UIComponent where Self: UIView {
    func embed(content: Content, parent: Parent) {
        backgroundColor = UIColor.clear
        self.content = content
        self.parent = parent
        content.view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(content.view)
        if superview == nil {
            content.willMove(toParent: parent)
        } else {
            parent.addChild(content)
        }

        NSLayoutConstraint.activate(
            [
                content.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                content.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                content.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                content.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            ]
        )

        if superview == nil {
            content.removeFromParent()
        } else {
            content.didMove(toParent: parent)
        }
    }
}
