//
//  RoundedTextFieldStyle.swift
//  Finance App
//
//  Created by Nikita Moiseev on 27.05.2023.
//

import SwiftUI

struct RoundedTextFieldStyle : TextFieldStyle {
    @FocusState var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
                .focused($isFocused)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(.TextColorPrimary)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(isFocused ? Color.Accent : Color.TextColorSecondary, lineWidth: 2)
                )
                .animation(isFocused ? .easeIn(duration: 0.1) : .easeOut(duration: 0.0), value: isFocused)
    }
}
