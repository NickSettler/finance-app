//
//  HomeVIew2Model.swift
//  Finance App
//
//  Created by Никита Моисеев on 26.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class HomeViewModel : ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var categories: [Category] = []
    @Published var userData: UserData?
    
    @Published var showAddTransactionSheet: Bool = false
    @Published var showUpdateBalanceSheet: Bool = false {
        didSet {
            self.fetchUserData()
        }
    }
    
    private(set) var currentUser: User?
    
    var photoUrl: URL? {
        get {
            if let url = currentUser?.photoURL {
                return url
            }
            
            return URL(string: "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg")
        }
    }
    
    var balance: Double {
        get {
            self.transactions.reduce(self.userData?.balance ?? 0) { sum, transaction in
                sum.advanced(by: transaction.amount)
            }
        }
    }
    
    var recentSpent: Double {
        get {
            self.recentTransactions.reduce(self.userData?.balance ?? 0) { sum, transaction in
                sum.advanced(by: transaction.amount)
            }
        }
    }
    
    var recentTransactions: [Transaction] {
        get {
            Array(self.transactions[..<min(self.transactions.count, 10)])
                .sorted(by: \.timestamp.seconds, using: (>))
        }
    }
    
    init() {
        self.currentUser = Auth.auth().currentUser
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
    
    func fetchTransactions() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.transactions = try await TransactionService.getTransactions(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchUserData() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.userData = try await UserService.getUserData(by: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func createTransaction(_ transaction: Transaction) {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            _ = await transaction.post(
                to: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.TRANSACTIONS.rawValue)"
            )
            
            self.fetchTransactions()
        }
    }
}
