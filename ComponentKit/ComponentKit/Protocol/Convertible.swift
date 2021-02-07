//
//  Convertible.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import Foundation

public protocol Convertible {
    associatedtype Target
    func convert() -> Target
}

public protocol Representable {
    associatedtype Source
    init(from: Source)
}
