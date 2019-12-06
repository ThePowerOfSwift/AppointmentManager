import UIKit
import CoreData

class ServiceListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    var services: [Service] {
        get {
            if let serviceSet = staffMember?.services {
                return serviceSet.allObjects as! [Service]
            } else {
                return [Service]()
            }
        }
    }
    
    var staffMember: StaffMember? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddServiceSegue" {
            let destinationVC = segue.destination as! AddServiceViewController
            destinationVC.staffMember = self.staffMember
            destinationVC.delegate = self
        }
    }
}

//MARK: NSFetchedResultsControllerDelegate methods
extension ServiceListViewController: NSFetchedResultsControllerDelegate {
    
}

//MARK: Table view data source methods
extension ServiceListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell")!
        cell.textLabel?.text = services[indexPath.row].name
        cell.detailTextLabel?.text = (Locale.current.currencyCode ?? "") + " " + String(services[indexPath.row].price)
        return cell
    }
    
}

extension ServiceListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        tableView.isEditing ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complete) in
            let serviceCoreDataManager = ServiceCoreDataManager()
            serviceCoreDataManager.delete(self.services[indexPath.row])
            serviceCoreDataManager.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
//MARK: Staff Member detail delegate
extension ServiceListViewController: StaffMemberDetailDelegate {
    
    //Used to set editing when the staff member detail vc sets editing
    func didSetEditing(_ editing: Bool) {
        tableView.setEditing(editing, animated: true)
    }
    
}

extension ServiceListViewController: AddServiceDelegate {
    
    func didAddService() {
        tableView.reloadData()
    }
    
}

