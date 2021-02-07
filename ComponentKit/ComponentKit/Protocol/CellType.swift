//
//  CellType.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import Foundation

public protocol Reusable {
    func prepareForReuse() -> Void // Cancel downloading image, set text to nil...
}

public extension Reusable {
    func prepareForReuse() -> Void {
    }
}

public protocol CellType : Reusable {
    associatedtype Input
    func apply(input: Input)
}
