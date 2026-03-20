import SwiftUI

struct InputView: View {
    let commonIngredients = ["ingredient.egg", "ingredient.tomato", "ingredient.onion", "ingredient.pepper", "ingredient.pork", "ingredient.chicken", "ingredient.rice", "ingredient.noodle"]
    let ingredientKeys = ["ingredient.egg", "ingredient.tomato", "ingredient.onion", "ingredient.pepper", "ingredient.pork", "ingredient.chicken", "ingredient.rice", "ingredient.noodle"]
    @State private var selectedIngredients: Set<String> = []
    @State private var customIngredients: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @Binding var currentView: String
    @Binding var generatedRecipe: RecipeModel?
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部返回按钮和标题
                NeoPopPageHeader(title: "input.title".localized) {
                    currentView = "home"
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 食材输入框卡片
                        NeoPopCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("input.fridge.question".localized)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.primaryText)
                                
                                NeoPopInputField(
                                    title: "",
                                    placeholder: "input.placeholder".localized,
                                    text: $customIngredients
                                )
                                
                                Text("input.example".localized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // 常用食材标签卡片
                        NeoPopCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("input.quick.select".localized)
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                                
                                let emojis = ["🥚", "🍅", "🧅", "🫑", "🥩", "🍗", "🍚", "🍜"]
                                let ingredientsWithEmojis = Array(zip(ingredientKeys, emojis))
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(ingredientsWithEmojis, id: \.0) { ingredientKey, emoji in
                                        Button(action: {
                                            if selectedIngredients.contains(ingredientKey) {
                                                selectedIngredients.remove(ingredientKey)
                                            } else {
                                                selectedIngredients.insert(ingredientKey)
                                            }
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .fill(AppColors.shadow)
                                                    .offset(x: 2, y: 2)
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .fill(selectedIngredients.contains(ingredientKey) ? AppColors.accent : AppColors.cardBackground)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 9999)
                                                            .stroke(AppColors.primaryText, lineWidth: 2)
                                                    )
                                                Text("\(emoji) \(ingredientKey.localized)")
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(AppColors.primaryText)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // 已选择食材预览
                        if !selectedIngredients.isEmpty {
                            let emojis = ["🥚", "🍅", "🧅", "🫑", "🥩", "🍗", "🍚", "🍜"]
                            
                            NeoPopCard(backgroundColor: AppColors.accent) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("input.selected".localized)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                                        ForEach(Array(selectedIngredients), id: \.self) { ingredientKey in
                                            if let index = ingredientKeys.firstIndex(of: ingredientKey), index < emojis.count {
                                                Text("\(emojis[index]) \(ingredientKey.localized)")
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(AppColors.accent)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(AppColors.primaryText)
                                                    .cornerRadius(9999)
                                            }
                                        }
                                    }
                                }
                            }
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
                        NeoPopButton(
                            title: "input.generate".localized,
                            isLoading: isLoading
                        ) {
                            generateRecipe()
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 16)
                }
                
                Spacer()
            }
        }
    }
    
    private func generateRecipe() {
        // 收集所有食材
        var allIngredients: [String] = Array(selectedIngredients).map { $0.localized }

        // 处理自定义输入的食材
        if !customIngredients.isEmpty {
            let customItems = customIngredients.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            allIngredients.append(contentsOf: customItems)
        }

        // 检查是否有食材
        if allIngredients.isEmpty {
            errorMessage = "input.error.empty".localized
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
                errorMessage = "input.error.failed".localized
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
