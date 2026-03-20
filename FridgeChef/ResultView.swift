import SwiftUI
import CoreData

struct ResultView: View {
    let recipe: RecipeModel
    @Binding var currentView: String
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSaved: Bool = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
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
                                Image(systemName: "house")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.primaryText)
                            }
                            .frame(width: 48, height: 48)
                        }
                        Text("result.title".localized)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(AppColors.accent)
                        Spacer()
                    }
                    .padding()
                    .padding(.top, 8)
                    
                    // 食谱标题卡片
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
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 16) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.shadow)
                                        .frame(width: 80, height: 80)
                                    Text("🍳")
                                        .font(.system(size: 40))
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.dishName)
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    HStack(spacing: 8) {
                                        Text("result.difficulty.easy".localized)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppColors.accent)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background(Color.black)
                                            .cornerRadius(9999)
                                        
                                        Text("result.time.minutes".localized(with: 15))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .background(Color.white)
                                            .cornerRadius(9999)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 9999)
                                                    .stroke(AppColors.primaryText, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    // 食材列表卡片
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
                            Text("result.ingredients".localized)
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 12) {
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(AppColors.accent)
                                                .frame(width: 24, height: 24)
                                                .overlay(
                                                    Circle()
                                                        .stroke(AppColors.primaryText, lineWidth: 2)
                                                )
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                        
                                        Text(ingredient)
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppColors.primaryText)
                                        
                                        Spacer()
                                        
                                        Text("result.ingredients.you.have".localized)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppColors.accent)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    // 制作步骤卡片
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
                            Text("result.steps".localized)
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 16) {
                                ForEach(recipe.steps.indices, id: \.self) { index in
                                    HStack(alignment: .top, spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(AppColors.shadow)
                                                .frame(width: 40, height: 40)
                                            Text("\(index + 1)")
                                                .font(.title3)
                                                .fontWeight(.black)
                                                .foregroundColor(AppColors.accent)
                                        }
                                        
                                        Text(recipe.steps[index])
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .foregroundColor(AppColors.primaryText)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    // 操作按钮
                    HStack(spacing: 16) {
                        // 重新生成按钮
                        Button(action: {
                            // 重新生成
                        }) {
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
                                Text("result.regenerate".localized)
                                    .font(.title3)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                            }
                            .frame(height: 56)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // 保存按钮
                        Button(action: {
                            saveRecipe()
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
                                Text(isSaved ? "result.saved".localized : "result.save".localized)
                                    .font(.title3)
                                    .fontWeight(.black)
                                    .foregroundColor(AppColors.primaryText)
                            }
                            .frame(height: 56)
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(isSaved)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }
    
    private func saveRecipe() {
        let newRecipe = RecipeEntity(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = recipe.dishName
        newRecipe.difficulty = "result.difficulty.medium".localized
        newRecipe.timestamp = Date()
        newRecipe.colorIndex = Int16(Int.random(in: 0..<5))
        newRecipe.cookTime = "result.time.minutes".localized(with: 20)
        newRecipe.desc = recipe.steps.joined(separator: "\n")
        
        do {
            try viewContext.save()
            isSaved = true
            // 保存成功后返回首页
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                currentView = "home"
            }
        } catch {
            let nsError = error as NSError
            print("Error saving recipe: \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        let mockRecipe = RecipeModel(
            dishName: "番茄鸡蛋炒饭",
            ingredients: ["鸡蛋 2个", "番茄 1个", "米饭 1碗", "葱花 适量", "盐 适量"],
            steps: [
                "鸡蛋打散，加入少许盐搅拌均匀。番茄洗净切小块备用。",
                "热锅凉油，倒入蛋液快速炒散，盛出备用。",
                "锅中再加少许油，放入番茄块炒出汁水。",
                "倒入米饭翻炒均匀，再加入炒好的鸡蛋。",
                "加盐调味，撒上葱花即可出锅。"
            ]
        )
        
        ResultView(recipe: mockRecipe, currentView: .constant("result"))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
