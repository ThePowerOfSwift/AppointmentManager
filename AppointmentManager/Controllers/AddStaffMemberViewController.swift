import UIKit

class AddStaffMemberViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
    }
    
    let staffCoreDataManager = StaffMemberCoreDataManager()
    let workingDayCoreDataManager = WorkingDayCoreDataManager()
    
    var staffMember: StaffMember? = nil {
        didSet {
            firstNameTextField?.text = staffMember?.firstName
            lastNameTextField?.text = staffMember?.lastName
            if let workingDays = staffMember?.workingDays as? Set<WorkingDay> {
                for workingDay in workingDays {
                    let view = dayScheduleViews.first(where: {$0.selectedDay == Day(rawValue: workingDay.day ?? "Monday")})
                    view?.configureView(startingDate: workingDay.startingHour ?? Date(), endingDate: workingDay.endingHour ?? Date())
                }
            }
        }
    }
    
    @IBOutlet var dayScheduleViews: [DayScheduleStackView]!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBAction func positionTextEditingChanged(_ sender: Any) {
        _ = validate(textField: positionTextField)
    }
    
    @IBAction func firstNameTextEditingChanged(_ sender: Any) {
        _ = validate(textField: firstNameTextField)
    }
    
    @IBAction func lastNameTextEditingChanged(_ sender: Any) {
        _ = validate(textField: lastNameTextField)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard !dayScheduleViews.filter({$0.workingDaySwitch.isOn}).isEmpty else {
            generateInvalidDataAlert(message: "There are no days checked for this entry")
            return
        }
        
        let dayFieldsValid = validateDayViews()
        let isFirstNameValid = validate(textField: firstNameTextField)
        let isLastNameValid = validate(textField: lastNameTextField)
        let isPositionValid = validate(textField: positionTextField)
        
        guard dayFieldsValid && isFirstNameValid && isLastNameValid && isPositionValid else {
            generateInvalidDataAlert(message: "Some of the data you entered is not valid, please check the red fields.")
            return
        }
        
        if staffMember == nil {
            createStaffMember()
        } else {
            updateStaffMember()
        }
    }
    
    func createStaffMember() {
        
        guard let enteredFirstName = firstNameTextField.text, let enteredLastName = lastNameTextField.text, let enteredPosition = positionTextField.text else { return }
        
        let newStaffMember = staffCoreDataManager.createStaffMember(firstName: enteredFirstName, lastName: enteredLastName, position: enteredPosition)
        let workingDays = workingDayCoreDataManager.createWorkingDays(from: dayScheduleViews.filter({$0.workingDaySwitch.isOn}))
        newStaffMember.addToWorkingDays(workingDays)
        staffCoreDataManager.saveContext()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func updateStaffMember() {
        
        guard let staffToEdit = staffMember else { return }
        staffCoreDataManager.updateStaffMember(staffMember: staffToEdit, firstName: firstNameTextField.text, lastName: lastNameTextField.text)
        staffCoreDataManager.removeAllWorkingDays(from: staffToEdit)
        staffToEdit.addToWorkingDays(workingDayCoreDataManager.createWorkingDays(from: dayScheduleViews.filter({$0.workingDaySwitch.isOn})))
        staffCoreDataManager.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    func generateInvalidDataAlert(message: String) {
        let alert = UIAlertController(title: "Invalid data", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func validateDayViews() -> Bool {
        var isValid = true
        for dayScheduleView in dayScheduleViews {
            if dayScheduleView.workingDaySwitch.isOn {
                dayScheduleView.configureView()
                if !dayScheduleView.viewIsValid {
                    isValid = false
                }
            }
        }
        return isValid
    }
    
    private func configure(textField: UITextField, valid: Bool) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = valid ? UIColor.systemGray3.cgColor : UIColor.red.cgColor
    }
    
    private func validate(textField: UITextField) -> Bool {
        let validTextField = !(textField.text?.isEmpty ?? true)
        configure(textField: textField, valid: validTextField)
        return validTextField
    }
    
}
