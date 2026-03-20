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
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部标题和设置按钮
                HStack {
                    Text("home.title".localized)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(AppColors.accent)
                    Spacer()
                    Button(action: { currentView = "settings" })
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
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .frame(width: 48, height: 48)
                    }
                }
                .padding()
                .padding(.top, 8)
                
                // 开始烹饪卡片
                Button(action: { currentView = "input" })
                {
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
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("home.today.what".localized)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text("home.start.cooking".localized)
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(.black)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 64, height: 64)
                                    Image(systemName: "plus")
                                        .font(.system(size: 36))
                                        .foregroundColor(AppColors.accent)
                                }
                                .padding(.leading, 16)
                            }
                            .padding(.bottom, 8)
                            
                            Text("home.input.prompt".localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black.opacity(0.9))
                        }
                        .padding(.horizontal, 36)
                    }
                    .frame(height: 180)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                // 统计数据
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
                    VStack {
                        Text("home.generated.recipes".localized)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.secondaryText)
                        Text("\(recipes.count)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                .frame(height: 100)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                
                // 历史记录标题
                HStack {
                    Text("home.history".localized)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(AppColors.accent)
                    Spacer()
                    Button(action: {
                        print("View all tapped")
                    }) {
                        Text("home.view.all".localized)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.accent)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                
                // 历史食谱卡片
                if !recipes.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(recipes) { recipe in
                                Button(action: {
                                    print("Recipe tapped: \(recipe.name ?? "unknown")")
                                }) {
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
                                        
                                        HStack(spacing: 16) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(getIconColor(for: recipe))
                                                    .frame(width: 80, height: 80)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(AppColors.primaryText, lineWidth: 3)
                                                    )
                                                Text(getFoodEmoji(for: recipe))
                                                    .font(.system(size: 32))
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(recipe.name ?? "未知菜名")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(AppColors.primaryText)
                                                Text(recipe.desc ?? "")
                                                    .font(.subheadline)
                                                    .foregroundColor(AppColors.secondaryText)
                                                    .lineLimit(1)
                                                HStack(spacing: 8) {
                                                    if let difficulty = recipe.difficulty {
                                                        Text(difficulty)
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.black)
                                                            .padding(.horizontal, 12)
                                                            .padding(.vertical, 4)
                                                            .background(AppColors.accent)
                                                            .cornerRadius(9999)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 9999)
                                                                    .stroke(AppColors.primaryText, lineWidth: 2)
                                                            )
                                                    }
                                                    if let cookTime = recipe.cookTime {
                                                        Text(cookTime)
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(AppColors.primaryText)
                                                            .padding(.horizontal, 12)
                                                            .padding(.vertical, 4)
                                                            .background(AppColors.cardBackground)
                                                            .cornerRadius(9999)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 9999)
                                                                    .stroke(AppColors.primaryText, lineWidth: 2)
                                                            )
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 20))
                                                .foregroundColor(AppColors.primaryText)
                                        }
                                        .padding()
                                    }
                                    .frame(height: 120)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                } else {
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
                        
                        VStack {
                            Image(systemName: "clipboard")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.secondaryText)
                                .padding(.bottom, 16)
                            Text("home.no.recipes".localized)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.primaryText)
                            Text("home.no.recipes.prompt".localized)
                                .font(.subheadline)
                                .foregroundColor(AppColors.secondaryText)
                                .padding(.top, 8)
                        }
                    }
                    .frame(height: 200)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                
                Spacer()
            }
        }
    }
    
    private func getIconColor(for recipe: RecipeEntity) -> Color {
        let colors: [Color] = [
            .init(red: 0.9, green: 0.4, blue: 0.6),
            .init(red: 0.4, green: 0.7, blue: 0.5),
            .init(red: 0.9, green: 0.6, blue: 0.3),
            .init(red: 0.5, green: 0.6, blue: 0.9),
            .init(red: 0.7, green: 0.4, blue: 0.8)
        ]
        let index = Int(recipe.id?.hashValue ?? 0) % colors.count
        return colors[abs(index)]
    }
    
    private func getFoodEmoji(for recipe: RecipeEntity) -> String {
        let emojis = ["🍅", "🥘", "🍜", "🍳", "🥗", "🍝", "🍲", "🍛"]
        let index = Int(recipe.id?.hashValue ?? 0) % emojis.count
        return emojis[abs(index)]
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentView: .constant("home"))
    }
}
