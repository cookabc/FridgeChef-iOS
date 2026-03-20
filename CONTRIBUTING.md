# Contributing to FridgeChef

Thank you for your interest in contributing to FridgeChef! We welcome contributions from the community.

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code:
- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Respect different viewpoints and experiences

## How to Contribute

### Reporting Bugs

Before creating a bug report, please check if the issue already exists. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Screenshots** if applicable
- **Device information** (iOS version, device model)
- **App version**

### Suggesting Features

Feature requests are welcome! Please provide:

- **Clear description** of the feature
- **Use case** - why would this be useful?
- **Possible implementation** approach (optional)

### Pull Requests

1. **Fork** the repository
2. **Create a branch** from `main`: `git checkout -b feature/your-feature-name`
3. **Make your changes**
4. **Test your changes** thoroughly
5. **Commit** with clear messages: `git commit -m 'Add feature: description'`
6. **Push** to your fork: `git push origin feature/your-feature-name`
7. **Open a Pull Request**

#### PR Guidelines

- Keep changes focused and atomic
- Update documentation if needed
- Ensure the app builds without warnings
- Test on both light and dark modes
- Test on different screen sizes if UI changes

## Development Setup

### Prerequisites

- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ Simulator or device

### Building

```bash
git clone https://github.com/yourusername/FridgeChef.git
cd FridgeChef
open FridgeChef.xcodeproj
```

Then build and run in Xcode.

### Project Structure

```
FridgeChef/
├── FridgeChef/              # Main app source
│   ├── Views/               # SwiftUI Views
│   ├── Components/          # Reusable UI components
│   ├── Services/            # API and data services
│   ├── Models/              # Data models
│   └── Utils/               # Utilities and extensions
├── FridgeChefTests/         # Unit tests
└── FridgeChefUITests/       # UI tests
```

## Coding Standards

### Swift Style Guide

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and small
- Use SwiftUI best practices

### Localization

All user-facing strings must be localized:

```swift
// Good
Text("home.title".localized)

// Bad
Text("Home")
```

Add new strings to both:
- `FridgeChef/en.lproj/Localizable.strings`
- `FridgeChef/zh-Hans.lproj/Localizable.strings`

### Colors and Theming

Use `AppColors` for all colors to support dark mode:

```swift
// Good
.background(AppColors.cardBackground)
.foregroundColor(AppColors.primaryText)

// Bad
.background(Color.white)
.foregroundColor(.black)
```

### UI Components

Use existing NeoPop components for consistency:

```swift
// Good
NeoPopCard { content }
NeoPopButton(title: "Save") { action }

// Avoid creating one-off custom styles
```

## Testing

### Unit Tests

Write tests for:
- Business logic
- Data transformations
- API service methods

Run tests with: `Cmd + U` in Xcode

### UI Tests

Write UI tests for:
- Critical user flows
- Navigation paths

### Manual Testing

Test your changes on:
- iPhone (various sizes)
- Both light and dark modes
- Different iOS versions if possible

## Documentation

- Update README.md if adding major features
- Add inline documentation for public APIs
- Update CHANGELOG.md with your changes

## Questions?

Feel free to open an issue for:
- Questions about the codebase
- Clarification on contributing guidelines
- Discussion of potential features

## Recognition

Contributors will be recognized in our README.md file.

Thank you for contributing to FridgeChef! 🍳
