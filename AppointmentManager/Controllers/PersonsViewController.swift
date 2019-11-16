import UIKit

class PersonsViewController: UIViewController {

    @IBOutlet weak var personsTableView: UITableView!
    
    let doctorsDataSource = DoctorsTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personsTableView.dataSource = doctorsDataSource
    }
    
}

