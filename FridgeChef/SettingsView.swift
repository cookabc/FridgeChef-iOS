import SwiftUI

struct SettingsView: View {
    @State private var baseURL: String = UserDefaults.standard.string(forKey: "API_BASE_URL") ?? "https://api-inference.modelscope.cn/v1"
    @State private var model: String = UserDefaults.standard.string(forKey: "API_MODEL") ?? "MiniMax/MiniMax-M2.5"
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "API_KEY") ?? ""
    @State private var showSuccessMessage: Bool = false
    
    @Binding var currentView: String
    
    var body: some View {
        ZStack {
            Color(red: 0.10, green: 0.14, blue: 0.49)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部返回按钮和标题
                HStack {
                    Button(action: { currentView = "home" })
                    {
                        ZStack {
                            RoundedRectangle(cornerRadius: 9999)
                                .fill(Color.black)
                                .offset(x: 6, y: 6)
                            RoundedRectangle(cornerRadius: 9999)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9999)
                                        .stroke(Color.black, lineWidth: 4)
                                )
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .frame(width: 48, height: 48)
                    }
                    VStack(alignment: .leading) {
                        Text("API 配置")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Text("配置你的 AI 服务")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
                    }
                    Spacer()
                }
                .padding()
                .padding(.top, 8)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 配置表单卡片
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.black)
                                .offset(x: 6, y: 6)
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.black, lineWidth: 4)
                                )
                            
                            VStack(alignment: .leading, spacing: 24) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Base URL")
                                        .font(.headline)
                                        .fontWeight(.black)
                                        .foregroundColor(.black)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(Color.black)
                                            .offset(x: 6, y: 6)
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(Color.black, lineWidth: 3)
                                            )
                                        TextField("https://api-inference.modelscope.cn/v1", text: $baseURL)
                                            .padding()
                                    }
                                    .frame(height: 48)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Model")
                                        .font(.headline)
                                        .fontWeight(.black)
                                        .foregroundColor(.black)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(Color.black)
                                            .offset(x: 6, y: 6)
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(Color.black, lineWidth: 3)
                                            )
                                        TextField("MiniMax/MiniMax-M2.5", text: $model)
                                            .padding()
                                    }
                                    .frame(height: 48)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("API Key")
                                        .font(.headline)
                                        .fontWeight(.black)
                                        .foregroundColor(.black)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(Color.black)
                                            .offset(x: 6, y: 6)
                                        RoundedRectangle(cornerRadius: 9999)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(Color.black, lineWidth: 3)
                                            )
                                        TextField("输入 API Key", text: $apiKey)
                                            .padding()
                                    }
                                    .frame(height: 48)
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
                                    .fill(Color.black)
                                    .offset(x: 6, y: 6)
                                RoundedRectangle(cornerRadius: 9999)
                                    .fill(Color(red: 0.8, green: 1.0, blue: 0.0))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9999)
                                            .stroke(Color.black, lineWidth: 4)
                                    )
                                Text("保存配置")
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
                                    .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
                                Text("配置保存成功！")
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
