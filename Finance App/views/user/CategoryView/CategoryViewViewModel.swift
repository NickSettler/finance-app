//
//  CategoryViewViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 23.05.2023.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor class CategoryViewViewModel : ObservableObject {
    private(set) var currentUser: User?
    
    private(set) var categories: [Category] = []
    private(set) var category: Binding<Category>
    
    @Published var editedCategory: Category
    @Published var isSymbolPickerPresent: Bool = false
    @Published var isColorPickerPresent: Bool = false
    
    private var categoriesColors: [Color] {
        get {
            return categories
                .filter { $0.id != editedCategory.id }
                .map { $0.colorObject }
        }
    }
    
    var availableColors: [Color] {
        get {
            categoryColors.filter { !categoriesColors.contains($0) }
        }
    }
    
    init(category: Binding<Category>) {
        self.currentUser = Auth.auth().currentUser
        self.category = category
        
        self.editedCategory = category.wrappedValue
    }
    
    func fetchCategories() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.categories = try await CategoryService.getCategories(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func save() {
        self.category.wrappedValue = self.editedCategory
    }
}
