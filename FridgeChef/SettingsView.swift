import SwiftUI

struct SettingsView: View {
    @State private var baseURL: String = UserDefaults.standard.string(forKey: "API_BASE_URL") ?? "https://api-inference.modelscope.cn/v1"
    @State private var model: String = UserDefaults.standard.string(forKey: "API_MODEL") ?? "MiniMax/MiniMax-M2.5"
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "API_KEY") ?? ""
    @State private var showSuccessMessage: Bool = false
    
    @Binding var currentView: String
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.99, blue: 0.96) // #FFFDF5
                .ignoresSafeArea()
            
            VStack {
                // 顶部返回按钮和标题
                HStack {
                    Button(action: { currentView = "home" })
                    {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .neoPopStyle()
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                        }
                    }
                    Text("API 配置")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                // 配置表单
                VStack(alignment: .leading) {
                    Text("Base URL")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    TextField("https://api-inference.modelscope.cn/v1", text: $baseURL)
                        .textFieldStyle(.neoPop)
                        .padding(.bottom, 24)
                    
                    Text("Model")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    TextField("MiniMax/MiniMax-M2.5", text: $model)
                        .textFieldStyle(.neoPop)
                        .padding(.bottom, 24)
                    
                    Text("API Key")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    TextField("输入 API Key", text: $apiKey)
                        .textFieldStyle(.neoPop)
                        .padding(.bottom, 32)
                    
                    // 保存按钮
                    Button(action: {
                        // 保存配置到 UserDefaults
                        UserDefaults.standard.set(baseURL, forKey: "API_BASE_URL")
                        UserDefaults.standard.set(model, forKey: "API_MODEL")
                        UserDefaults.standard.set(apiKey, forKey: "API_KEY")
                        
                        // 显示成功消息
                        showSuccessMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessMessage = false
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.8, green: 1.0, blue: 0.0)) // #CCFF00
                                .frame(height: 60)
                                .neoPopStyle(backgroundColor: Color(red: 0.8, green: 1.0, blue: 0.0))
                            Text("保存配置")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // 成功消息
                    if showSuccessMessage {
                        Text("配置保存成功！")
                            .foregroundColor(.green)
                            .font(.headline)
                            .padding(.top, 16)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
                
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