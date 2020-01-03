import UIKit
import CoreData

class DayViewController: UIViewController {
    
    var selectedDate = Date()
    var dates = [Date]()
    var staffMembers = [StaffMember]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayLabel: UILabel!
    
    lazy var staffMembersFetchRequest: NSFetchRequest<StaffMember> = {
        let fetchRequest: NSFetchRequest<StaffMember> = StaffMember.fetchRequest()
        
        let weekday = Calendar.current.component(.weekday, from: selectedDate)
        fetchRequest.predicate = NSPredicate(format: "ANY workingDays.day = %d ", weekday)
        
        return fetchRequest
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.dates = DayUtils.generateIntervals(for: selectedDate)
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        moc.performAndWait {
            self.staffMembers = (try! self.staffMembersFetchRequest.execute())
        }
        
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dayLabel.text = dateFormatter.string(from: selectedDate)
    }

    
}

extension DayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as? DayTableViewCell else {
            return UITableViewCell()
        }
        let date = dates[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.hourLabel.text = dateFormatter.string(from: date)
        let filtered = staffMembers.filter { (staffMember) -> Bool in
            let dateInterval = DayUtils.generateDateInterval(staffMember: staffMember, date: selectedDate)
            return dateInterval.contains(date)
        }
        cell.staffMembers = filtered
        return cell
    }
    
}

extension DayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
            self.makeContextMenu(for: indexPath )
        }
    }
}

extension DayViewController {
    
    func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        // Create a UIAction for sharing
        let share = UIAction(title: "Create appointment", image: UIImage(systemName: "plus.circle")) { action in
            if let cell = self.tableView.cellForRow(at: indexPath) as? DayTableViewCell {
                if cell.staffMembers.isEmpty {
                    let alert = UIAlertController(title: "Warning", message: "There is no staff member assigned to this slot", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { _ in
                        self.performSegue(withIdentifier: "PresentNewAppointmentSegue", sender: self)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "PresentNewAppointmentSegue", sender: self)
                }
            }
        }
        
        // Create and return a UIMenu with the share action
        return UIMenu(title: "", children: [share])
        
    }
    
    
}
