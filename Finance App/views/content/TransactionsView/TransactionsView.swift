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
                }
                .onChange(of: viewModel.editingBeforeDate) { value in
                    viewModel.editingAfterDate = min(
                        value,
                        viewModel.editingAfterDate
                    )
                }
                
                Spacer()
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
            HStack(alignment: .center, spacing: 20) {
                let isExpense = transaction.amount < 0
                
                Image(systemName: isExpense ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                    .foregroundColor(isExpense ? .red : .green)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 4) {
                        Text("\(transaction.name ?? "")")
                        Spacer()
                        Text(transaction.timestamp.dateValue(), style: .relative)
                            .font(.caption2)
                    }
                    
                    Text("\(transaction.amount.formatted(.currency(code: "CZK")))")
                        .font(.caption)
                }
            }
        }
        .listStyle(.grouped)
        .background(colorScheme == .light ? .white : .black)
        .scrollContentBackground(.hidden)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
            } else {
                transactionsList
            }
        }
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
