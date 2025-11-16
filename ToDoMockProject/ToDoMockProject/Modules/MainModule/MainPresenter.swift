import Foundation

final class MainPresenter {
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorInputProtocol?
    var router: MainRouterProtocol?
}

// MARK: - MainPresenterProtocol
extension MainPresenter: MainPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.loadTodos()
    }
    
    func numberOfTodos() -> Int {
        return interactor?.numberOfTodos() ?? 0
    }
    
    func todo(at index: Int) -> ToDo? {
        return interactor?.todo(at: index)
    }
    
    func didSelectTodo(at index: Int) {
        guard let todo = interactor?.todo(at: index) else { return }
        
        router?.navigateToEditTask(todo: todo) { [weak self] description in
            self?.interactor?.updateTodo(todoId: todo.id, description: description)
        }
    }
    
    func didTapAddButton() {
        router?.navigateToEditTask(todo: nil) { [weak self] description in
            self?.interactor?.addTodo(description: description)
        }
    }
    
    func didToggleCompletion(at index: Int) {
        interactor?.toggleCompletion(at: index)
    }
    
    func didDeleteTodo(at index: Int) {
        interactor?.deleteTodo(at: index)
    }
    
    func didSearchWithText(_ text: String) {
        if text.isEmpty {
            interactor?.clearSearch()
        } else {
            interactor?.searchTodos(with: text)
        }
    }
    
    func didTapShare(at index: Int) {
        guard let todo = interactor?.todo(at: index) else { return }
        let text = "\(todo.title)\n\n\(todo.description)"
        router?.showShareSheet(from: view!, text: text)
    }
}

// MARK: - MainInteractorOutputProtocol
extension MainPresenter: MainInteractorOutputProtocol {
    
    func todosDidLoad() {
        view?.reloadData()
        view?.updateTaskCount(interactor?.numberOfTodos() ?? 0)
    }
    
    func todosDidUpdate() {
        view?.reloadData()
        view?.updateTaskCount(interactor?.numberOfTodos() ?? 0)
    }
    
    func todosDidFail(with error: Error) {
        view?.showError(error.localizedDescription)
    }
    
    func todoDidUpdate(at index: Int) {
        view?.reloadCell(at: index)
    }
    
    func todoDidInsert(at index: Int) {
        view?.insertCell(at: index)
        view?.updateTaskCount(interactor?.numberOfTodos() ?? 0)
    }
    
    func todoDidDelete(at index: Int) {
        view?.deleteCell(at: index)
        view?.updateTaskCount(interactor?.numberOfTodos() ?? 0)
    }
}
