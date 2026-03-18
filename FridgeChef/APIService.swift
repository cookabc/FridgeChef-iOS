import Foundation

struct RecipeModel: Codable {
    let dishName: String
    let ingredients: [String]
    let steps: [String]
}

class APIService {
    private let baseURL: String
    private let model: String
    private let apiKey: String

    init(
        baseURL: String? = nil,
        model: String? = nil,
        apiKey: String? = nil
    ) {
        // 优先级：传入的值 > UserDefaults > 默认值
        self.baseURL = baseURL ?? UserDefaults.standard.string(forKey: "API_BASE_URL") ?? "https://api-inference.modelscope.cn/v1"
        self.model = model ?? UserDefaults.standard.string(forKey: "API_MODEL") ?? "MiniMax/MiniMax-M2.5"
        self.apiKey = apiKey ?? UserDefaults.standard.string(forKey: "API_KEY") ?? ""
    }

    // 便捷初始化方法，只传入 API Key
    convenience init(apiKey: String) {
        self.init(baseURL: nil, model: nil, apiKey: apiKey)
    }

    // 便捷初始化方法，使用默认配置（从 UserDefaults 读取）
    convenience init() {
        self.init(baseURL: nil, model: nil, apiKey: nil)
    }

    func generateRecipe(ingredients: [String]) async throws -> RecipeModel {
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

        let ingredientsString = ingredients.joined(separator: "、")

        let systemPrompt = "你是一个专业的厨师，根据用户提供的食材，生成一个详细的食谱。请严格按照以下 JSON 格式返回，不要包含任何其他文字：\n{\"dishName\": \"菜名\", \"ingredients\": [\"食材1\", \"食材2\", ...], \"steps\": [\"步骤1\", \"步骤2\", ...]}"

        let userPrompt = "请使用以下食材生成一个食谱：\(ingredientsString)"

        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.7
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])

        let (data, _) = try await URLSession.shared.data(for: request)

        // 解析 API 响应
        guard let apiResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let choices = apiResponse["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw NSError(domain: "Invalid API response", code: 0, userInfo: nil)
        }

        // 解析 JSON 内容
        guard let recipeData = content.data(using: .utf8) else {
            throw NSError(domain: "Failed to encode content to data", code: 0, userInfo: nil)
        }

        let recipe = try JSONDecoder().decode(RecipeModel.self, from: recipeData)
        return recipe
    }
}
