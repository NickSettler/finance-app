//
//  CategoryCircleItem.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI

struct CategoryCircleItem: View {
    var category: Category
    
    var selected: Bool?
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(systemName: "\(category.icon)")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(selected ?? false ? Color.TextColorPrimary : Color.TextColorSecondary)
                .padding(12)
                .background {
                    Circle()
                        .strokeBorder(
                            selected ?? false ? Color.Accent : Color.TextColorSecondary, lineWidth: 1
                        )
                        .background {
                            Circle()
                                .fill(selected ?? false ? Color.Accent.opacity(0.5) : Color.clear)
                        }
                }
            
            Text(category.name)
                .foregroundColor(selected ?? false ? Color.TextColorPrimary : Color.TextColorSecondary)
                .font(.caption2)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 44)
        }
    }
}

struct CategoryCircleItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCircleItem(
            category: .init(name: "Entertainment", icon: "house.fill")
        )
    }
}
