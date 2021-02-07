//
//  BundleLoadable.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

public protocol BundleLoadable: AnyObject {
    static var bundle: Bundle { get }
    var bundle: Bundle { get }
}

public extension BundleLoadable where Self: UIViewController {
    static var bundle: Bundle {
        return Bundle(for: self)
    }

    var bundle: Bundle {
        return Self.bundle
    }
}

extension UIViewController: BundleLoadable {}

// Create a Xib and a ViewController with same name
// Inside init()
// super.init(nibName: UnlockViewController.className, bundle: UnlockViewController.bundle)
