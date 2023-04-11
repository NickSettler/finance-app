//
//  CategoriesViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
//

import Foundation
import FirebaseAuth

@MainActor class CategoriesViewModel : ObservableObject {
    @Published var categories: [Category] = []
    
    func getUserCategories() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            self.categories = try await CategoryService.getCategories(for: uid).get()
        } catch {
            print(error)
        }
    }
}
