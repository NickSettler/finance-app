//
//  CategoriesViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
//

import Foundation
import FirebaseAuth

@MainActor class CategoriesViewModel : ObservableObject {
    private(set) var currentUser: User?
    
    @Published var categories: [Category] = []
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func getUserCategories() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            self.categories = try await CategoryService.getCategories(for: uid).get()
        } catch {
            print(error)
        }
    }
    
    func saveCategory(category: Category) {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            _ = await category.put(
                to: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.CATEGORIES.rawValue)"
            )
            
            await self.getUserCategories()
        }
    }
    
    func createCategory(category: Category) {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            _ = await category.post(
                to: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.CATEGORIES.rawValue)"
            )
            
            await self.getUserCategories()
        }
    }
}
