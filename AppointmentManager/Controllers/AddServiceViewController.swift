import UIKit

protocol AddServiceDelegate {
    
    func didAddService()
    
}

class AddServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = Locale.current
        currencyLabel.text = locale.currencyCode
    }
    @IBOutlet weak var serviceNameTextField: UITextField!
    @IBOutlet weak var servicePriceTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var staffMember: StaffMember? = nil
    
    var delegate: AddServiceDelegate?
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let enteredName = serviceNameTextField.text else {
            errorLabel.isHidden = false
            return
        }
        
        guard !enteredName.isEmpty else {
            errorLabel.isHidden = false
            return
        }
        
        guard let enteredPrice = servicePriceTextField.text else {
            errorLabel.isHidden = false
            return
        }
        
        guard let selectedStaffMember = staffMember else { return }
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        managedObjectContext.automaticallyMergesChangesFromParent = true
        let service = Service(context: managedObjectContext)
        
        service.name = enteredName
        service.price = Int16(enteredPrice) ?? 0
        service.addToStaffMembers(selectedStaffMember)
        try! managedObjectContext.save()
        dismiss(animated: true, completion: nil)
        delegate?.didAddService()
    }

}
