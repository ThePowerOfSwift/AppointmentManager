import UIKit

class CustomerDetailsViewController: UIViewController {
    
    //MARK: Variables
    var customer: Customer?
    var customerInfoExpanded = true
    
    //MARK: Outlets
    @IBOutlet weak var customerInfoStackView: UIStackView!
    @IBOutlet weak var expandCustomerInfoButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var signedOnLabel: UILabel!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = self.editButtonItem
        textFields.first(where: {$0.tag == 0})?.text = customer?.firstName
        textFields.first(where: {$0.tag == 1})?.text = customer?.lastName
        textFields.first(where: {$0.tag == 2})?.text = customer?.phoneNumber
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        if let signedDate = customer?.signedPrivacyPolicyDate {
            signedOnLabel.text = dateFormatter.string(from: signedDate)
        }
        
    }
    
    //MARK: Actions
    @IBAction func buttonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowPrivacyPolicySegue", sender: self)
    }
    
    @IBAction func expandCustomerInforButtonTapped(_ sender: Any) {
        customerInfoExpanded.toggle()
        expandCustomerInforStackView()
        expandCustomerInfoButton.setTitle(customerInfoExpanded ? "Collapse" : "Expand", for: .normal)
    }
    
    func expandCustomerInforStackView() {
        for subviewIndex in 1 ..< customerInfoStackView.arrangedSubviews.count {
            UIView.animate(withDuration: 0.5) {
                self.customerInfoStackView.arrangedSubviews[subviewIndex].isHidden = !self.customerInfoExpanded
            }
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPrivacyPolicySegue" {
            guard let destinationVC = segue.destination as? ShowPrivacyPolicyViewController else {
                return
            }
            destinationVC.objectId = customer?.objectID
        }
    }
    
    //MARK: Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        UIView.animate(withDuration: 0.5) {
            self.textFields.forEach({$0.isEnabled = editing})
        }
        if !editing {
            let orderedTextFields = textFields.sorted(by: {$1.tag > $0.tag})
            let customerCoreDataManager = CustomerCoreDataManager()
            customerCoreDataManager.update(customer: customer!, firstName: orderedTextFields[0].text!, lastName: orderedTextFields[1].text!, phoneNumber: orderedTextFields[2].text!)
        }
    }
}

