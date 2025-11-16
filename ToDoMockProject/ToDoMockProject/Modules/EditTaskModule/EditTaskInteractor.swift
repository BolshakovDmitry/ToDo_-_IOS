import Foundation

final class EditTaskInteractor {
    
    // MARK: - Properties
    weak var presenter: EditTaskInteractorOutputProtocol?
    
    private let todo: ToDo?
    private let onSave: (String) -> Void
    
    // MARK: - Init
    init(todo: ToDo?, onSave: @escaping (String) -> Void) {
        self.todo = todo
        self.onSave = onSave
    }
}

// MARK: - EditTaskInteractorInputProtocol
extension EditTaskInteractor: EditTaskInteractorInputProtocol {
    
    func loadTodo() {
        if let todo = todo {
            presenter?.todoDidLoad(todo)
        } else {
            // Новая задача
            let newTodo = ToDo(
                id: 0,
                description: "",
                completed: false,
                userID: 1,
                createdAt: Date()
            )
            presenter?.todoDidLoad(newTodo)
        }
    }
    
    func saveTodo(description: String) {
        onSave(description)
    }
}
