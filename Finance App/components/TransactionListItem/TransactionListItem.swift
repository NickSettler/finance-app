//
//  TransactionListItem.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI

struct TransactionListItem: View {
    var transaction: Transaction
    var categories: [Category]
    
    var category: Category {
        get {
            return categories.first {
                $0.id == transaction.category.documentID
            } ?? unknownCategory
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
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
                Text("\(transaction.name)")
                    .fontWeight(.medium)
                    .foregroundColor(.TextColorPrimary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Image(systemName: transaction.amount < 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.TextColorSecondary)
                    
                    Text(transaction.amount < 0 ? "Expense" : "Income")
                        .font(.footnote)
                        .foregroundColor(.TextColorSecondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(transaction.amount, format: .currency(code: "CZK"))
                    .font(.callout)
                    .foregroundColor(.TextColorPrimary)
                
                Text(transaction.timestamp.dateValue(), format: .dateTime)
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
                category: FirebaseService.shared.database
                    .collection("CATS")
                    .document("abc"),
                name: "Something",
                timestamp: .init(date: .now)
            ),
            categories: [
                .init(id: "abc", name: "test", icon: "house.fill")
            ]
        )
    }
}
