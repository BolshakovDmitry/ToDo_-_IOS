import Foundation

struct ToDoResponse: Codable {
    let todos: [ToDo]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ToDo: Codable {
    let id: Int
    let description: String
    let completed: Bool
    let userID: Int
    let createdAt: Date
    
    // Вычисляемое свойство для заголовка
    var title: String {
        return "Задача #\(id)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description = "todo"
        case completed
        case userID = "userId"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        completed = try container.decode(Bool.self, forKey: .completed)
        userID = try container.decode(Int.self, forKey: .userID)
        createdAt = Date()
    }
    
    init(id: Int, description: String, completed: Bool, userID: Int, createdAt: Date = Date()) {
        self.id = id
        self.description = description
        self.completed = completed
        self.userID = userID
        self.createdAt = createdAt
    }
}
