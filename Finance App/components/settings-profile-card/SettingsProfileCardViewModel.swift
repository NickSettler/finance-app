//
//  SettingsProfileCardViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor class SettingsProfileCardViewModel : ObservableObject {
    @Published private var currentUser: User?
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func displayName() -> String {
        return currentUser?.displayName ?? "Anonymous"
    }
    
    func email() -> String {
        return currentUser?.email ?? "anonymous@gmail.com"
    }
    
    func photoURL() -> URL {
        guard currentUser?.photoURL != nil else {
            return URL(string: "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg")!
        }
        
        return currentUser!.photoURL!
    }
}
