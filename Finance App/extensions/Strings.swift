//
//  Strings.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
