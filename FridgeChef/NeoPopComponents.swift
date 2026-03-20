import SwiftUI

// MARK: - NeoPop Segmented Control
struct NeoPopSegmentedControl<T: Hashable & CaseIterable & Identifiable>: View where T.AllCases: RandomAccessCollection {
    let title: String
    @Binding var selection: T
    let options: T.AllCases
    let displayName: (T) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.black)
                .foregroundColor(AppColors.primaryText)
            
            ZStack {
                // Shadow layer
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.shadow)
                    .offset(x: 4, y: 4)
                
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryText, lineWidth: 3)
                    )
                
                // Segments
                HStack(spacing: 0) {
                    ForEach(options) { option in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selection = option
                            }
                        }) {
                            ZStack {
                                if selection == option {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppColors.accent)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(AppColors.primaryText, lineWidth: 2)
                                        )
                                        .padding(4)
                                }
                                
                                Text(displayName(option))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(selection == option ? .black : AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(4)
            }
            .frame(height: 48)
        }
    }
}

// MARK: - NeoPop Input Field
struct NeoPopInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText)
            
            ZStack {
                // Shadow layer
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.shadow)
                    .offset(x: 4, y: 4)
                
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryText, lineWidth: 3)
                    )
                
                // Input
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .padding()
                .foregroundColor(AppColors.primaryText)
            }
            .frame(height: 48)
        }
    }
}

// MARK: - NeoPop Card
struct NeoPopCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let strokeWidth: CGFloat
    let shadowOffset: CGFloat
    
    init(
        backgroundColor: Color = AppColors.cardBackground,
        cornerRadius: CGFloat = 24,
        strokeWidth: CGFloat = 4,
        shadowOffset: CGFloat = 6,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.strokeWidth = strokeWidth
        self.shadowOffset = shadowOffset
    }
    
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(AppColors.shadow)
                .offset(x: shadowOffset, y: shadowOffset)
            
            // Content layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(AppColors.primaryText, lineWidth: strokeWidth)
                )
            
            content
                .padding()
        }
    }
}

// MARK: - NeoPop Button
struct NeoPopButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    let isLoading: Bool
    
    enum ButtonStyle {
        case primary      // Accent color background
        case secondary    // Card background
    }
    
    init(
        title: String,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 9999)
                    .fill(AppColors.shadow)
                    .offset(x: 6, y: 6)
                RoundedRectangle(cornerRadius: 9999)
                    .fill(style == .primary ? AppColors.accent : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9999)
                            .stroke(AppColors.primaryText, lineWidth: 4)
                    )
                
                if isLoading {
                    ProgressView()
                        .tint(style == .primary ? .black : AppColors.primaryText)
                } else {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(style == .primary ? .black : AppColors.primaryText)
                }
            }
            .frame(height: 56)
        }
    }
}

// MARK: - NeoPop Back Button
struct NeoPopBackButton: View {
    let action: () -> Void
    let icon: String
    
    init(action: @escaping () -> Void, icon: String = "chevron.left") {
        self.action = action
        self.icon = icon
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 9999)
                    .fill(AppColors.shadow)
                    .offset(x: 6, y: 6)
                RoundedRectangle(cornerRadius: 9999)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9999)
                            .stroke(AppColors.primaryText, lineWidth: 4)
                    )
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryText)
            }
            .frame(width: 48, height: 48)
        }
    }
}

// MARK: - NeoPop Page Header
struct NeoPopPageHeader: View {
    let title: String
    let backAction: () -> Void
    let backIcon: String
    
    init(
        title: String,
        backIcon: String = "chevron.left",
        backAction: @escaping () -> Void
    ) {
        self.title = title
        self.backIcon = backIcon
        self.backAction = backAction
    }
    
    var body: some View {
        HStack {
            NeoPopBackButton(action: backAction, icon: backIcon)
            Text(title)
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(AppColors.accent)
            Spacer()
        }
        .padding()
        .padding(.top, 8)
    }
}
