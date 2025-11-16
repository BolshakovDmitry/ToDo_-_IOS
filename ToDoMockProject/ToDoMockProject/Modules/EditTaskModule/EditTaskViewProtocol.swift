import Foundation
import UIKit

// MARK: - View Protocol
protocol EditTaskViewProtocol: AnyObject {
    var presenter: EditTaskPresenterProtocol? { get set }
    
    func displayTodo(_ todo: ToDo)
}

// MARK: - Presenter Protocol
protocol EditTaskPresenterProtocol: AnyObject {
    var view: EditTaskViewProtocol? { get set }
    var interactor: EditTaskInteractorInputProtocol? { get set }
    var router: EditTaskRouterProtocol? { get set }
    
    func viewDidLoad()
    func viewWillDisappear(description: String)
    func didTapBack()
}

// MARK: - Interactor Input Protocol
protocol EditTaskInteractorInputProtocol: AnyObject {
    var presenter: EditTaskInteractorOutputProtocol? { get set }
    
    func loadTodo()
    func saveTodo(description: String)
}

// MARK: - Interactor Output Protocol
protocol EditTaskInteractorOutputProtocol: AnyObject {
    func todoDidLoad(_ todo: ToDo)
}

// MARK: - Router Protocol
protocol EditTaskRouterProtocol: AnyObject {
    static func createModule(todo: ToDo?, onSave: @escaping (String) -> Void) -> UIViewController
    
    func navigateBack(from view: EditTaskViewProtocol)
}
