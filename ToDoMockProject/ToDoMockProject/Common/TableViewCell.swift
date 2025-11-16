import UIKit

final class TableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let completionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        ), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        ), for: .selected)
        button.tintColor = UIColor(white: 0.3, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var onCompletionToggle: (() -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .black
        selectionStyle = .none
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(completionButton)
        contentView.addSubview(textStackView)
        
        completionButton.addTarget(self, action: #selector(completionTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            completionButton.widthAnchor.constraint(equalToConstant: 32),
            completionButton.heightAnchor.constraint(equalToConstant: 32),
            
            textStackView.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // Разделитель
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.15, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    @objc private func completionTapped() {
        onCompletionToggle?()
    }
    
    // MARK: - Configure
    func configure(with todo: ToDo, onToggle: @escaping () -> Void) {
        titleLabel.text = todo.title  // "Задача #1"
        descriptionLabel.text = todo.description
        
        // Форматируем дату
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        dateLabel.text = formatter.string(from: todo.createdAt)
        
        // Настраиваем completed состояние
        completionButton.isSelected = todo.completed
        
        if todo.completed {
            // Желтая галочка для выполненных
            completionButton.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
            
            // Зачеркнутый серый текст
            titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
            titleLabel.attributedText = NSAttributedString(
                string: todo.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: UIColor(white: 0.4, alpha: 1)
                ]
            )
            
            descriptionLabel.textColor = UIColor(white: 0.35, alpha: 1)
        } else {
            // Серый круг для невыполненных
            completionButton.tintColor = UIColor(white: 0.3, alpha: 1)
            
            // Обычный текст (БЕЗ зачеркивания)
            titleLabel.textColor = .white
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
            
            descriptionLabel.textColor = UIColor(white: 0.6, alpha: 1)
            descriptionLabel.attributedText = nil
            descriptionLabel.text = todo.description
        }
        
        onCompletionToggle = onToggle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.attributedText = nil
        descriptionLabel.text = nil
        descriptionLabel.attributedText = nil
        dateLabel.text = nil
        completionButton.isSelected = false
        onCompletionToggle = nil
    }
}
