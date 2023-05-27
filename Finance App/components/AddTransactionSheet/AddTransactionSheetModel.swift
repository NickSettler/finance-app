//
//  AddTransactionSheetModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI
import Foundation
import FirebaseAuth

@MainActor class AddTransactionSheetModel : ObservableObject {
    private(set) var transactionBinding: Binding<Transaction>
    private(set) var currentUser: User?
    
    @Published var currentTransaction: Transaction
    @Published var direction: Bool = false
    @Published var categories: [Category] = []
    
    @Published var addNewCategorySheetPresent: Bool = false
    
    var category: Category {
        get {
            return categories.first {
                $0.id == currentTransaction.category.documentID
            } ?? unknownCategory
        }
    }
    
    init(transaction: Binding<Transaction>) {
        self.currentUser = Auth.auth().currentUser
        self.transactionBinding = transaction
        self.currentTransaction = transaction.wrappedValue
        self.direction = self.currentTransaction.amount > 0
        self.currentTransaction.amount = abs(self.currentTransaction.amount)
    }
    
    func save() {
        self.currentTransaction.amount *= self.direction ? 1 : -1;
        self.transactionBinding.wrappedValue = self.currentTransaction
    }
    
    func updateCategory(category: Category) {
        guard let uid = self.currentUser?.uid else { return }
        
        guard let catId = category.id else { return }
        
        self.currentTransaction.category = FirebaseService.shared.database
            .collection(FirestoreCollection.USER_DATA.rawValue)
            .document(uid)
            .collection(FirestoreCollection.CATEGORIES.rawValue)
            .document(catId)
    }
    
    func fetchCategories() {
        Task {
            do {
                guard let uid = currentUser?.uid else { return }
                
                self.categories = try await CategoryService.getCategories(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func createCategory(category: Category) {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            _ = await category.post(
                to: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.CATEGORIES.rawValue)"
            )
            
            self.fetchCategories()
        }
    }
}
