//
//  Set.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import Foundation

extension Set {
    mutating func toggle(_ value: Element) {
        if self.contains(value) {
            self.remove(value)
        } else {
            self.insert(value)
        }
    }
}
