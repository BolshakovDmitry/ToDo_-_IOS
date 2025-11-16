import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //  serial queue для всех операций
    private let queue = DispatchQueue(label: "serial!", qos: .userInitiated)
    
    private init() {}
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoApp")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("не получилось загрузить \(error.localizedDescription)")
            }
            print("успех!!!!!!!!!!!!!")
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("сохранили")
        } catch {
            print("ошибочка сохранения -  \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Operations
    
    // грузим что есть
    func fetchAllToDos(completion: @escaping ([ToDo]) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            
            do {
                let entities = try self.context.fetch(request)
                let todos = entities.map { $0.toDomain() }
                
                DispatchQueue.main.async { // тут же на главный обратно переходим
                    completion(todos)
                }
            } catch {
                print("Ошибка загрузки: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    // Create
    func createToDo(_ todo: ToDo, completion: @escaping (Bool) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let entity = ToDoEntity(context: self.context)
            entity.id = Int64(todo.id)
            entity.todoDescription = todo.description
            entity.completed = todo.completed
            entity.userID = Int64(todo.userID)
            entity.createdAt = todo.createdAt
            
            self.saveContext()
            
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    // Update
    func updateToDo(_ todo: ToDo, completion: @escaping (Bool) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", todo.id)
            
            do {
                let entities = try self.context.fetch(request)
                
                if let entity = entities.first {
                    entity.todoDescription = todo.description
                    entity.completed = todo.completed
                    entity.userID = Int64(todo.userID)
                    entity.createdAt = todo.createdAt
                    
                    self.saveContext()
                    
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("ошибка оьбновления: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    // Delete
    func deleteToDo(id: Int, completion: @escaping (Bool) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let entities = try self.context.fetch(request)
                
                if let entity = entities.first {
                    self.context.delete(entity)
                    self.saveContext()
                    
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("ошибка удаления: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    // для первой загрузки с API
    func saveToDos(_ todos: [ToDo], completion: @escaping (Bool) -> Void) {
        queue.async { [weak self] in // уходим на фоновый поток и не ловим никакой выгоды из за скаканря по контексту
            guard let self = self else { return }
            
            // Удаляем все старые записи
            let deleteRequest: NSFetchRequest<NSFetchRequestResult> = ToDoEntity.fetchRequest()
            let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
            
            do {
                try self.context.execute(batchDelete)
                
                // Создаем новые записи
                for todo in todos {
                    let entity = ToDoEntity(context: self.context)
                    entity.id = Int64(todo.id)
                    entity.todoDescription = todo.description
                    entity.completed = todo.completed
                    entity.userID = Int64(todo.userID)
                    entity.createdAt = todo.createdAt
                }
                
                self.saveContext()
                
                DispatchQueue.main.async { // на главный
                    completion(true)
                }
            } catch {
                print("не удалось сохранить: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
