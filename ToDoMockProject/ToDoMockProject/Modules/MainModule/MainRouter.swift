import UIKit

final class MainRouter {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
}

// MARK: - MainRouterProtocol
extension MainRouter: MainRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let router = MainRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
    func navigateToEditTask(todo: ToDo?, onSave: @escaping (String) -> Void) {
        guard let viewController = viewController else { return }
        
        let editVC = EditTaskRouter.createModule(todo: todo, onSave: onSave)
        viewController.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func showShareSheet(from view: MainViewProtocol, text: String) {
        guard let viewController = viewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
}
