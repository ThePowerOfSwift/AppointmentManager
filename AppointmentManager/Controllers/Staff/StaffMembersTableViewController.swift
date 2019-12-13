import UIKit
import CoreData

class StaffMembersTableViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: Fetched results controller
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<StaffMember> = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        let request = NSFetchRequest<StaffMember>(entityName: "StaffMember")
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        try! fetchedResultsController.performFetch()
        navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
}

//MARK: Data source overrides
extension StaffMembersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let staffMember = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "staffMemberCell", for: indexPath)
        cell.textLabel?.text = (staffMember.firstName ?? "") + " " + (staffMember.lastName ?? "")
        cell.detailTextLabel?.text = staffMember.position
        return cell
    }
    
}

//MARK: Table actions
extension StaffMembersTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StaffMemberDetailViewController") as! StaffMemberDetailViewController
        let navigationController = UINavigationController(rootViewController: vc)
        vc.staffMember = fetchedResultsController.object(at: indexPath)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
        
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complete) in
            let staffMemberCoreDataManager = StaffMemberCoreDataManager()
            staffMemberCoreDataManager.delete(self.fetchedResultsController.object(at: indexPath))
            staffMemberCoreDataManager.saveContext()
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
}

//MARK: Fetched results controller delegate
extension StaffMembersTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let deletedIndexPath = indexPath {
                self.tableView.deleteRows(at: [deletedIndexPath], with: .automatic)
            }
            break
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let staffMember = fetchedResultsController.object(at: indexPath)
                cell.textLabel?.text = (staffMember.firstName ?? "") + " " + (staffMember.lastName ?? "")
                cell.detailTextLabel?.text = staffMember.position
            }
            break;
        default:
            print("...")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//MARK: Search bar delegate
extension StaffMembersTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            let firstNamePredicate = NSPredicate(format: "firstName BEGINSWITH[cd] %@", searchText)
            let lastNamePredicate = NSPredicate(format: "lastName BEGINSWITH[cd] %@", searchText)
            
            let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstNamePredicate, lastNamePredicate])
            fetchedResultsController.fetchRequest.predicate = compoundPredicate
        }
        
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
        
    }
}
