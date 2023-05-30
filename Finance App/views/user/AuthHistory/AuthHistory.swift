//
//  AuthHistory.swift
//  Finance App
//
//  Created by Nikita Moiseev on 22.03.2023.
//

import SwiftUI

struct AuthHistory: View {
    @StateObject var viewModel = AuthHistoryViewModel()
    
    var body: some View {
        List(viewModel.items, id: \.id) { item in
            Text("\(item.timestamp.formatted(date: .long, time: .standard))")
                .listRowBackground(Color.ColorPrimary)
        }
        .background(Color.BackgroundColor)
        .scrollContentBackground(.hidden)
        .onAppear {
            viewModel.handleViewAppear()
        }
        .refreshable(action: viewModel.handleRefresh)
    }
}

struct AuthHistory_Previews: PreviewProvider {
    static var previews: some View {
        AuthHistory()
    }
}
