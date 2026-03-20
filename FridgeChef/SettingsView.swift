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
                HStack {
                    Button(action: { currentView = "home" })
                    {
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
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .frame(width: 48, height: 48)
                    }
                    Text("settings.title".localized)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(AppColors.accent)
                    Spacer()
                }
                .padding()
                .padding(.top, 8)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 语言设置卡片
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.shadow)
                                .offset(x: 6, y: 6)
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(AppColors.primaryText, lineWidth: 4)
                                )
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("settings.language".localized)
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Picker("settings.language".localized, selection: $settings.language) {
                                    ForEach(AppLanguage.allCases) { language in
                                        Text(language.displayName)
                                            .tag(language)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding()
                        }
                        .padding(.horizontal, 16)
                        
                        // 主题设置卡片
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.shadow)
                                .offset(x: 6, y: 6)
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(AppColors.primaryText, lineWidth: 4)
                                )
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("settings.theme".localized)
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Picker("settings.theme".localized, selection: $settings.theme) {
                                    ForEach(AppTheme.allCases) { theme in
                                        Text(theme.displayName)
                                            .tag(theme)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding()
                        }
                        .padding(.horizontal, 16)
                        
                        // API 配置卡片
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.shadow)
                                .offset(x: 6, y: 6)
                            RoundedRectangle(cornerRadius: 24)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(AppColors.primaryText, lineWidth: 4)
                                )
                            
                            VStack(alignment: .leading, spacing: 24) {
                                Text("API")
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("settings.base.url".localized)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(AppColors.shadow)
                                            .offset(x: 6, y: 6)
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(AppColors.primaryText, lineWidth: 3)
                                            )
                                        TextField("settings.placeholder.url".localized, text: $baseURL)
                                            .padding()
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    .frame(height: 48)
                                    .contentShape(Rectangle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("settings.model".localized)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(AppColors.shadow)
                                            .offset(x: 6, y: 6)
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(AppColors.primaryText, lineWidth: 3)
                                            )
                                        TextField("settings.placeholder.model".localized, text: $model)
                                            .padding()
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    .frame(height: 48)
                                    .contentShape(Rectangle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("settings.api.key".localized)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(AppColors.shadow)
                                            .offset(x: 6, y: 6)
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(AppColors.primaryText, lineWidth: 3)
                                            )
                                        SecureField("settings.placeholder.key".localized, text: $apiKey)
                                            .padding()
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    .frame(height: 48)
                                    .contentShape(Rectangle())
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal, 16)
                        
                        // 保存按钮
                        Button(action: {
                            UserDefaults.standard.set(baseURL, forKey: "API_BASE_URL")
                            UserDefaults.standard.set(model, forKey: "API_MODEL")
                            UserDefaults.standard.set(apiKey, forKey: "API_KEY")
                            
                            showSuccessMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessMessage = false
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 9999)
                                    .fill(AppColors.shadow)
                                    .offset(x: 6, y: 6)
                                RoundedRectangle(cornerRadius: 9999)
                                    .fill(AppColors.accent)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9999)
                                            .stroke(AppColors.primaryText, lineWidth: 4)
                                    )
                                Text("settings.save".localized)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
                            }
                            .frame(height: 64)
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
                                    .foregroundColor(AppColors.primaryText)
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
