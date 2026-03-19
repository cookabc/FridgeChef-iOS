import SwiftUI

// MARK: - Color Definitions
public extension Color {
    static let deepRoyalBlue = Color(red: 0.10, green: 0.14, blue: 0.49) // #1a237e
    static let acidGreen = Color(red: 0.8, green: 1.0, blue: 0.0) // #CCFF00
}

// MARK: - NeoPopStyle ViewModifier
struct NeoPopStyle: ViewModifier {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let borderWidth: CGFloat = 3
    let shadowOffset: CGFloat = 6
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .strokeBorder(Color.black, lineWidth: borderWidth)
            )
            .shadow(color: Color.black, radius: 0, x: shadowOffset, y: shadowOffset)
    }
}

// MARK: - View Extensions
public extension View {
    func neoPopStyle(backgroundColor: Color = .white, cornerRadius: CGFloat = 24) -> some View {
        self.modifier(NeoPopStyle(backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
    
    func neoPopBlue() -> some View {
        self.neoPopStyle(backgroundColor: .deepRoyalBlue)
    }
    
    func neoPopGreen() -> some View {
        self.neoPopStyle(backgroundColor: .acidGreen)
    }
    
    func neoPopCapsule(backgroundColor: Color = .white) -> some View {
        self.neoPopStyle(backgroundColor: backgroundColor, cornerRadius: 9999)
    }
}

// MARK: - NeoPopButtonStyle
struct NeoPopButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let cornerRadius: CGFloat = 9999
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: Color.black, radius: 0, x: 6, y: 6)
            .offset(x: configuration.isPressed ? 6 : 0, y: configuration.isPressed ? 6 : 0)
    }
}

extension ButtonStyle where Self == NeoPopButtonStyle {
    static func neoPop(backgroundColor: Color = .white) -> NeoPopButtonStyle {
        NeoPopButtonStyle(backgroundColor: backgroundColor)
    }
}

// MARK: - NeoPopTextFieldStyle
struct NeoPopTextFieldStyle: TextFieldStyle {
    let cornerRadius: CGFloat = 9999
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: 3)
            )
            .shadow(color: Color.black, radius: 0, x: 6, y: 6)
    }
}

extension TextFieldStyle where Self == NeoPopTextFieldStyle {
    static var neoPop: NeoPopTextFieldStyle { .init() }
}

// MARK: - NeoPopTagStyle
struct NeoPopTagStyle: ViewModifier {
    let isSelected: Bool
    let cornerRadius: CGFloat = 9999
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.acidGreen : Color.white)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: 2)
            )
            .shadow(color: Color.black, radius: 0, x: 2, y: 2)
    }
}

extension View {
    func neoPopTagStyle(isSelected: Bool) -> some View {
        self.modifier(NeoPopTagStyle(isSelected: isSelected))
    }
}
