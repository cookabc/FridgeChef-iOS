import SwiftUI
import CoreData

struct RecipeDetailView: View {
    let recipeId: UUID
    @Binding var currentView: String
    var previousView: String = "allRecipes"
    @Environment(\.managedObjectContext) private var viewContext
    @State private var recipe: RecipeEntity? = nil
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部导航栏
                HStack {
                    Button(action: {
                        withAnimation(.spring()) {
                            // 返回到上一页
                            currentView = previousView
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                            Text("common.back".localized)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(AppColors.accent)
                    }
                    
                    Spacer()
                    
                    Text(recipe?.name ?? "Recipe")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // 占位，保持居中
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .opacity(0)
                        Text("common.back".localized)
                            .font(.headline)
                            .opacity(0)
                    }
                }
                .padding()
                .padding(.top, 8)
                
                // 内容
                if let recipe = recipe {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Recipe Header
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
                                
                                VStack(spacing: 16) {
                                    Text(recipe.name ?? "Unknown Recipe")
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(.black)
                                    
                                    HStack(spacing: 12) {
                                        if let difficulty = recipe.difficulty {
                                            Text(difficulty)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(AppColors.accent)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 6)
                                                .background(Color.black)
                                                .cornerRadius(9999)
                                        }
                                        if let cookTime = recipe.cookTime {
                                            Text(cookTime)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 6)
                                                .background(Color.white)
                                                .cornerRadius(9999)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 9999)
                                                        .stroke(Color.black, lineWidth: 2)
                                                )
                                        }
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal, 16)
                            
                            // Description - Steps
                            if let desc = recipe.desc, !desc.isEmpty {
                                let steps = parseSteps(from: desc)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    // Section Title
                                    HStack {
                                        Text("👨‍🍳")
                                            .font(.title2)
                                        Text("result.steps".localized)
                                            .font(.title2)
                                            .fontWeight(.black)
                                            .foregroundColor(AppColors.accent)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    // Steps List
                                    VStack(spacing: 12) {
                                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                                            StepCard(stepNumber: index + 1, stepText: step)
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 20)
                    }
                } else {
                    Spacer()
                    
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.secondaryText)
                            .padding(.bottom, 16)
                        Text("Recipe not found")
                            .font(.headline)
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            loadRecipe()
        }
    }
    
    private func loadRecipe() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipeId as CVarArg)
        request.fetchLimit = 1
        
        do {
            let results = try viewContext.fetch(request)
            recipe = results.first
        } catch {
            print("Error fetching recipe: \(error)")
        }
    }
    
    private func parseSteps(from desc: String) -> [String] {
        // Split by common step separators (numbers, newlines, etc.)
        let separators = CharacterSet(charactersIn: "\n")
        var steps = desc.components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        // Remove step number prefixes like "1.", "2.", "Step 1:", etc.
        steps = steps.map { step in
            var cleaned = step
            // Remove leading numbers with dots or Chinese numbers
            let patterns = [
                "^\\d+\\.\\s*",
                "^第[一二三四五六七八九十\\d]+步[：:]\\s*",
                "^Step\\s*\\d+[：:]\\s*"
            ]
            for pattern in patterns {
                if let range = cleaned.range(of: pattern, options: .regularExpression) {
                    cleaned.removeSubrange(range)
                }
            }
            return cleaned.trimmingCharacters(in: .whitespaces)
        }
        
        return steps.isEmpty ? [desc] : steps
    }
}

// MARK: - Step Card
struct StepCard: View {
    let stepNumber: Int
    let stepText: String
    
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.shadow)
                .offset(x: 4, y: 4)
            
            // Content layer
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.primaryText, lineWidth: 3)
                )
            
            HStack(alignment: .top, spacing: 12) {
                // Step number badge
                ZStack {
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(AppColors.primaryText, lineWidth: 2)
                        )
                    Text("\(stepNumber)")
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.black)
                }
                
                // Step text
                Text(stepText)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryText)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(16)
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(recipeId: UUID(), currentView: .constant("recipeDetail"))
    }
}
