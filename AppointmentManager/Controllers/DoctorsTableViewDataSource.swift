import UIKit

class DoctorsTableViewDataSource: NSObject, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doctorCell")!
        cell.textLabel?.text = "Hola"
        cell.backgroundColor = .red
        return cell
    }
    
   
    
}
