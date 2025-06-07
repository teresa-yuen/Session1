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

    private let dueDateLabel: UILabel = {
        let result = UILabel()
        result.text = "Due Date"
        result.font = .systemFont(ofSize: 17, weight: .bold)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    private let dueDatePicker: UIDatePicker = {
        let result = UIDatePicker()
        result.datePickerMode = .dateAndTime
        result.preferredDatePickerStyle = .compact
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private let noDueDateButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle("No Due Date", for: .normal)
        result.addTarget(self, action: #selector(noDueDateButtonTapped), for: .touchUpInside)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    private let dueDateStackView: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.alignment = .center
        result.distribution = .fill
        result.spacing = 8
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        
        setupTitleTextField()
        setupDueDatePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    @objc private func saveButtonTapped() {
        if let taskTitle = titleTextField.text, !taskTitle.isEmpty {
            let dueDate = dueDatePicker.date == Date.distantPast ? nil : dueDatePicker.date
            delegate?.addTask(title: taskTitle, dueDate: dueDate)
            dismiss(animated: true)
        }
    }
    
    @objc func noDueDateButtonTapped() {
        dueDatePicker.date = Date.distantPast
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
    
    private func setupDueDatePicker() {
        dueDateStackView.addArrangedSubview(noDueDateButton)
        dueDateStackView.addArrangedSubview(dueDatePicker)
        view.addSubview(dueDateLabel)
        view.addSubview(dueDateStackView)

         NSLayoutConstraint.activate([
             dueDateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
             dueDateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
             dueDateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

             dueDateStackView.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 8),
             dueDateStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
             dueDateStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)

         ])
     }
    
}
