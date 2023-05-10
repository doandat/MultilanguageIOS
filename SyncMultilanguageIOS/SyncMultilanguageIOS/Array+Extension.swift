//
//  Array+Extension.swift
//  SyncMultilanguageIOS
//
//  Created by DatDV1 on 10/05/2023.
//

import Foundation

public extension Array {
    func sofValue(at index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
    mutating func sofCommonAddOrInsert(_ element: Element, at index: Int) {
        if index < count {
            insert(element, at: index)
        } else {
            append(element)
        }
    }
}
