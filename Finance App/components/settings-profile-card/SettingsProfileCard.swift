//
//  SettingsProfileCard.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import SwiftUI

struct SettingsProfileCard: View {
    @StateObject private var viewModel = SettingsProfileCardViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            AsyncImage(
                url: viewModel.photoURL(),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            
            VStack(alignment: .center, spacing: 8) {
                Text("\(viewModel.displayName())")
                    .font(.headline)
                Text("\(viewModel.email())")
                    .font(.caption)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.handleAppear()
        }
    }
}

struct SettingsProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        SettingsProfileCard()
    }
}
