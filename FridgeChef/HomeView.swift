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
            Color(red: 1.0, green: 0.99, blue: 0.96) // #FFFDF5
                .ignoresSafeArea()
            
            VStack {
                // 顶部标题和设置按钮
                HStack {
                    Text("冰箱大厨")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { currentView = "settings" })
                    {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .neoPopStyle()
                            Image(systemName: "gear")
                                .font(.system(size: 20))
                        }
                    }
                }
                .padding()
                
                // Bento Grid 布局
                Grid {
                    // 开始烹饪卡片（占据两列）
                    GridRow {
                        Button(action: { currentView = "input" })
                        {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(red: 0.8, green: 1.0, blue: 0.0)) // #CCFF00
                                    .frame(height: 200)
                                    .neoPopStyle(backgroundColor: Color(red: 0.8, green: 1.0, blue: 0.0))
                                VStack {
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 60))
                                        .padding(.bottom, 16)
                                    Text("开始烹饪")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("输入冰箱食材，获取 AI 食谱")
                                        .font(.subheadline)
                                        .padding(.top, 8)
                                }
                            }
                        }
                        .gridCellColumns(2)
                        .padding(.horizontal, 4)
                    }
                    
                    // 历史食谱卡片
                    if !recipes.isEmpty {
                        // 第一行
                        GridRow {
                            ForEach(recipes.prefix(2)) { recipe in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 100)
                                        Text("📷")
                                            .font(.system(size: 30))
                                    }
                                    .padding(.bottom, 12)
                                    Text(recipe.name ?? "未知菜名")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(recipe.cookTime ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(16)
                                .neoPopStyle()
                                .padding(4)
                            }
                        }
                        
                        // 第二行
                        if recipes.count > 2 {
                            GridRow {
                                ForEach(recipes.dropFirst(2).prefix(2)) { recipe in
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 100)
                                            Text("📷")
                                                .font(.system(size: 30))
                                        }
                                        .padding(.bottom, 12)
                                        Text(recipe.name ?? "未知菜名")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Text(recipe.cookTime ?? "")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(16)
                                    .neoPopStyle()
                                    .padding(4)
                                }
                            }
                        }
                    } else {
                        // 空状态提示
                        GridRow {
                            VStack {
                                Image(systemName: "clipboard")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 16)
                                Text("还没有历史食谱")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("开始烹饪，生成你的第一份食谱吧！")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                            }
                            .padding()
                            .gridCellColumns(2)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentView: .constant("home"))
    }
}