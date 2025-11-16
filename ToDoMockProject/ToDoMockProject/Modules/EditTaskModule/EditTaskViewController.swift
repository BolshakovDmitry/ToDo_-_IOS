import UIKit

final class EditTaskViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: EditTaskPresenterProtocol?
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter?.viewDidLoad()
        
        descriptionTextView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let description = descriptionTextView.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if !description.isEmpty {
            presenter?.viewWillDisappear(description: description)
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 24),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem = backButton
        
        title = ""
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        presenter?.didTapBack()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - EditTaskViewProtocol
extension EditTaskViewController: EditTaskViewProtocol {
    
    func displayTodo(_ todo: ToDo) {
        titleLabel.text = todo.id == 0 ? "Новая задача" : todo.title
        descriptionTextView.text = todo.description
        placeholderLabel.isHidden = !todo.description.isEmpty
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: todo.createdAt)
    }
}

// MARK: - UITextViewDelegate
extension EditTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
