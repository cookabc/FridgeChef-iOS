import SwiftUI

struct InputView: View {
    let commonIngredients = ["鸡蛋", "番茄", "洋葱", "青椒", "猪肉", "鸡肉", "米饭", "面条"]
    @State private var selectedIngredients: Set<String> = []
    @State private var customIngredients: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @Binding var currentView: String
    @Binding var generatedRecipe: RecipeModel?
    
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
                    Text("输入食材")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                // 食材输入框
                VStack(alignment: .leading) {
                    Text("冰箱里有什么？")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    TextField("输入食材，用逗号分隔", text: $customIngredients)
                        .textFieldStyle(.neoPop)
                        .padding(.bottom, 24)
                }
                .padding()
                
                // 常用食材标签
                VStack(alignment: .leading) {
                    Text("常用食材")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(commonIngredients, id: \.self) {
                                ingredient in
                                Button(action: {
                                    if selectedIngredients.contains(ingredient) {
                                        selectedIngredients.remove(ingredient)
                                    } else {
                                        selectedIngredients.insert(ingredient)
                                    }
                                }) {
                                    Text(ingredient)
                                        .font(.subheadline)
                                        .neoPopTagStyle(isSelected: selectedIngredients.contains(ingredient))
                                }
                            }
                        }
                    }
                    .padding(.bottom, 32)
                }
                .padding()
                
                // 错误信息
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // 生成食谱按钮
                Button(action: { 
                    generateRecipe()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.8, green: 1.0, blue: 0.0)) // #CCFF00
                            .frame(height: 60)
                            .neoPopStyle(backgroundColor: Color(red: 0.8, green: 1.0, blue: 0.0))
                        if isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("生成食谱")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .disabled(isLoading)
                
                Spacer()
            }
        }
    }
    
    private func generateRecipe() {
        // 收集所有食材
        var allIngredients: [String] = Array(selectedIngredients)

        // 处理自定义输入的食材
        if !customIngredients.isEmpty {
            let customItems = customIngredients.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            allIngredients.append(contentsOf: customItems)
        }

        // 检查是否有食材
        if allIngredients.isEmpty {
            errorMessage = "请至少选择一种食材"
            return
        }

        // 开始加载
        isLoading = true
        errorMessage = nil

        // 调用 API 生成食谱
        let apiService = APIService()
        Task {
            do {
                let recipe = try await apiService.generateRecipe(ingredients: allIngredients)
                generatedRecipe = recipe
                currentView = "result"
            } catch {
                errorMessage = "生成食谱失败，请重试"
                print("Error generating recipe: \(error)")
            }
            isLoading = false
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(currentView: .constant("input"), generatedRecipe: .constant(nil))
    }
}