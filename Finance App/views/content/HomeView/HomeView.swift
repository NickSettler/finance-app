//
//  HomeView2.swift
//  Finance App
//
//  Created by Никита Моисеев on 26.05.2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    @StateObject private var viewModel = HomeViewModel()
    
    var balance : some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Your balance")
                .font(.caption)
                .foregroundColor(.TextColorSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(1232.54, format: .currency(code: "CZK"))
                .font(.largeTitle.bold())
                .kerning(1.3)
                .foregroundColor(.TextColorPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    var actions : some View {
        HStack (alignment: .center) {
            action("house.fill", "Send") {
                print("sending money")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(maxWidth: 1, maxHeight: 32)
                .overlay(Color.TextColorSecondary.opacity(0.3))
            
            action("house.fill", "Colors") {
                print("HI")
                changeDarkMode(state: !isDarkMode)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(maxWidth: 1, maxHeight: 32)
                .overlay(Color.TextColorSecondary.opacity(0.3))
            
            action("house.fill", "Send") {
                print("sending money")
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ColorPrimary)
        }
    }
    
    @ViewBuilder
    func action(
        _ icon: String,
        _ name: String,
        _ callback: @escaping () -> ()
    ) -> some View {
        Button(action: callback) {
            VStack(alignment: .center, spacing: 4) {
                Image(systemName: icon)
                Text("\(name)")
                    .font(.caption)
            }
            .foregroundColor(Color.TextColorPrimary)
        }
        .buttonStyle(.plain)
    }
    
    var operations : some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 8) {
                Text("Transactions")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Picker("Dates", selection: .constant(1)) {
                    ForEach (0...6, id: \.self) { i in
                        Text("\(i)")
                    }
                }
                .tint(.ColorPrimary)
                .pickerStyle(.menu)
            }
            
            if viewModel.recentTransactions.count > 0 {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(123.2, format: .currency(code: "CZK"))
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("spent in March")
                        .font(.caption)
                }
                
                Divider()
                    .overlay(Color.TextColorSecondary.opacity(0.3))
                
                operationsList
            } else {
                Text("No recent transactions")
                    .foregroundColor(.TextColorSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ColorPrimary)
        }
    }
    
    var operationsList : some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(viewModel.recentTransactions, id: \.id) { transaction in
                    HStack(alignment: .center, spacing: 8) {
                        let category = viewModel.categories.first {
                            $0.id == transaction.id
                        } ?? unknownCategory
                        
                        Image(systemName: "\(category.icon)")
                            .padding(8)
                            .frame(
                                width: 40,
                                height: 40
                            )
                            .foregroundColor(.TextColorPrimary)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.TextColorPrimary.opacity(0.12))
                            }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(transaction.name ?? "")")
                                .fontWeight(.medium)
                                .foregroundColor(.TextColorPrimary)
                            
                            Text("Transfer")
                                .font(.footnote)
                                .foregroundColor(.TextColorSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(transaction.amount, format: .currency(code: "CZK"))
                                .font(.callout)
                                .foregroundColor(.TextColorPrimary)
                            
                            Text(transaction.timestamp.dateValue(), style: .time)
                                .font(.footnote)
                                .foregroundColor(.TextColorSecondary)
                        }
                    }
                    .padding(.bottom, 8)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            balance
            
            Divider()
                .overlay(Color.TextColorSecondary.opacity(0.3))
            
            VStack(alignment: .center, spacing: 12) {
                actions
                    .padding(.all, 16)
                    .padding(.top, 8)
                
                operations
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 20)
            
            Spacer()
        }
        .background(Color.BackgroundColor)
    }
    
    func changeDarkMode(state: Bool) {
        isDarkMode = state
        let window = UIApplication.shared.windows.first
        window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
