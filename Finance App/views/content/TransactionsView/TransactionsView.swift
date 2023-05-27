//
//  TransactionsView.swift
//  Finance App
//
//  Created by Никита Моисеев on 24.05.2023.
//

import SwiftUI

struct TransactionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = TransactionsViewViewModel()
    
    var noTransactions: some View {
        VStack(alignment: .center) {
            Text("No transactions found")
                .frame(maxWidth: .infinity)
                .font(.title2)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    var filterSheet: some View {
        NavigationView {
            VStack(spacing: 12) {
                DatePicker(
                    selection: $viewModel.editingAfterDate,
                    in: ...Date.now,
                    displayedComponents: .date
                ) {
                    Text("After: ")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                }
                .onChange(of: viewModel.editingAfterDate) { value in
                    viewModel.editingBeforeDate = max(
                        value,
                        viewModel.editingBeforeDate
                    )
                }
                
                DatePicker(
                    selection: $viewModel.editingBeforeDate,
                    in: ...Date.now,
                    displayedComponents: .date
                ) {
                    Text("Before: ")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                }
                .onChange(of: viewModel.editingBeforeDate) { value in
                    viewModel.editingAfterDate = min(
                        value,
                        viewModel.editingAfterDate
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Direction")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                    
                    Picker("Direction", selection: $viewModel.direction) {
                        Text("All")
                            .tag(0)
                        
                        Text("Exponse")
                            .tag(-1)
                        
                        Text("Income")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                
                Spacer()
                Button {
                    viewModel.resetFilters()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        
                        Text("Reset filters")
                    }
                }
                .disabled(!viewModel.canReset)
            }
            .padding(16)
            .navigationBarItems(
                leading: Button {
                    viewModel.isFilterSheetPresent = false
                } label: {
                    Text("Close")
                },
                trailing: Button {
                    viewModel.applyFilters()
                } label: {
                    Text("Apply")
                }
            )
        }
    }
    
    var transactionsList: some View {
        List(viewModel.filteredTransactions, id: \.id) { transaction in
            TransactionListItem(transaction: transaction)
                .listRowBackground(Color.BackgroundColor)
                .background(Color.BackgroundColor)
        }
        .listStyle(.grouped)
        .background(Color.BackgroundColor)
        .scrollContentBackground(.hidden)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.isSortingDesc.toggle()
                    }
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(viewModel.isSortingDesc ? 0 : 180))
                        
                        Text(viewModel.isSortingDesc ? "Descending" : "Ascending")
                    }
                }
                
                Spacer()
                
                Button {
                    viewModel.displayFilters()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "line.3.horizontal.decrease")
                        
                        Text("Filter")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(12)
            .sheet(isPresented: $viewModel.isFilterSheetPresent) {
                filterSheet
            }
            
            if viewModel.filteredTransactions.count == 0 {
                List {
                    noTransactions
                        .listRowSeparatorTint(.clear)
                        .listRowBackground(Color.BackgroundColor)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .background(Color.BackgroundColor)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else {
                transactionsList
            }
        }
        .background(Color.BackgroundColor)
        .onAppear {
            viewModel.fetchTransactions()
        }
        .refreshable {
            viewModel.fetchTransactions()
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
