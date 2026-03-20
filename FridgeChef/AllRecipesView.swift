import SwiftUI
import CoreData

struct AllRecipesView: View {
    @Binding var currentView: String
    @Binding var selectedRecipeId: UUID?
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.timestamp, ascending: false)],
        animation: .default
    ) private var recipes: FetchedResults<RecipeEntity>
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部返回按钮和标题
                NeoPopPageHeader(title: "home.history".localized) {
                    currentView = "home"
                }
                
                // 食谱列表
                if !recipes.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(recipes) { recipe in
                                RecipeListCard(recipe: recipe, onTap: {
                                    if let id = recipe.id {
                                        selectedRecipeId = id
                                        currentView = "recipeDetail"
                                    }
                                })
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                } else {
                    Spacer()
                    
                    NeoPopCard {
                        VStack {
                            Image(systemName: "clipboard")
                                .font(.system(size: 80))
                                .foregroundColor(AppColors.secondaryText)
                                .padding(.bottom, 20)
                            Text("home.no.recipes".localized)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.primaryText)
                            Text("home.no.recipes.prompt".localized)
                                .font(.body)
                                .foregroundColor(AppColors.secondaryText)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Recipe List Card
struct RecipeListCard: View {
    let recipe: RecipeEntity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
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
                        Text(recipe.name ?? "common.unknown".localized)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryText)
                }
                .padding()
            }
            .frame(height: 120)
        }
        .buttonStyle(PlainButtonStyle())
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

struct AllRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        AllRecipesView(currentView: .constant("allRecipes"), selectedRecipeId: .constant(nil))
    }
}
