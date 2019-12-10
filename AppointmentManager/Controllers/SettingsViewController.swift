import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("PrivacyPolicy.pdf")
        do {
            try FileManager.default.copyItem(at: url, to: path)
            privacyPolicyButton.titleLabel?.text = "Added"
        } catch {
            fatalError("Failed to copy file at path")
        }
    }
}
