import UIKit

// MARK: - View Protocol
protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol? { get set }
    
    func reloadData()
    func reloadCell(at index: Int)
    func insertCell(at index: Int)
    func deleteCell(at index: Int)
    func showError(_ error: String)
    func updateTaskCount(_ count: Int)
}

// MARK: - Presenter Protocol
protocol MainPresenterProtocol: AnyObject {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorInputProtocol? { get set }
    var router: MainRouterProtocol? { get set }
    
    func viewDidLoad() //
    func numberOfTodos() -> Int
    func todo(at index: Int) -> ToDo?
    
    func didSelectTodo(at index: Int)
    func didTapAddButton()
    func didToggleCompletion(at index: Int)
    func didDeleteTodo(at index: Int)
    func didSearchWithText(_ text: String)
    func didTapShare(at index: Int)
}

// MARK: - Interactor Input Protocol
protocol MainInteractorInputProtocol: AnyObject {
    var presenter: MainInteractorOutputProtocol? { get set }
    
    func loadTodos()
    func numberOfTodos() -> Int
    func todo(at index: Int) -> ToDo?
    
    func toggleCompletion(at index: Int)
    func deleteTodo(at index: Int)
    func addTodo(description: String)
    func updateTodo(todoId: Int, description: String)
    
    func searchTodos(with text: String)
    func clearSearch()
}

// MARK: - Interactor Output Protocol
protocol MainInteractorOutputProtocol: AnyObject {
    func todosDidLoad()
    func todosDidUpdate()
    func todosDidFail(with error: Error)
    
    func todoDidUpdate(at index: Int)
    func todoDidInsert(at index: Int)
    func todoDidDelete(at index: Int)
}

// MARK: - Router Protocol
protocol MainRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    
    func navigateToEditTask(todo: ToDo?, onSave: @escaping (String) -> Void)
    func showShareSheet(from view: MainViewProtocol, text: String)
}
