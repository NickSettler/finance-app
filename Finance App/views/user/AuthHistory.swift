//
//  AuthHistory.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import SwiftUI

struct AuthHistory: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AuthHistoryViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
                
                Spacer()
            }
            .padding(.horizontal.union(.top))
            
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    Text("\(item.timestamp.formatted(date: .long, time: .standard))")
                }
            }
        }
        .onAppear {
            viewModel.handleViewAppear()
        }
    }
}

struct AuthHistory_Previews: PreviewProvider {
    static var previews: some View {
        AuthHistory()
    }
}
