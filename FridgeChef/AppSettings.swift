import Foundation
import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case chinese = "zh-Hans"
    case english = "en"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system:
            return "settings.language.system".localized
        case .chinese:
            return "settings.language.chinese".localized
        case .english:
            return "settings.language.english".localized
        }
    }
    
    var localeIdentifier: String? {
        switch self {
        case .system:
            return nil
        case .chinese:
            return "zh-Hans"
        case .english:
            return "en"
        }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .system:
            return "settings.theme.system".localized
        case .light:
            return "settings.theme.light".localized
        case .dark:
            return "settings.theme.dark".localized
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "app_language")
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    @Published var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: "app_theme")
        }
    }
    
    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "app_language") ?? "system"
        self.language = AppLanguage(rawValue: savedLanguage) ?? .system
        
        let savedTheme = UserDefaults.standard.string(forKey: "app_theme") ?? "system"
        self.theme = AppTheme(rawValue: savedTheme) ?? .system
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
