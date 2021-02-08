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

public extension Convertible where Target == Self {
    func convert() -> Self {
        return self
    }
}

public protocol Representable {
    associatedtype Source
    init(from: Source)
}

public extension Representable where Source == Self {
    init(from: Source) {
        self = from
    }
}
