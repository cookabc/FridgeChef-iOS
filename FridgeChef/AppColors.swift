import SwiftUI

struct AppColors {
    // Background colors
    static var background: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0)
                : UIColor(red: 0.10, green: 0.14, blue: 0.49, alpha: 1.0)
        })
    }
    
    // Card background
    static var cardBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.0)
                : UIColor.white
        })
    }
    
    // Primary text
    static var primaryText: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.white
                : UIColor.black
        })
    }
    
    // Secondary text
    static var secondaryText: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
                : UIColor.gray
        })
    }
    
    // Accent color (Acid Green)
    static let accent = Color(red: 0.8, green: 1.0, blue: 0.0)
    
    // Shadow color
    static var shadow: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor.black.withAlphaComponent(0.5)
                : UIColor.black
        })
    }
}
