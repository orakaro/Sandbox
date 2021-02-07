//
//  Array+Ext.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
