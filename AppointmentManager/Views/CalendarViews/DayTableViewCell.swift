import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    var staffMembers = [StaffMember]() {
        didSet {
            addStaff(staffMembers)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addStaff(_ staffMember: [StaffMember]) {
        verticalStackView.arrangedSubviews.forEach({
            verticalStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
        staffMember.forEach({
            let label = UILabel()
            label.text = ($0.firstName ?? "") + " " + ($0.lastName ?? "")
            label.textColor = .systemGreen
            verticalStackView.addArrangedSubview(label)
        })
    }

}
