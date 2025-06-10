import UIKit

class SwipingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var viewControllers: [UIViewController] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Get Task Done"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(taskDumpButtonTapped))

        let home = HomeViewController()
        let inProgress = UIViewController()
        let done = UIViewController()

        viewControllers = [home, inProgress, done]
        
    }
    
    @objc func taskDumpButtonTapped() {
        let taskDumpViewController = TaskDumpViewController()
        taskDumpViewController.delegate = self
        let taskDumkpNavController = UINavigationController(rootViewController: taskDumpViewController)
        navigationController?.present(taskDumkpNavController, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
                return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else { return nil }
                return viewControllers[index + 1]
    }
}

extension SwipingViewController: AddTaskDelegate {
    func addTask(title: String, dueDate: Date?) {
        let newTask = ToDo(context: CoreDataManager.shared.viewContext)
        newTask.title = title
        newTask.dueDate = dueDate
        CoreDataManager.shared.saveContext()
    }
}
 
