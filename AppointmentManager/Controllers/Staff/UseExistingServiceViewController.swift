import UIKit
import CoreData

protocol UseExistingServiceDelegate {
    
    func didSelectServices()
}

class UseExistingServiceViewController: UIViewController {
    
    //MARK: Fetched results controller
    lazy var fetchedResultsController: NSFetchedResultsController<Service> = {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        let fetchAllServices = NSFetchRequest<Service>(entityName: "Service")
        fetchAllServices.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchAllServices, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    //MARK: Variables
    var selectedServices = [Service]()
    var staffMember: StaffMember? = nil
    
    var delegate: UseExistingServiceDelegate?
    
    //MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        try! fetchedResultsController.performFetch()
    }
    
    //MARK: Button Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        for service in selectedServices {
            if !(staffMember?.services?.contains(service) ?? false) {
                staffMember?.addToServices(service)
            }
        }
        try! staffMember?.managedObjectContext?.save()
        dismiss(animated: true, completion: nil)
        delegate?.didSelectServices()
    }
}

//MARK: Table view delegate
extension UseExistingServiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tappedService = fetchedResultsController.object(at: indexPath)
        if selectedServices.contains(tappedService) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            selectedServices.removeAll(where: {$0 == tappedService})
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedServices.append(tappedService)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: Table view data source
extension UseExistingServiceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let serviceToDisplay = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        cell.textLabel?.text = serviceToDisplay.name
        cell.detailTextLabel?.text = (Locale.current.currencyCode ?? "") + " " + String(serviceToDisplay.price)
        
        cell.accessoryType = selectedServices.contains(serviceToDisplay) ? .checkmark : .none
        return cell
    }
}

//MARK: Search bar delegate
extension UseExistingServiceViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
    }
}


