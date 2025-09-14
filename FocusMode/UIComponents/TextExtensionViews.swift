//
//  TextExtensionViews.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/09/25.
//

import SwiftUI

struct TextModifier: ViewModifier {
    var textType: AppFonts
    var textColor: Color
    
    func body(content: Content) -> some View {
        content.font(textType.font)
            .fontWeight(textType.fontWeight)
            .foregroundStyle(textColor)
    }
}

extension View {
    func styleText(of type: AppFonts, with color: Color) -> some View {
        modifier(TextModifier(textType: type, textColor: color))
    }
}
