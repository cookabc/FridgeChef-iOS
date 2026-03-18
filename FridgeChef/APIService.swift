import Foundation

struct RecipeModel: Codable {
    let dishName: String
    let ingredients: [String]
    let steps: [String]
}

@MainActor
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
    
    func generateRecipe(ingredients: [String], completion: @escaping (Result<RecipeModel, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
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
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                // 解析 API 响应
                let apiResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // 提取 message content
                if let apiResponse = apiResponse,
                   let choices = apiResponse["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    
                    // 解析 JSON 内容
                    let recipeData = content.data(using: .utf8)
                    DispatchQueue.main.async {
                        do {
                            let recipe = try JSONDecoder().decode(RecipeModel.self, from: recipeData!)
                            completion(.success(recipe))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Invalid API response", code: 0, userInfo: nil)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}