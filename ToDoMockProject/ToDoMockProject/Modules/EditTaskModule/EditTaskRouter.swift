import UIKit

final class EditTaskRouter {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
}

// MARK: - EditTaskRouterProtocol
extension EditTaskRouter: EditTaskRouterProtocol {
    
    static func createModule(todo: ToDo?, onSave: @escaping (String) -> Void) -> UIViewController {
        let view = EditTaskViewController()
        let presenter = EditTaskPresenter()
        let interactor = EditTaskInteractor(todo: todo, onSave: onSave)
        let router = EditTaskRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateBack(from view: EditTaskViewProtocol) {
        guard let viewController = viewController else { return }
        viewController.navigationController?.popViewController(animated: true)
    }
}
