//
//  CustomComponents.swift

//
//  Created by Бабаханова Шаира on 16.03.2025.
//

import SwiftUI

struct CustomButtonStyle: ViewModifier {
    var textColor: Color = .white
    var backgroundColor: Color
    var cornerRadius: CGFloat = 7
    
    func body(content: Content) -> some View {
        content
            .padding(13)
            .foregroundColor(textColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            
    }
}

struct CustomTextField: ViewModifier {
    var cornerRadius: CGFloat = 8
    var borderColor: Color = .gray
    var shadowColor: Color = .gray.opacity(0.5)
   
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.gray, lineWidth: 1))
            .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            .padding(.horizontal)
    }
}

struct CustomIcons: ViewModifier {
    var iconColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .frame(width: 20, height: 20)
            .padding(.leading)
            .foregroundColor(iconColor)
            .scaledToFit()
    }
}



extension View {
    func customButtonStyle(backgroundColor: Color, textColor: Color = .white, cornerRadius: CGFloat = 7) -> some View {
        self.modifier(CustomButtonStyle(textColor: textColor, backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
    
    func customTextField(cornerRadius: CGFloat = 8, borderColor: Color = .gray, shadowColor: Color = .gray.opacity(0.5)) -> some View {
        self.modifier(CustomTextField(cornerRadius: cornerRadius, borderColor: borderColor, shadowColor: shadowColor))
    }
    
    func customIcons(iconColor: Color = .blue) -> some View {
        self.modifier(CustomIcons(iconColor: iconColor))
    }
}

