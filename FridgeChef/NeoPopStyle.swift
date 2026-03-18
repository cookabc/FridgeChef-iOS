import SwiftUI

struct NeoPopStyle: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat = 24
    let borderWidth: CGFloat = 3
    let shadowOffset: CGFloat = 4
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: borderWidth)
            )
            .shadow(color: Color.black, radius: 0, x: shadowOffset, y: shadowOffset)
    }
}

extension View {
    func neoPopStyle(backgroundColor: Color = .white) -> some View {
        self.modifier(NeoPopStyle(backgroundColor: backgroundColor))
    }
}

struct NeoPopButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: Color.black, radius: 0, x: 4, y: 4)
            .offset(x: configuration.isPressed ? 4 : 0, y: configuration.isPressed ? 4 : 0)
            .shadow(color: Color.black, radius: 0, x: configuration.isPressed ? 0 : 4, y: configuration.isPressed ? 0 : 4)
    }
}

extension ButtonStyle where Self == NeoPopButtonStyle {
    static func neoPop(backgroundColor: Color = .white) -> NeoPopButtonStyle {
        NeoPopButtonStyle(backgroundColor: backgroundColor)
    }
}

struct NeoPopTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: Color.black, radius: 0, x: 4, y: 4)
    }
}

extension TextFieldStyle where Self == NeoPopTextFieldStyle {
    static var neoPop: NeoPopTextFieldStyle { .init() }
}

struct NeoPopTagStyle: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color(red: 0.8, green: 1.0, blue: 0.0) : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: Color.black, radius: 0, x: 2, y: 2)
    }
}

extension View {
    func neoPopTagStyle(isSelected: Bool) -> some View {
        self.modifier(NeoPopTagStyle(isSelected: isSelected))
    }
}