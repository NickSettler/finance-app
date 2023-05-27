//
//  TransactionListItem.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI

struct TransactionListItem: View {
    @State var transaction: Transaction
    @State var colorAmount: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "\(transaction.category.icon)")
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
                Text("\(transaction.name)")
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
                    .foregroundColor(
                        colorAmount ?
                        (transaction.amount < 0 ? .red : .green) :
                                .TextColorPrimary)
                
                Text(transaction.timestamp.dateValue(), style: .time)
                    .font(.footnote)
                    .foregroundColor(.TextColorSecondary)
            }
        }
    }
}

struct TransactionListItem_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListItem(
            transaction: .init(
                amount: 12,
                category: .init(name: "Home", icon: "house.fill"),
                name: "Something",
                timestamp: .init(date: .now)
            )
        )
    }
}
