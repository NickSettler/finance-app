//
//  UserDataViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 31.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class UserDataViewModel : ObservableObject {
    private(set) var currentUser: User? = Auth.auth().currentUser
    
    var photoUrl: URL? {
        get {
            if let url = currentUser?.photoURL {
                return url
            }
            
            return URL(string: "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg")
        }
    }
    
    @Published var editMode = false
    @Published var isImageFullscreen = false
    
    @Published var userData: UserData = .empty()
    @Published var editedUserData: UserData = .empty()
    
    var dataChanged: Bool {
        return userData.full_name != editedUserData.full_name
    }
    
    func fetchUserData() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.userData = try await UserService.getUserData(by: uid).get()
                self.editedUserData = self.userData
            } catch {
                self.userData = .empty()
                self.editedUserData = .empty()
                print(error)
            }
        }
    }
    
    func applyChanges() {
        Task {
            if editedUserData != userData {
                if userData.isEmpty {
                    guard let uid = currentUser?.uid else { return }
                    
                    editedUserData.id = uid
                }
                
                _ = await editedUserData.put(to: FirestoreCollection.USER_DATA.rawValue)
            }
            
            fetchUserData()
            
            editMode = false
        }
    }
    
    func dismissChanges() {
        editedUserData = userData
        editMode = false
    }
}
