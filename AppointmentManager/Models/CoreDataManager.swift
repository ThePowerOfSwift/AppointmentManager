import CoreData
import UIKit

class CoreDataManager {
    
     lazy var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                print(managedObjectContext)
                try managedObjectContext.save()
            } catch {
                print(error)
                fatalError("Error while saving core data managed context: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject)  {
        managedObjectContext.delete(object)
        saveContext()
    }
    
}
