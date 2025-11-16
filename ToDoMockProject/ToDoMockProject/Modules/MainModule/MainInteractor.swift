import Foundation

final class MainInteractor {
    
    // MARK: - Properties
    weak var presenter: MainInteractorOutputProtocol?
    
    private var allTodos: [ToDo] = []
    private var currentSearchText: String = ""
    
    private lazy var toDoService: ToDoService = {
        return ToDoService(delegate: self)
    }()
    
    private var nextID: Int = 1000
    
    // Ыычисляемое свойство
    private var currentTodos: [ToDo] {
        if currentSearchText.isEmpty {
            return allTodos
        } else {
            return allTodos.filter { todo in
                todo.title.lowercased().contains(currentSearchText.lowercased()) ||
                todo.description.lowercased().contains(currentSearchText.lowercased())
            }
        }
    }
}

// MARK: - MainInteractorInputProtocol
extension MainInteractor: MainInteractorInputProtocol {
    
    // MARK: - Data Access
    
    func loadTodos() {
        toDoService.fetchToDoes()
    }
    
    func numberOfTodos() -> Int {
        return currentTodos.count
    }
    
    func todo(at index: Int) -> ToDo? {
        guard index < currentTodos.count else { return nil }
        return currentTodos[index]
    }
    
    // MARK: - CRUD Operations
    
 
    func toggleCompletion(at index: Int) {
        guard let todo = todo(at: index) else { return }
        
        let updatedTodo = ToDo(
            id: todo.id,
            description: todo.description,
            completed: !todo.completed,
            userID: todo.userID,
            createdAt: todo.createdAt
        )
        
        toDoService.updateToDo(updatedTodo) { [weak self] success in
            guard let self = self, success else { return }
            
            
            if let allIndex = self.allTodos.firstIndex(where: { $0.id == updatedTodo.id }) {
                self.allTodos[allIndex] = updatedTodo
            }
            
            // Находим актуал индекс в currentTodos после обновления
            if let currentIndex = self.currentTodos.firstIndex(where: { $0.id == updatedTodo.id }) {
                self.presenter?.todoDidUpdate(at: currentIndex)
            } else {
                // Если не нашли (например, отфильтровалось) - перезагружаем всё
                self.presenter?.todosDidUpdate()
            }
        }
    }
    
    func deleteTodo(at index: Int) {
        guard let todo = todo(at: index) else { return }
        
        toDoService.deleteToDo(id: todo.id) { [weak self] success in
            guard let self = self, success else { return }
  
            self.allTodos.removeAll { $0.id == todo.id }
            
            self.presenter?.todoDidDelete(at: index)
        }
    }
    
    func addTodo(description: String) {
        let newTodo = ToDo(
            id: nextID,
            description: description,
            completed: false,
            userID: 1,
            createdAt: Date()
        )
        
        nextID += 1
        
        toDoService.createToDo(newTodo) { [weak self] success in
            guard let self = self, success else { return }
            
            self.allTodos.insert(newTodo, at: 0)
            
            self.presenter?.todoDidInsert(at: 0)
        }
    }
    
    func updateTodo(todoId: Int, description: String) {
        guard let todo = allTodos.first(where: { $0.id == todoId }) else { return }
        
        let updatedTodo = ToDo(
            id: todo.id,
            description: description,
            completed: todo.completed,
            userID: todo.userID,
            createdAt: todo.createdAt
        )
        
        toDoService.updateToDo(updatedTodo) { [weak self] success in
            guard let self = self, success else { return }
            
            if let allIndex = self.allTodos.firstIndex(where: { $0.id == updatedTodo.id }) {
                self.allTodos[allIndex] = updatedTodo
            }
            self.presenter?.todosDidUpdate()
        }
    }
    
    // MARK: - Search
    
    func searchTodos(with text: String) {
        currentSearchText = text
        presenter?.todosDidUpdate()
    }
    
    func clearSearch() {
        currentSearchText = ""
        presenter?.todosDidUpdate()
    }
}

// MARK: - ToDoServiceProtocol
extension MainInteractor: ToDoServiceProtocol {
    
    func didLoadToDoes(_ todos: [ToDo]) {
        nextID = (todos.map { $0.id }.max() ?? 0) + 1 //  максимальный ID среди всех задач и установить следующий ID на 1 больше.
        allTodos = todos
        presenter?.todosDidLoad()
    }
    
    func didFailLoadToDoes(with error: Error) {
        presenter?.todosDidFail(with: error)
    }
}
