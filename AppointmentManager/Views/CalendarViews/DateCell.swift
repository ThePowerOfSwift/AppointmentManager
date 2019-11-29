import JTAppleCalendar
import UIKit

class DateCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
