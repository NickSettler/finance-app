//
//  UserMenuViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 23.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor class UserMenuViewModel : ObservableObject {
    @Published var currentUser: User?
    @Published var fullName: String?
    
    @Published var offsetY: CGFloat = 0
    
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
        
        self.currentUser = Auth.auth().currentUser
    }
    
    func handleAppear() {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            do {
                self.fullName = try await UserService.getUserData(by: uid).get().full_name
            } catch {
                print(error)
            }
        }
    }
    
    func displayName() -> String {
        return self.fullName ?? "Anonymous"
    }
    
    func photoURL() -> URL {
        guard currentUser?.photoURL != nil else {
            return URL(string: "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg")!
        }
        
        return currentUser!.photoURL!
    }
    
    func logOut() {
        do {
            _ = try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
