//
//  AuthHistoryViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor class AuthHistoryViewModel : ObservableObject {
    @Published private(set) var items : [AuthHistoryItem] = []
    
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func abc() {
    }
}
