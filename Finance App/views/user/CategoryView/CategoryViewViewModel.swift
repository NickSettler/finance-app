//
//  CategoryViewViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.05.2023.
//

import Foundation
import SwiftUI

@MainActor class CategoryViewViewModel : ObservableObject {
    private(set) var category: Binding<Category>
    
    @Published var editedCategory: Category
    @Published var isSymbolPickerPresent: Bool = false
    @Published var isColorPickerPresent: Bool = false
    
    init(category: Binding<Category>) {
        self.category = category
        
        self.editedCategory = category.wrappedValue
    }
    
    func save() {
        self.category.wrappedValue = self.editedCategory
    }
}
