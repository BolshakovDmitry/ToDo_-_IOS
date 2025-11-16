import XCTest
@testable import ToDoMockProject

final class MainPresenterTests: XCTestCase {
    
    // MARK: - Test 1: ViewDidLoad вызывает загрузку
    func testViewDidLoad() {
        // Given
        let presenter = MainPresenter()
        let mockInteractor = MockInteractor()
        presenter.interactor = mockInteractor
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockInteractor.loadCalled)
    }
    
    // MARK: - Test 2: didTapAddButton открывает экран создания
    func testAddButton() {
        // Given
        let presenter = MainPresenter()
        let mockRouter = MockRouter()
        presenter.router = mockRouter
        
        // When
        presenter.didTapAddButton()
        
        // Then
        XCTAssertTrue(mockRouter.editCalled)
    }
}

// MARK: - Простые моки

class MockInteractor: MainInteractorInputProtocol {
    var presenter: MainInteractorOutputProtocol?
    var loadCalled = false
    
    func loadTodos() { loadCalled = true }
    func numberOfTodos() -> Int { return 0 }
    func todo(at index: Int) -> ToDo? { return nil }
    func toggleCompletion(at todoId: Int) {}
    func deleteTodo(at todoId: Int) {}
    func addTodo(description: String) {}
    func updateTodo(todoId: Int, description: String) {}
    func searchTodos(with text: String) {}
    func clearSearch() {}
}

class MockRouter: MainRouterProtocol {
    var editCalled = false
    
    static func createModule() -> UIViewController { return UIViewController() }
    func navigateToEditTask(todo: ToDo?, onSave: @escaping (String) -> Void) { editCalled = true }
    func showShareSheet(from view: MainViewProtocol, text: String) {}
}
