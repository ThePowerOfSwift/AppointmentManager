import UIKit

protocol StaffMemberDetailDelegate {
    
    func didSetEditing(_ editing: Bool)
    
}

class StaffMemberDetailViewController: UIViewController {
    
    @IBOutlet weak var scheduleStackView: UIStackView!
    @IBOutlet var dayScheduleStackViews: [DayScheduleStackView]!
    var dayScheduleLabels = [UIStackView]()
    
    let staffCoreDataManager = StaffMemberCoreDataManager()
    let workingDayManager = WorkingDayCoreDataManager()
    
    var delegate: StaffMemberDetailDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = (staffMember == nil)
        if staffMember != nil {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
    }
    
    var staffMember: StaffMember? {
        didSet {
            refreshUi()
        }
    }
    
    private func refreshUi() {
        loadViewIfNeeded()
        dayScheduleLabels.forEach({$0.removeFromSuperview()})
        generateScheduleStackView()
        title = (staffMember?.firstName ?? "") + " " + (staffMember?.lastName ?? "")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        delegate?.didSetEditing(editing)
        for dayScheduleStackView in dayScheduleStackViews {
            UIView.animate(withDuration: 0.3) {
                dayScheduleStackView.isHidden = !editing
            }
        }
        
        for dayScheduleLabel in dayScheduleLabels {
            UIView.animate(withDuration: 0.3) {
                dayScheduleLabel.isHidden = editing
            }
        }
        
        if editing {
            if let workingDays = staffMember?.workingDays as? Set<WorkingDay> {
                for workingDay in workingDays {
                    let view = dayScheduleStackViews.first(where: {$0.selectedDay == Day(rawValue: workingDay.day ?? "Monday")})
                    view?.configureView(startingDate: workingDay.startingHour ?? Date(), endingDate: workingDay.endingHour ?? Date())
                }
            }
        } else {
            updateStaffMember()
            refreshUi()
        }
    }
    
    func updateStaffMember() {
        
        guard let staffToEdit = staffMember else { return }
        staffCoreDataManager.deleteAllWorkingDays(from: staffToEdit)
        staffToEdit.addToWorkingDays(workingDayManager.createWorkingDays(from: dayScheduleStackViews.filter({$0.workingDaySwitch.isOn})))
        staffCoreDataManager.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    
    func generateScheduleStackView() {
        
        guard let workingDaysArray = staffMember?.workingDays?.allObjects as? [WorkingDay] else { return }
        
        
        for workingDay in workingDaysArray.sorted(by: { (firstDay, secondDay) -> Bool in
            let allDays = Day.allCases.map({$0.rawValue})
            return allDays.firstIndex(of: firstDay.day!) ?? 7 < allDays.firstIndex(of: secondDay.day!) ?? 7
        }) {
            let horizontalStackView = DayScheduleReadOnlyView()
            horizontalStackView.workingDay = workingDay
            scheduleStackView.addArrangedSubview(horizontalStackView)
            dayScheduleLabels.append(horizontalStackView)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServiceListViewControllerEmbedSegue" {
            let destinationVc = segue.destination as! ServiceListViewController
            destinationVc.staffMember = self.staffMember
            self.delegate = destinationVc
        }
    }
    
    
}
