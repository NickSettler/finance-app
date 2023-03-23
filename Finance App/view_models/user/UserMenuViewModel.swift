//
//  UserMenuViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor class UserMenuViewModel : ObservableObject {
    @Published var currentUser: User?
    
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
        
        self.currentUser = Auth.auth().currentUser
    }
}
