import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    public var fetchResultController: NSFetchedResultsController<ToDo>!
    private let tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task Triage"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(taskDumpButtonTapped))
        view.backgroundColor = .systemBackground
        
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultController.delegate = self
        try? fetchResultController.performFetch()
        setupTableView()
    }
    
    @objc func taskDumpButtonTapped() {
        let taskDumpViewController = TaskDumpViewController()
        taskDumpViewController.delegate = self
        let taskDumkpNavController = UINavigationController(rootViewController: taskDumpViewController)
        navigationController?.present(taskDumkpNavController, animated: true)
    }
}
// have a fetchResultController per view
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let task = fetchResultController.object(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let attributedTitle = NSMutableAttributedString(string: task.title ?? "")

        if task.isCompleted {
            let range = NSRange(location: 0, length: attributedTitle.length)
            attributedTitle.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.lightGray, range: range)
        }

        cell.textLabel?.attributedText = attributedTitle
        cell.detailTextLabel?.numberOfLines = 0
//        cell.detailTextLabel?.text = "yooo\nsfdgs\nsdfgsdg"
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        if let dueDate = task.dueDate {
            cell.detailTextLabel?.text = dateFormatter.string(for: dueDate)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toBeDeleted = fetchResultController.object(at: indexPath)
            CoreDataManager.shared.deleteToDo(item: toBeDeleted)
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedtask = fetchResultController.object(at: indexPath)
//        selectedtask.isCompleted.toggle()
//        CoreDataManager.shared.saveContext()
//    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let selectedtask = fetchResultController.object(at: indexPath)
            selectedtask.isCompleted.toggle()
            CoreDataManager.shared.saveContext()
            completionHandler(true)
        }
            completeAction.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [ completeAction])

            return configuration
        }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //everytime emit a change, update tableview
        tableview.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableview.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}

extension HomeViewController: AddTaskDelegate {
    func addTask(title: String, dueDate: Date?) {
        let newTask = ToDo(context: CoreDataManager.shared.viewContext)
        newTask.title = title
        newTask.dueDate = dueDate
        CoreDataManager.shared.saveContext()
    }
}

