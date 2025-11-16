import Foundation
import CoreData

@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject {
    
    @NSManaged public var id: Int64
    @NSManaged public var todoDescription: String?
    @NSManaged public var completed: Bool
    @NSManaged public var userID: Int64
    @NSManaged public var createdAt: Date?
}

// MARK: - Fetch Request
extension ToDoEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }
}

// MARK: - Mapping to Domain Model
extension ToDoEntity {
    
    func toDomain() -> ToDo {
        return ToDo(
            id: Int(id),
            description: todoDescription ?? "",
            completed: completed,
            userID: Int(userID),
            createdAt: createdAt ?? Date()
        )
    }
}
