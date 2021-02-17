//
//  ComponentCellViewController.swift
//  UIKitSandbox
//
//  Created by DTVD on 2021/02/08.
//

import UIKit
import RxCocoa
import RxSwift
import ComponentKit

class ComponentCellViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var disposeBag = DisposeBag()
}

extension ComponentCellViewController: CellType {
    func apply(input: CellData) {
        titleLabel.text = input.title
        imageView.image = input.image
    }
}

extension ComponentCellViewController: EventEmittable {
    typealias Event = Never
}

struct CellData: Convertible {
    let title: String
    let image: UIImage?
}
