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
    
    @IBAction func addServiceButtonTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select an option", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Create new", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "AddServiceModalSegue", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Import existing", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "UseExistingServiceSegue", sender: self)
        }))
        
        actionSheet.modalPresentationStyle = .popover
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = sender.frame
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddServiceModalSegue" {
            let destinationVC = segue.destination as! AddServiceViewController
            destinationVC.staffMember = self.staffMember
            destinationVC.delegate = self
        }
        
        if segue.identifier == "UseExistingServiceSegue" {
            let destinationVC = segue.destination as! UseExistingServiceViewController
            destinationVC.staffMember = self.staffMember
            destinationVC.delegate = self
        }
    }
}

//MARK: Table view data source methods
extension ServiceListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count > 0 ? services.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell")!
        if services.count > 0 {
            cell.textLabel?.text = services[indexPath.row].name
            cell.detailTextLabel?.text = (Locale.current.currencyCode ?? "") + " " + String(services[indexPath.row].price)
        } else {
            cell.textLabel?.text = "No services added"
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
}

extension ServiceListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        tableView.isEditing ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complete) in
            self.staffMember?.removeFromServices(self.services[indexPath.row])
            try! self.staffMember?.managedObjectContext?.save()
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

extension ServiceListViewController: UseExistingServiceDelegate {
    
    func didSelectServices() {
        tableView.reloadData()
    }
}

