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
            Color(red: 0.10, green: 0.14, blue: 0.49)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部返回按钮和标题
                HStack {
                    Button(action: { currentView = "home" })
                    {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 48, height: 48)
                            .background(Color.white)
                            .cornerRadius(9999)
                            .overlay(
                                RoundedRectangle(cornerRadius: 9999)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                            .shadow(color: Color.black, radius: 0, x: 6, y: 6)
                    }
                    VStack(alignment: .leading) {
                        Text("输入食材")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Text("告诉 AI 你有什么")
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
                        // 食材输入框
                        VStack(alignment: .leading) {
                            Text("冰箱里有什么？")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                                .foregroundColor(.black)
                            
                            TextField("输入食材，用逗号分隔...", text: $customIngredients)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(9999)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 9999)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                                .shadow(color: Color.black, radius: 0, x: 6, y: 6)
                                .padding(.bottom, 8)
                            
                            Text("例如：鸡蛋, 番茄, 洋葱, 青椒")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black, lineWidth: 4)
                        )
                        .shadow(color: Color.black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 16)
                        
                        // 常用食材标签
                        VStack(alignment: .leading) {
                            Text("快速选择")
                                .font(.headline)
                                .fontWeight(.black)
                                .padding(.bottom, 12)
                                .foregroundColor(.black)
                            
                            let emojis = ["🥚", "🍅", "🧅", "🫑", "🥩", "🍗", "🍚", "🍜"]
                            let ingredientsWithEmojis = Array(zip(commonIngredients, emojis))
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(ingredientsWithEmojis, id: \.0) {
                                    ingredient, emoji in
                                    Button(action: {
                                        if selectedIngredients.contains(ingredient) {
                                            selectedIngredients.remove(ingredient)
                                        } else {
                                            selectedIngredients.insert(ingredient)
                                        }
                                    }) {
                                        Text("\(emoji) \(ingredient)")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedIngredients.contains(ingredient) ? Color(red: 0.8, green: 1.0, blue: 0.0) : Color.white)
                                            .cornerRadius(9999)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(Color.black, lineWidth: 2)
                                            )
                                            .shadow(color: Color.black, radius: 0, x: 2, y: 2)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.black, lineWidth: 4)
                        )
                        .shadow(color: Color.black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 16)
                        
                        // 已选择食材预览
                        if !selectedIngredients.isEmpty {
                            let emojis = ["🥚", "🍅", "🧅", "🫑", "🥩", "🍗", "🍚", "🍜"]
                            
                            VStack(alignment: .leading) {
                                Text("已选择:")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 8)
                                    .foregroundColor(.black)
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                                    ForEach(Array(selectedIngredients), id: \.self) { ingredient in
                                        if let index = commonIngredients.firstIndex(of: ingredient), index < emojis.count {
                                            Text("\(emojis[index]) \(ingredient)")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.black)
                                                .cornerRadius(9999)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(red: 0.8, green: 1.0, blue: 0.0))
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                            .shadow(color: Color.black, radius: 0, x: 6, y: 6)
                            .padding(.horizontal, 16)
                        }
                        
                        // 错误信息
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // 生成食谱按钮
                        Button(action: { 
                            generateRecipe()
                        }) {
                            if isLoading {
                                ProgressView()
                                    .tint(.black)
                            } else {
                                Text("✨ 生成食谱")
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(height: 64)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.8, green: 1.0, blue: 0.0))
                        .cornerRadius(9999)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9999)
                                .stroke(Color.black, lineWidth: 4)
                        )
                        .shadow(color: Color.black, radius: 0, x: 6, y: 6)
                        .padding(.horizontal, 16)
                        .disabled(isLoading)
                    }
                    .padding(.top, 16)
                }
                
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
