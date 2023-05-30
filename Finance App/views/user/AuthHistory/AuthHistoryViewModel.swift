//
//  AuthHistoryViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 22.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class AuthHistoryViewModel : ObservableObject {
    @Published private(set) var items : [AuthHistoryItem] = []
    
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    private func updateItems() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            self.items = try await UserService.getAuthHistory(by: uid).get()
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    func handleViewAppear() {
        Task {
            await updateItems()
        }
    }
    
    @Sendable func handleRefresh() async {
        await updateItems()
    }
}
