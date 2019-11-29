import UIKit

class StaffMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(for staffMember: StaffMember) {
        nameLabel.text = (staffMember.firstName ?? "") + " " + (staffMember.lastName ?? "")
        positionLabel.text = staffMember.position ?? ""
    }
}
