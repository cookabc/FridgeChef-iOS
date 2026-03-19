import SwiftUI
import CoreData

struct HomeView: View {
    @Binding var currentView: String
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.timestamp, ascending: false)],
        animation: .default
    ) private var recipes: FetchedResults<RecipeEntity>
    
    var body: some View {
        ZStack {
            Color.deepRoyalBlue
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部标题和设置按钮
                HStack {
                    VStack(alignment: .leading) {
                        Text("冰箱大厨")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Text("FridgeChef")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.acidGreen)
                    }
                    Spacer()
                    Button(action: { currentView = "settings" })
                    {
                        ZStack {
                            Image(systemName: "gearshape.2")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .frame(width: 48, height: 48)
                        .neoPopStyle(backgroundColor: .white, cornerRadius: 9999)
                    }
                }
                .padding()
                .padding(.top, 8)
                
                // 开始烹饪卡片
                Button(action: { currentView = "input" })
                {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.acidGreen)
                            .frame(height: 180)
                            .neoPopStyle(backgroundColor: .acidGreen, cornerRadius: 24)
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("今天吃什么？")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("开始烹饪")
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(.black)
                                Text("输入冰箱里的食材，AI 帮你生成食谱")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black.opacity(0.8))
                            }
                            .padding()
                            .flexibleFrame()
                            
                            // 加号按钮
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                                    .foregroundColor(.acidGreen)
                            }
                            .padding()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                // 统计数据
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .frame(height: 100)
                            .neoPopStyle(backgroundColor: .white, cornerRadius: 24)
                        VStack {
                            Text("已生成食谱")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text("\(recipes.count)")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.black)
                        }
                    }
                    .flexibleFrame()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .frame(height: 100)
                            .neoPopStyle(backgroundColor: .white, cornerRadius: 24)
                        VStack {
                            Text("节省食材")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text("8")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.black)
                        }
                    }
                    .flexibleFrame()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                // 历史记录标题
                HStack {
                    Text("历史记录")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {})
                    {
                        Text("查看全部")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.acidGreen)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                // 历史食谱卡片
                if !recipes.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(recipes) { recipe in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.white)
                                        .frame(height: 120)
                                        .neoPopStyle(backgroundColor: .white, cornerRadius: 24)
                                    HStack(spacing: 16) {
                                        // 食谱图标
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(getIconColor(for: recipe))
                                                .frame(width: 80, height: 80)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.black, lineWidth: 3)
                                                )
                                            Text(getFoodEmoji(for: recipe))
                                                .font(.system(size: 32))
                                        }
                                        
                                        // 食谱信息
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(recipe.name ?? "未知菜名")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Text(recipe.desc ?? "")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                            HStack(spacing: 8) {
                                                if let difficulty = recipe.difficulty {
                                                    Text(difficulty)
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.black)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 4)
                                                        .background(Color.acidGreen)
                                                        .cornerRadius(9999)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 9999)
                                                                .stroke(Color.black, lineWidth: 2)
                                                        )
                                                }
                                                if let cookTime = recipe.cookTime {
                                                    Text(cookTime)
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
                                        .flexibleFrame()
                                        
                                        // 箭头
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                } else {
                    // 空状态提示
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white)
                            .frame(height: 200)
                            .neoPopStyle(backgroundColor: .white, cornerRadius: 24)
                        VStack {
                            Image(systemName: "clipboard")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .padding(.bottom, 16)
                            Text("还没有历史食谱")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("开始烹饪，生成你的第一份食谱吧！")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                
                Spacer()
            }
        }
    }
    
    // 获取食谱图标颜色
    private func getIconColor(for recipe: RecipeEntity) -> Color {
        let colors: [Color] = [
            .init(red: 0.9, green: 0.4, blue: 0.6), // 粉色
            .init(red: 0.4, green: 0.7, blue: 0.5), // 绿色
            .init(red: 0.9, green: 0.6, blue: 0.3), // 橙色
            .init(red: 0.5, green: 0.6, blue: 0.9), // 蓝色
            .init(red: 0.7, green: 0.4, blue: 0.8)  // 紫色
        ]
        let index = Int(recipe.id?.hashValue ?? 0) % colors.count
        return colors[abs(index)]
    }
    
    // 获取食物表情
    private func getFoodEmoji(for recipe: RecipeEntity) -> String {
        let emojis = ["🍅", "🥘", "🍜", "🍳", "🥗", "🍝", "🍲", "🍛"]
        let index = Int(recipe.id?.hashValue ?? 0) % emojis.count
        return emojis[abs(index)]
    }
}

// MARK: - View Extensions
private extension View {
    func flexibleFrame() -> some View {
        self.frame(maxWidth: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentView: .constant("home"))
    }
}
