import SwiftUI
import CoreData

struct ResultView: View {
    let recipe: RecipeModel
    @Binding var currentView: String
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSaved: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 0.10, green: 0.14, blue: 0.49)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // 顶部返回按钮和标题
                    HStack {
                        Button(action: { currentView = "home" })
                        {
                            Image(systemName: "house")
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
                            Text("食谱详情")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                            Text("AI 为你生成的食谱")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
                        }
                        Spacer()
                    }
                    .padding()
                    .padding(.top, 8)
                    
                    // 食谱标题卡片
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black)
                                    .frame(width: 80, height: 80)
                                Text("🍳")
                                    .font(.system(size: 40))
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recipe.dishName)
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 8) {
                                    Text("简单")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.black)
                                        .cornerRadius(9999)
                                    
                                    Text("15 分钟")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.white)
                                        .cornerRadius(9999)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 9999)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
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
                    .padding(.bottom, 16)
                    
                    // 食材列表卡片
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🥬 所需食材")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.8, green: 1.0, blue: 0.0))
                                            .frame(width: 24, height: 24)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 2)
                                            )
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text(ingredient)
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("✓ 你有")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
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
                    .padding(.bottom, 16)
                    
                    // 制作步骤卡片
                    VStack(alignment: .leading, spacing: 16) {
                        Text("👨‍🍳 制作步骤")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.black)
                        
                        VStack(spacing: 16) {
                            ForEach(recipe.steps.indices, id: \.self) { index in
                                HStack(alignment: .top, spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: 40, height: 40)
                                        Text("\(index + 1)")
                                            .font(.title3)
                                            .fontWeight(.black)
                                            .foregroundColor(Color(red: 0.8, green: 1.0, blue: 0.0))
                                    }
                                    
                                    Text(recipe.steps[index])
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
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
                    .padding(.bottom, 16)
                    
                    // 操作按钮
                    HStack(spacing: 16) {
                        // 重新生成按钮
                        Button(action: {
                            // 重新生成
                        }) {
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
                                Text("🔄 重新生成")
                                    .font(.title3)
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
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
                                    .fill(Color.black)
                                    .offset(x: 6, y: 6)
                                RoundedRectangle(cornerRadius: 9999)
                                    .fill(Color(red: 0.8, green: 1.0, blue: 0.0))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9999)
                                            .stroke(Color.black, lineWidth: 4)
                                    )
                                Text(isSaved ? "✅ 已保存" : "💾 保存食谱")
                                    .font(.title3)
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
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
        newRecipe.difficulty = "中等"
        newRecipe.timestamp = Date()
        newRecipe.colorIndex = Int16(Int.random(in: 0..<5))
        newRecipe.cookTime = "20分钟"
        newRecipe.desc = recipe.steps.joined(separator: "\n")
        
        do {
            try viewContext.save()
            isSaved = true
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
