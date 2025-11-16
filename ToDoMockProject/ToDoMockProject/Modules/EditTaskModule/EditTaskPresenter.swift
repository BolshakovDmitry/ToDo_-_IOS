import Foundation

final class EditTaskPresenter {
    
    // MARK: - Properties
    weak var view: EditTaskViewProtocol?
    var interactor: EditTaskInteractorInputProtocol?
    var router: EditTaskRouterProtocol?
}

// MARK: - EditTaskPresenterProtocol
extension EditTaskPresenter: EditTaskPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.loadTodo()
    }
    
    func viewWillDisappear(description: String) {
        interactor?.saveTodo(description: description)
    }
    
    func didTapBack() {
        router?.navigateBack(from: view!)
    }
}

// MARK: - EditTaskInteractorOutputProtocol
extension EditTaskPresenter: EditTaskInteractorOutputProtocol {
    
    func todoDidLoad(_ todo: ToDo) {
        view?.displayTodo(todo)
    }
}
