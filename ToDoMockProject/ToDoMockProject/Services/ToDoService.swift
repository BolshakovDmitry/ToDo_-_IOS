import Foundation

protocol ToDoServiceProtocol: AnyObject {
    func didLoadToDoes(_ todos: [ToDo])
    func didFailLoadToDoes(with error: Error)
}

final class ToDoService {
    
    // MARK: - Properties
    private let networkClient = NetworkClient()
    private let coreDataManager = CoreDataManager.shared
    
    weak var delegate: ToDoServiceProtocol?
    
    // MARK: - Init
    
    init(delegate: ToDoServiceProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Fetch ToDos
    func fetchToDoes() {
        // Проверям CoreData
        coreDataManager.fetchAllToDos { [weak self] todos in
            if todos.isEmpty {
                // CoreData пуста - загружаем с API
                self?.loadFromAPI()
            } else {
                // Есть данные в CoreData - грузип
                self?.delegate?.didLoadToDoes(todos)
            }
        }
    }
    
    private func loadFromAPI() {
        guard let url = URL(string: Constants.url) else {
            delegate?.didFailLoadToDoes(with: NetworkErrors.networkError("Invalid URL"))
            return
        }
        
        let request = URLRequest(url: url)
        
        networkClient.fetch(type: ToDoResponse.self, urlRequest: request) { [weak self] result in
            switch result {
            case .success(let response):
                
                // Сохраняем в CoreData
                self?.coreDataManager.saveToDos(response.todos) { success in
                    if success {
                        self?.delegate?.didLoadToDoes(response.todos) // перекидываем делегату
                    }
                }
                
            case .failure(let error):
                print("Ошибка загрузки с API: \(error)")
                self?.delegate?.didFailLoadToDoes(with: error)
            }
        }
    }
    
    // MARK: - CRUD Operations
    func createToDo(_ todo: ToDo, completion: @escaping (Bool) -> Void) {
        coreDataManager.createToDo(todo, completion: completion)
    }
    
    func updateToDo(_ todo: ToDo, completion: @escaping (Bool) -> Void) {
        coreDataManager.updateToDo(todo, completion: completion)
    }
    
    func deleteToDo(id: Int, completion: @escaping (Bool) -> Void) {
        coreDataManager.deleteToDo(id: id, completion: completion)
    }
}
