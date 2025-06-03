import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func deleteToDo(item: ToDo) {
        viewContext.delete(item)
        saveContext()
    }
    
    func fetchToDos() -> [ToDo] {
        let fetchRequest: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error)")
        }
    }
    
}
