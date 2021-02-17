//
//  SimpleCell.swift
//  UIKitSandbox
//
//  Created by DTVD on 2021/02/18.
//

import UIKit

class SimpleCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
