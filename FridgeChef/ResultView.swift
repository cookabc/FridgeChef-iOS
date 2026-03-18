import SwiftUI
import CoreData

struct ResultView: View {
    let recipe: RecipeModel
    @Binding var currentView: String
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSaved: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.99, blue: 0.96) // #FFFDF5
                .ignoresSafeArea()
            
            ScrollView {
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
                        Text("食谱结果")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    
                    // 食谱卡片
                    VStack(alignment: .leading) {
                        // 菜名
                        Text(recipe.dishName)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 16)
                        
                        // 食材列表
                        Text("食材")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        ForEach(recipe.ingredients, id: \.self) {
                            ingredient in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(ingredient)
                                    .font(.body)
                            }
                            .padding(.bottom, 4)
                        }
                        
                        // 制作步骤
                        Text("制作步骤")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                        ForEach(recipe.steps.indices, id: \.self) {
                            index in
                            VStack(alignment: .leading) {
                                Text("步骤 \(index + 1)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(recipe.steps[index])
                                    .font(.body)
                                    .padding(.bottom, 12)
                            }
                        }
                    }
                    .padding()
                    .neoPopStyle()
                    .padding()
                    
                    // 保存按钮
                    Button(action: {
                        saveRecipe()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.8, green: 1.0, blue: 0.0)) // #CCFF00
                                .frame(height: 60)
                                .neoPopStyle(backgroundColor: Color(red: 0.8, green: 1.0, blue: 0.0))
                            Text(isSaved ? "已保存" : "保存食谱")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
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
            dishName: "番茄炒蛋",
            ingredients: ["番茄", "鸡蛋", "葱花", "盐", "糖"],
            steps: ["1. 番茄切块", "2. 鸡蛋打散", "3. 热锅倒油", "4. 炒鸡蛋", "5. 加入番茄翻炒", "6. 调味出锅"]
        )
        
        ResultView(recipe: mockRecipe, currentView: .constant("result"))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}