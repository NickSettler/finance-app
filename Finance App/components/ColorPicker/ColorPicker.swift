//
//  ColorPicker.swift
//  Finance App
//
//  Created by Nikita Moiseev on 29.05.2023.
//

import SwiftUI

struct ColorPicker: View {
    @Environment(\.presentationMode) var presentationMode
    
    var colors: [Color]
    @Binding var color: Color
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 64, maximum: 64))]
            ) {
                ForEach(colors, id: \.self) { color in
                    Button {
                        self.color = color
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .padding(20)
                            .frame(maxWidth: .infinity, minHeight: 64)
                            .background(Color(UIColor.systemGroupedBackground))
                            .cornerRadius(8)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                    .hoverEffect(.lift)
                }
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(
            colors: categoryColors,
            color: .init(get: {
                return .black
            }, set: { color in
                print(String(format: "%x", color.toHex() ?? 0))
            })
        )
    }
}
