//
//  Strings.swift
//  Finance App
//
//  Created by Nikita Moiseev on 23.03.2023.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
