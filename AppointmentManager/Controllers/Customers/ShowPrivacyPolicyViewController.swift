import UIKit
import CoreData
import PDFKit

class ShowPrivacyPolicyViewController: UIViewController {

    var objectId: NSManagedObjectID!
    
    @IBOutlet var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let customer = managedObjectContext.object(with: objectId) as! Customer
        let privacyPolicyFile = PDFDocument(data: customer.privacyPolicy!)
        pdfView.document = privacyPolicyFile
        pdfView.usePageViewController(true, withViewOptions: nil)
        
    }
    
    
    
}
