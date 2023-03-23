//
//  AuthHistoryViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor class AuthHistoryViewModel : ObservableObject {
    @Published private(set) var items : [AuthHistoryItem] = [
        .init(timestamp: .init(date: Date()))
    ]
    
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func handleViewAppear() {
        Task {
            let uid = Auth.auth().currentUser?.uid
            
            if (uid != nil) {
                do {
                    let items = try await self.db
                        .collection(FirestoreCollection.USER_DATA.rawValue)
                        .document(uid!)
                        .collection(FirestoreCollection.AUTH_HISTORY.rawValue)
                        .getDocuments()
                    
                    for document in items.documents {
                        do {
                            let item = try document.data(as: AuthHistoryItem.self)
                            self.items.append(item)
                        } catch {
                            print(error)
                        }
                    }
                } catch {
                    print("Error getting documents: \(error)")
                }
            }
        }
    }
}
