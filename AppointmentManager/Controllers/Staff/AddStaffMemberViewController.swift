import UIKit

class AddStaffMemberViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
    }
    
    let staffCoreDataManager = StaffMemberCoreDataManager()
    let workingDayCoreDataManager = WorkingDayCoreDataManager()
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var dayScheduleViews: [DayScheduleStackView]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        _ = validate(textField: sender)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard !dayScheduleViews.filter({$0.workingDaySwitch.isOn}).isEmpty else {
            generateInvalidDataAlert(message: "There are no days checked for this entry")
            return
        }

        let textFieldsValid = textFields.map({validate(textField: $0)}).contains(false)
        let dayScheduleValid = dayScheduleViews.map({$0.validateView()}).contains(false)
        
        if !textFieldsValid && !dayScheduleValid {
            createStaffMember()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func createStaffMember() {
        
        guard let enteredFirstName = firstNameTextField.text, let enteredLastName = lastNameTextField.text, let enteredPosition = positionTextField.text else { return }
        
        let newStaffMember = staffCoreDataManager.createStaffMember(firstName: enteredFirstName, lastName: enteredLastName, position: enteredPosition)
        let workingDays = workingDayCoreDataManager.createWorkingDays(from: dayScheduleViews.filter({$0.workingDaySwitch.isOn}))
        newStaffMember.addToWorkingDays(workingDays)
        staffCoreDataManager.saveContext()
    
    }
    

    
    func generateInvalidDataAlert(message: String) {
        let alert = UIAlertController(title: "Invalid data", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func validate(textField: UITextField) -> Bool {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        let validTextField = !(textField.text?.isEmpty ?? true)
        textField.layer.borderColor = validTextField ? UIColor.systemGray3.cgColor : UIColor.red.cgColor
        return validTextField
    }
    
}
