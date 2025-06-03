import UIKit

class TaskDumpViewController: UIViewController {
    var delegate: AddTaskDelegate?
    
    private let titleLabel: UILabel = {
        let result = UILabel()
        result.text = "Task Name"
        result.font = .systemFont(ofSize: 17, weight: .bold)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private let titleTextField: UITextField = {
        let result = UITextField()
        result.borderStyle = .roundedRect
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        
        setupTitleTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    @objc private func saveButtonTapped() {
        if let taskTitle = titleTextField.text, !taskTitle.isEmpty {
            delegate?.addTask(title: taskTitle)
            dismiss(animated: true)
        }
    }
    
    private func setupTitleTextField() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            titleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
    }
    
    private func setupDetailsTextField() {
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            titleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
    }
}
