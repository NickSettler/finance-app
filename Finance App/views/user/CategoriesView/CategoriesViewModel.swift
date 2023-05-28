//
//  CategoriesViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
//

import SwiftUI
import Foundation
import FirebaseAuth

@MainActor class CategoriesViewModel : ObservableObject {
    private(set) var currentUser: User?
    
    @Published var categories: [Category] = []
    
    @Published var deletingCategory: Category?
    
    var deletingPopoverShown: Bool {
        get {
            return self.deletingCategory != nil
        }
        set {
            //
        }
    }
    
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
    
    func deleteCategory() {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            guard let cat = self.deletingCategory else { return }
            
            _ = await cat.delete(
                from: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.CATEGORIES.rawValue)"
            )
            
            self.deletingCategory = nil
            
            await self.getUserCategories()
        }
    }
}
