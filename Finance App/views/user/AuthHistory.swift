//
//  AuthHistory.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import SwiftUI

struct AuthHistory: View {
    @StateObject private var viewModel = AuthHistoryViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.items, id: \.id) { item in
                Text("\(item.timestamp)")
            }
        }
    }
}

struct AuthHistory_Previews: PreviewProvider {
    static var previews: some View {
        AuthHistory()
    }
}
