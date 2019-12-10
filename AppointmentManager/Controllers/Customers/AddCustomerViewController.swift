import UIKit

class AddCustomerViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var textFields: [UITextField]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Button Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard !textFields.map({validate(textField: $0)}).contains(false) else {
            errorLabel.isHidden = false
            return
        }        
        performSegue(withIdentifier: "SignPolicySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignPolicySegue" {
            guard let destinationVc = segue.destination as? SignPrivacyPolicyViewController else {
                return
            }
            destinationVc.customerData = textFields.sorted(by: {$1.tag > $0.tag}).map({$0.text ?? ""})
        }
    }
    
    //MARK: Text fields actions
    func validate(textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? true {
            errorLabel.isHidden = false
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 5
            return false
        } else {
            return true
        }
    }
    
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let enteredText = sender.text {
            sender.layer.borderWidth = 1
            sender.layer.borderColor = enteredText.isEmpty ? UIColor.red.cgColor : UIColor.systemGray3.cgColor
            sender.layer.cornerRadius = 5
        }
        errorLabel.isHidden = true
    }
    
}
