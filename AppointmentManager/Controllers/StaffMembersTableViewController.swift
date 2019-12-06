import UIKit
import CoreData

class StaffMembersTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<StaffMember> = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        let request = NSFetchRequest<StaffMember>(entityName: "StaffMember")
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "StaffMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "staffMemberCell")
        searchBar.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
}

//MARK: UITableViewController overrides
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "staffMemberCell", for: indexPath) as! StaffMemberTableViewCell
        cell.configureCell(for: staffMember)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.makeContextMenu(for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StaffMemberDetailViewController") as! StaffMemberDetailViewController
        let navigationController = UINavigationController(rootViewController: vc)
        vc.staffMember = fetchedResultsController.object(at: indexPath)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
        
    }
    
}

//MARK: NSFetchedResultsControllerDelegate methods
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
                (cell as! StaffMemberTableViewCell).configureCell(for: fetchedResultsController.object(at: indexPath))
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

//MARK: Context menus
extension StaffMembersTableViewController {
    
    func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            let staffMemberManager = StaffMemberCoreDataManager()
            staffMemberManager.delete(staffMember: self.fetchedResultsController.object(at: indexPath))
            staffMemberManager.saveContext()
        }
        
        return UIMenu(title: "", children: [delete])
    }
}

extension StaffMembersTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty ?? true) {
            
            let firstAndLast = NSPredicate(format: "firstName = %@ AND lastName = %@", searchBar.text ?? "")
            let firstNamePredicate = NSPredicate(format: "firstName = %@", searchBar.text ?? "")
            let lastNamePredicate = NSPredicate(format: "lastName = %@", searchBar.text ?? "")
            
            let orPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [firstAndLast,firstNamePredicate, lastNamePredicate])
            
            fetchedResultsController.fetchRequest.predicate = orPredicate
        } else {
            fetchedResultsController.fetchRequest.predicate = nil
        }
        
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
        
    }
}
