import SwiftUI

struct SettingsView: View {
    @State private var baseURL: String = UserDefaults.standard.string(forKey: "API_BASE_URL") ?? "https://api-inference.modelscope.cn/v1"
    @State private var model: String = UserDefaults.standard.string(forKey: "API_MODEL") ?? "MiniMax/MiniMax-M2.5"
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "API_KEY") ?? ""
    @State private var showSuccessMessage: Bool = false
    
    @Binding var currentView: String
    @ObservedObject private var settings = AppSettings.shared
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部返回按钮和标题
                NeoPopPageHeader(title: "settings.title".localized) {
                    currentView = "home"
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 语言设置卡片
                        NeoPopCard {
                            NeoPopSegmentedControl(
                                title: "settings.language".localized,
                                selection: $settings.language,
                                options: AppLanguage.allCases,
                                displayName: { $0.displayName }
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // 主题设置卡片
                        NeoPopCard {
                            NeoPopSegmentedControl(
                                title: "settings.theme".localized,
                                selection: $settings.theme,
                                options: AppTheme.allCases,
                                displayName: { $0.displayName }
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        // API 配置卡片
                        NeoPopCard {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("API")
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                                
                                NeoPopInputField(
                                    title: "settings.base.url".localized,
                                    placeholder: "settings.placeholder.url".localized,
                                    text: $baseURL
                                )
                                
                                NeoPopInputField(
                                    title: "settings.model".localized,
                                    placeholder: "settings.placeholder.model".localized,
                                    text: $model
                                )
                                
                                NeoPopInputField(
                                    title: "settings.api.key".localized,
                                    placeholder: "settings.placeholder.key".localized,
                                    text: $apiKey,
                                    isSecure: true
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // 保存按钮
                        NeoPopButton(title: "settings.save".localized) {
                            UserDefaults.standard.set(baseURL, forKey: "API_BASE_URL")
                            UserDefaults.standard.set(model, forKey: "API_MODEL")
                            UserDefaults.standard.set(apiKey, forKey: "API_KEY")
                            
                            showSuccessMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessMessage = false
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // 成功消息
                        if showSuccessMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(AppColors.accent)
                                Text("settings.save.success".localized)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.top, 16)
                }
                
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(currentView: .constant("settings"))
    }
}
