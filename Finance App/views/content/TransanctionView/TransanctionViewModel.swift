//
//  TransanctionViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor class TransanctionViewModel : ObservableObject {
    private(set) var currentUser: User?
    private(set) var transactionBinding: Binding<Transaction>
    
    @Published var categories: [Category] = []
    
    @Published var currentTransanction: Transaction
    
    @Published var showEditingSheet: Bool = false
    
    var category: Category {
        get {
            return self.categories.first {
                $0.id == self.currentTransanction.category.documentID
            } ?? unknownCategory
        }
    }
    
    init(transaction: Binding<Transaction>) {
        self.currentUser = Auth.auth().currentUser
        self.transactionBinding = transaction
        self.currentTransanction = transaction.wrappedValue
    }
    
    func fetchCetegories() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.categories = try await CategoryService.getCategories(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func updateTransaction() {
        Task {
            guard let uid = self.currentUser?.uid else { return }
            
            _ = await self.currentTransanction.put(to: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.TRANSACTIONS.rawValue)")
            
            showEditingSheet = false
        }
    }
}
