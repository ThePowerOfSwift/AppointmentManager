import UIKit
import PDFKit

class SignPrivacyPolicyViewController: UIViewController {
    
    private let pdfDrawer = PDFDrawer()
    
    @IBOutlet var pdfView: NonSelectablePDFView!
    
    var customerData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var privacyPolicyUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        privacyPolicyUrl.appendPathComponent("PrivacyPolicy.pdf")
        
        if let privacyPolicyDocument = PDFDocument(url: privacyPolicyUrl) {
            pdfView.document = privacyPolicyDocument
        }
        
        pdfView.usePageViewController(true, withViewOptions: nil)
        
        let pdfDrawingGestureRecognizer = DrawingGestureRecognizer()
        pdfDrawingGestureRecognizer.drawingDelegate = pdfDrawer
        pdfDrawer.pdfView = pdfView
        pdfView.addGestureRecognizer(pdfDrawingGestureRecognizer)
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let pageCount = pdfView.document?.pageCount else {
            return
        }
        
        var hasAnnotations = false
        
        for index in 0 ..< pageCount {
            if pdfView.document?.page(at: index)?.annotations.count ?? 0 > 0 {
                hasAnnotations = true
            }
        }
        
        if !hasAnnotations {
            let alert = UIAlertController(title: "No signature", message: "No signature was detected.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sign", style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let customerCoreDataManager = CustomerCoreDataManager()
        customerCoreDataManager.createCustomer(firstName: customerData[0], lastName: customerData[1], phoneNumber: customerData[2], privacy: pdfView.document!.dataRepresentation())
        navigationController?.dismiss(animated: true, completion: nil)
        
        
    }
}
