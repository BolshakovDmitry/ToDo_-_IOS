import UIKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
        let todoService = ToDoService()
        todoService.fetchToDoes()
    }
    
}
