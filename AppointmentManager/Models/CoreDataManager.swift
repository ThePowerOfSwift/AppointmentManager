import CoreData
import UIKit

class CoreDataManager {
    
     lazy var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveContext() {
        managedObjectContext.perform {
            if self.managedObjectContext.hasChanges {
                do {
                    print(self.managedObjectContext)
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                    fatalError("Error while saving core data managed context: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func delete(_ object: NSManagedObject)  {
        managedObjectContext.perform {
            self.managedObjectContext.delete(object)
        }
    }
    
}
