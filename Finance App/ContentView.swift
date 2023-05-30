//
//  ContentView.swift
//  Finance App
//
//  Created by Nikita Moiseev on 17.03.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var body: some View {
        MainView()
            .background(Color.BackgroundColor.edgesIgnoringSafeArea(.all))
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
