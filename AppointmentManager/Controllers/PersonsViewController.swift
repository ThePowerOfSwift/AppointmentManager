import UIKit
import CoreData

class PersonsViewController: UIViewController {
    
    @IBOutlet weak var personsTableView: UITableView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<StaffMember> = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<StaffMember>(entityName: "StaffMember")
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personsTableView.dataSource = self
        personsTableView.delegate = self
        
        personsTableView.register(UINib(nibName: "StaffMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "staffMemberCell")
        try! fetchedResultsController.performFetch()
    }
    
}

//MARK: UITableViewDataSource methods
extension PersonsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let staffMember = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "staffMemberCell", for: indexPath) as! StaffMemberTableViewCell
        cell.configureCell(for: staffMember)
       
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let doctor = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = doctor.firstName! + " "  + doctor.lastName!
    }
    
}

//MARK: UITableView Delegate Methods
extension PersonsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            return self.makeContextMenu(staffMember: self.fetchedResultsController.object(at: indexPath))
        }
    }
}

//MARK: Context menus
extension PersonsViewController {
    
    func makeContextMenu(staffMember: StaffMember) -> UIMenu {
        
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
            let editVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddDoctorVC") as! AddStaffMemberViewController
            let navController = UINavigationController(rootViewController: editVc)
            self.present(navController, animated: true) {
                editVc.staffMember = staffMember
            }
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            managedObjectContext.delete(staffMember)
            try! managedObjectContext.save()
        }
        
        return UIMenu(title: "", children: [edit, delete])
    }
}

//MARK: NSFetchedResultsControllerDelegate methods
extension PersonsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                self.personsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let deletedIndexPath = indexPath {
                self.personsTableView.deleteRows(at: [deletedIndexPath], with: .automatic)
            }
            break
        case .update:
            if let indexPath = indexPath, let cell = personsTableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break;
        default:
            print("...")
        }
    }
}

