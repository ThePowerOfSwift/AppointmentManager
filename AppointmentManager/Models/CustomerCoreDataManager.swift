import CoreData

class CustomerCoreDataManager: CoreDataManager {
    
    func createCustomer(firstName: String, lastName: String, phoneNumber: String, privacy: Data?) {
        managedObjectContext.perform {
            let customer = Customer(context: self.managedObjectContext)
            customer.firstName = firstName
            customer.lastName = lastName
            customer.phoneNumber = phoneNumber
            customer.privacyPolicy = privacy
            try? self.managedObjectContext.save()
        }
    }
}
