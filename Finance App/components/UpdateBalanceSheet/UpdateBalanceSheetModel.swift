//
//  UpdateBalanceSheetModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class UpdateBalanceSheetModel : ObservableObject {
    private(set) var currentUser: User?
    
    @Published var userData: UserData? {
        didSet {
            if let balance = self.userData?.balance {
                self.newBalanceValue = balance
            }
        }
    }
    @Published var newBalanceValue: Double
    
    init(balance: Double) {
        self.currentUser = Auth.auth().currentUser
        self.newBalanceValue = balance
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
    
    func save() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                _ = try await UserService.updateBalance(by: uid, self.newBalanceValue)
            } catch {
                print(error)
            }
        }
    }
}
