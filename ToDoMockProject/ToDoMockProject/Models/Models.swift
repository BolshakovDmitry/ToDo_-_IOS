import Foundation

struct ToDoResponse: Codable {
    let todos: [ToDo]
}

struct ToDo: Codable {
    let id: Int
    let description: String
    let completed: Bool
    let userID: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description = "todo"
        case completed
        case userID = "userId"
    }
}
