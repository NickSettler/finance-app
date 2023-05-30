//
//  TransactionsViewViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 24.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class TransactionsViewViewModel : ObservableObject {
    private(set) var currentUser: User?
    
    @Published var transactions: [Transaction] = []
    @Published var categories: [Category] = []
    
    @Published var isSortingDesc: Bool = true
    
    @Published var isFilterSheetPresent: Bool = false
    @Published var afterDate: Date = .now
    @Published var beforeDate: Date = .now
    @Published var direction: Int = 0
    @Published var selectedCategories: Set<Category> = []
    
    @Published var deletingTransaction: Transaction?
    
    var isDeletingModalShown: Bool {
        get {
            return self.deletingTransaction != nil
        }
        set {
            //
        }
    }
    
    private var initialAfterDate: Date {
        guard let firstTransaction = self.transactions
            .sorted(by: \.timestamp.seconds, using: (<))
            .first else { return .now }
        
        return firstTransaction.timestamp.dateValue()
    }
    
    private var initialBeforeDate: Date = .now
    
    var canReset: Bool {
        let afterDateChanged = abs(initialAfterDate.timeIntervalSince(afterDate)) > 60 * 60 * 24
        let beforeDateChanged = abs(initialBeforeDate.timeIntervalSince(beforeDate)) > 60 * 60 * 24
        let directionChanged = direction != 0
        let categoriesChanged = selectedCategories.count > 0
        
        return afterDateChanged || beforeDateChanged || directionChanged || categoriesChanged
    }
    
    var filteredTransactions: [Transaction] {
        get {
            self.transactions
                .filter { transaction in
                    let isAfterDateMatch = afterDate.timeIntervalSince(transaction.timestamp.dateValue()) <= 0
                    let isBeforeDateMatch = beforeDate.timeIntervalSince(transaction.timestamp.dateValue()) >= 0
                    
                    let checkDirection = direction != 0
                    let satisfyDirection = direction == 1 && transaction.amount > 0 || direction == -1 && transaction.amount < 0
                    
                    let checkCategory = selectedCategories.count > 0
                    let satisfyCategory = selectedCategories.contains {
                        $0.id == transaction.category.documentID
                    }
                    
                    return isAfterDateMatch && isBeforeDateMatch && (!checkDirection || satisfyDirection) && (!checkCategory || satisfyCategory)
                }
                .sorted(by: \.timestamp.seconds, using: isSortingDesc ? (>) : (<))
        }
        set {
            //
        }
    }
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func fetchTransactions() {
        Task {
            guard let uid = self.currentUser?.uid else { return }
            
            do {
                self.transactions = try await TransactionService.getTransactions(for: uid).get()
                
                resetFilters()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchCategories() {
        Task {
            guard let uid = self.currentUser?.uid else { return }
            
            do {
                self.categories = try await CategoryService.getCategories(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func resetFilters() {
        afterDate = initialAfterDate
        beforeDate = .now
        direction = 0
        selectedCategories = []
        
        isFilterSheetPresent = false
        
        print(self.transactions, self.filteredTransactions)
    }
    
    func deleteTransaction() {
        Task {
            guard let uid = self.currentUser?.uid else { return }
            
            guard let transaction = self.deletingTransaction else { return }
            
            _ = await transaction.delete(from: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.TRANSACTIONS.rawValue)")
            
            self.deletingTransaction = nil
            
            self.fetchTransactions()
        }
    }
}
