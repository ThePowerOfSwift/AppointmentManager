import UIKit

protocol StaffMemberDetailDelegate {
    
    func didSetEditing(_ editing: Bool)
    
}

class StaffMemberDetailViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var scheduleStackView: UIStackView!
    @IBOutlet var dayScheduleStackViews: [DayScheduleStackView]!
    
    //MARK: Variables
    var dayScheduleLabels = [UIStackView]()
    let staffCoreDataManager = StaffMemberCoreDataManager()
    let workingDayManager = WorkingDayCoreDataManager()
    var delegate: StaffMemberDetailDelegate?
    
    var staffMember: StaffMember? {
        didSet {
            refreshUi()
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = (staffMember == nil)
        if staffMember != nil {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
    }
        
    private func refreshUi() {
        loadViewIfNeeded()
        dayScheduleLabels.forEach({$0.removeFromSuperview()})
        generateScheduleStackView()
        title = (staffMember?.firstName ?? "") + " " + (staffMember?.lastName ?? "")
    }
    
    //MARK: Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        delegate?.didSetEditing(editing)
        
        setHidden(!editing, toStacks: dayScheduleStackViews)
        setHidden(editing, toStacks: dayScheduleLabels)
        
        if editing {
            if let workingDays = staffMember?.workingDays as? Set<WorkingDay> {
                for workingDay in workingDays {
                    let view = dayScheduleStackViews.first(where: {$0.selectedDay.rawValue == Int(workingDay.day)})
                    view?.configureView(startingDate: workingDay.startingTime ?? "12:00", endingDate: workingDay.endingTime ?? "12:00")
                }
            }
        } else {
            updateStaffMember()
            refreshUi()
        }
    }
    
    func setHidden(_ hidden: Bool, toStacks stackViews: [UIStackView]) {
        for stackView in stackViews {
            UIView.animate(withDuration: 0.3) {
                stackView.isHidden = hidden
            }
        }
    }
    
    //MARK: Data manipulation
    func updateStaffMember() {
        
        guard let staffToEdit = staffMember else { return }
        staffCoreDataManager.deleteAllWorkingDays(from: staffToEdit)
        staffToEdit.addToWorkingDays(workingDayManager.createWorkingDays(from: dayScheduleStackViews.filter({$0.workingDaySwitch.isOn})))
        staffCoreDataManager.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Generating stack views
    func generateScheduleStackView() {
        
        guard let workingDaysArray = staffMember?.workingDays?.allObjects as? [WorkingDay] else { return }
        
        
        for workingDay in workingDaysArray.sorted(by: { (firstDay, secondDay) -> Bool in
            return firstDay.day < secondDay.day
        }) {
            let horizontalStackView = DayScheduleReadOnlyView()
            horizontalStackView.workingDay = workingDay
            scheduleStackView.addArrangedSubview(horizontalStackView)
            dayScheduleLabels.append(horizontalStackView)
        }
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServiceListViewControllerEmbedSegue" {
            let destinationVc = segue.destination as! ServiceListViewController
            destinationVc.staffMember = self.staffMember
            self.delegate = destinationVc
        }
    }
    
    
}
