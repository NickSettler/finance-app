//
//  Finance_AppApp.swift
//  Finance App
//
//  Created by Никита Моисеев on 17.03.2023.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
    }
}

@main
struct Finance_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.BackgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
}
