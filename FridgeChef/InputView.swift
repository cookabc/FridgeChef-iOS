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
                    VStack(alignment: .leading) {
                        Text("input.title".localized)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(AppColors.primaryText)
                        Text("input.subtitle".localized)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.accent)
                    }
                    Spacer()
                }
                .padding()
                .padding(.top, 8)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 食材输入框卡片
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
                            
                            VStack(alignment: .leading) {
                                Text("input.fridge.question".localized)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 8)
                                    .foregroundColor(AppColors.primaryText)
                                
                                // 输入框
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9999)
                                        .fill(AppColors.shadow)
                                        .offset(x: 4, y: 4)
                                    RoundedRectangle(cornerRadius: 9999)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 9999)
                                                .stroke(AppColors.primaryText, lineWidth: 3)
                                        )
                                    TextField("input.placeholder".localized, text: $customIngredients)
                                        .padding()
                                }
                                .frame(height: 48)
                                .padding(.bottom, 8)
                                
                                Text("input.example".localized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                            .padding()
                        }
                        .padding(.horizontal, 16)
                        
                        // 常用食材标签卡片
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
                            
                            VStack(alignment: .leading) {
                                Text("input.quick.select".localized)
                                    .font(.headline)
                                    .fontWeight(.black)
                                    .padding(.bottom, 12)
                                    .foregroundColor(AppColors.primaryText)
                                
                                let emojis = ["🥚", "🍅", "🧅", "🫑", "🥩", "🍗", "🍚", "🍜"]
                                let ingredientsWithEmojis = Array(zip(ingredientKeys, emojis))
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(ingredientsWithEmojis, id: \.0) {
                                        ingredientKey, emoji in
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
                                                    .fill(selectedIngredients.contains(ingredientKey) ? AppColors.accent : Color.white)
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
                            .padding()
                        }
                        .padding(.horizontal, 16)
                        
                        // 已选择食材预览
                        if !selectedIngredients.isEmpty {
                            let emojis = ["🥚", "🍅", "🧅", "🫑", "🥩", "🍗", "🍚", "🍜"]
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(AppColors.shadow)
                                    .offset(x: 6, y: 6)
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(AppColors.accent)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(AppColors.primaryText, lineWidth: 4)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text("input.selected".localized)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 8)
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
                                                    .background(Color.black)
                                                    .cornerRadius(9999)
                                            }
                                        }
                                    }
                                }
                                .padding()
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
                        Button(action: { 
                            generateRecipe()
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
                                if isLoading {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Text("input.generate".localized)
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(AppColors.primaryText)
                                }
                            }
                            .frame(height: 64)
                        }
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
