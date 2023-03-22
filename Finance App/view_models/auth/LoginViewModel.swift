//
//  LoginViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.03.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor class LoginViewModel: ObservableObject {
    @Published var emailValue: String = ""
    @Published var passwordValue: String = ""
    @Published var error: String = "Error bla bla bla"
    
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: emailValue, password: passwordValue) { [weak self] authResult, error in
            if (error != nil) {
                withAnimation {
                    self?.error = error!.localizedDescription
                }
                
                return
            }
            
            let uid = authResult!.user.uid
            
            let doc = self!.db
                .collection(FirestoreCollection.USER_DATA.rawValue)
                .document(uid)
                .collection(FirestoreCollection.AUTH_HISTORY.rawValue)
                .document()
            
            doc.setData([
                "timestamp": Timestamp(date: Date()),
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(doc.documentID)")
                }
            }
        }
    }
}
