import UIKit

@IBDesignable
class HourPickerStackView: UIStackView {
    
    //MARK: IB Inspectables    
    @IBInspectable var label: String = "Monday" {
        didSet {
            textLabel.text = label
            
        }
    }
    
    //MARK: Elements
    fileprivate let dateFormatter = DateFormatter()
    
    var selectedDate: Date = Date() {
        didSet {
            dateFormatter.dateFormat = "HH:mm"
            hourLabel.text = dateFormatter.string(from: selectedDate)
        }
    }
    
    //MARK: UI Elements
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        let bundle = Bundle(for: HourPickerStackView.self)
        bundle.loadNibNamed("HourPickerStackView", owner: self, options: nil)
        addArrangedSubview(stackView)
        self.frame = bounds
        
    }
    
    //MARK: Actions
    
    @IBAction func datepickerValueChanged(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "HH:mm"
        hourLabel.text = dateFormatter.string(from: sender.date)
        selectedDate = sender.date
        print("This is the selected date: \(selectedDate)")
    }
}
