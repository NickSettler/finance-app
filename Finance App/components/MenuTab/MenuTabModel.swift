//
//  MenuTabModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 17.05.2023.
//

import Foundation

enum MenuTabModel : String, CaseIterable {
    case home = "Home"
    case transactions = "Transanctions"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .transactions:
            return "arrow.left.arrow.right"
        case .settings:
            return "gearshape"
        }
    }
    
    var index: Int {
        return MenuTabModel.allCases.firstIndex(of: self) ?? 0
    }
}
