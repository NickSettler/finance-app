//
//  HomeViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 24.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class HomeViewViewModel : ObservableObject {
    private(set) var currentUser: User?
    
    @Published var popularCategories: [(key: Category, value: Int)] = [
        (.init(name: "abc", icon: "house.fill"), 12)
    ]
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func handleAppear() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.popularCategories = try await CategoryService.getPopularCategories(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
}
