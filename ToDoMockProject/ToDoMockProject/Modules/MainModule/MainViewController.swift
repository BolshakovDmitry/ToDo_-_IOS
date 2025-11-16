import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: MainPresenterProtocol?
    
    // MARK: - UI Elements
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Search"
        search.searchBarStyle = .minimal
        search.barStyle = .black
        
        search.searchTextField.backgroundColor = UIColor(white: 0.15, alpha: 1)
        search.searchTextField.textColor = .white
        search.searchTextField.leftView?.tintColor = UIColor(white: 0.5, alpha: 1)
        search.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor(white: 0.5, alpha: 1)]
        )
        
        let micButton = UIButton(type: .system)
        micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        micButton.tintColor = UIColor(white: 0.5, alpha: 1)
        micButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        search.searchTextField.rightView = micButton
        search.searchTextField.rightViewMode = .always
        
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        table.separatorStyle = .none
        table.backgroundColor = .black
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.08, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        ), for: .normal)
        button.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        button.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter?.viewDidLoad() // стартовая точка
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        bottomBar.addSubview(taskCountLabel)
        bottomBar.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 85),
            
            taskCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskCountLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -10),
            
            addButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -40),
            addButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let largeTitleFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 41
        paragraphStyle.maximumLineHeight = 41
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: UIColor.white,
            .kern: 0.4,
            .paragraphStyle: paragraphStyle
        ]
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.backgroundColor = .black
    }
    
    // MARK: - Actions
    @objc private func addTaskTapped() {
        presenter?.didTapAddButton()
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
    
  
      func reloadCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func insertCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates {
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func deleteCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateTaskCount(_ count: Int) {
        taskCountLabel.text = count.todosDeclension()
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfTodos() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableViewCell",
            for: indexPath
        ) as? TableViewCell else {
            return UITableViewCell()
        }
        
        guard let todo = presenter?.todo(at: indexPath.row) else {
            return cell
        }
        
        cell.configure(with: todo) { [weak self] in
            print(todo.completed)
            self?.presenter?.didToggleCompletion(at: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectTodo(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                self?.presenter?.didSelectTodo(at: indexPath.row)
            }
            
            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                self?.presenter?.didTapShare(at: indexPath.row)
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self?.presenter?.didDeleteTodo(at: indexPath.row)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didSearchWithText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter?.didSearchWithText("")
    }
}
