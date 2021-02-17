//
//  ComponentHeaderViewController.swift
//  UIKitSandbox
//
//  Created by DTVD on 2021/02/08.
//

import UIKit
import RxSwift
import RxCocoa
import ComponentKit

class ComponentHeaderViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var disposeBag = DisposeBag()
}

extension ComponentHeaderViewController: EventEmittable {
    typealias Event = Never
}

extension ComponentHeaderViewController: CellType {
    func apply(input: String) {
        titleLabel.text = input
    }
}
