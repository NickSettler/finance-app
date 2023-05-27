//
//  TransanctionView.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI

struct TransanctionView: View {
    @StateObject private var viewModel: TransanctionViewModel
    
    init(transaction: Binding<Transaction>) {
        self._viewModel = StateObject(wrappedValue: TransanctionViewModel(transaction: transaction))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Name")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                Text("\(viewModel.currentTransanction.name)")
                    .foregroundColor(.TextColorPrimary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                CategoryCircleItem(category: viewModel.category)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Amount")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                Text(viewModel.currentTransanction.amount, format: .currency(code: "CZK"))
                    .foregroundColor(.TextColorPrimary)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Date and time")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                Text(viewModel.currentTransanction.timestamp.dateValue(), format: .dateTime)
                    .foregroundColor(.TextColorPrimary)
            }
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.showEditingSheet) {
            NavigationView {
                AddTransactionSheet(transaction: .init(
                    get: {
                        return self.viewModel.currentTransanction
                    }, set: { trans in
                        viewModel.currentTransanction = trans
                        viewModel.updateTransaction()
                    })
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.BackgroundColor)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showEditingSheet = true
                } label: {
                    Text("Edit")
                }
            }
        }
        .onAppear {
            viewModel.fetchCetegories()
        }
    }
}

struct TransanctionView_Previews: PreviewProvider {
    static var previews: some View {
        var transaction: Transaction = .init(
            id: "preview",
            amount: 120,
            category:
                FirebaseService.shared.database.collection("\(FirestoreCollection.USER_DATA.rawValue)").document("abc"),
            name: "Test",
            timestamp: .init(date: .now),
            notes: "Hello world!"
        )
        
        NavigationView {
            TransanctionView(transaction: .init(
                get: {
                    return transaction
                }, set: { trans in
                    transaction = trans
                })
            )
        }
    }
}
