import CoreData
import UIKit

class CoreDataManager {
    
     lazy var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error while saving core data managed context: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject)  {
        managedObjectContext.delete(object)
        saveContext()
    }
    
}
