//
//  ViewModifiers.swift
//  SwiftUICalculator
//
//  Created by manuel.tirado on 3/11/23.
//

import Foundation
import SwiftUI

struct SplashTextModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
    }
}

struct ButtonTextModifier: ViewModifier {
    
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let backgroundColor: Color
    var isSelected: () -> Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .frame(width: buttonWidth, height: buttonHeight)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(buttonWidth)
            .overlay(
                Capsule()
                    .stroke(isSelected() ? .red : .clear, lineWidth: 5)
                    .frame(width: buttonWidth, height: buttonHeight)
            )
    }
}

struct TextDisplayModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 54, weight: .bold))
            .minimumScaleFactor(0.7)
            .foregroundColor(.white)
    }
}
