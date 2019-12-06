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
    var isExpanded = false
    
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
    
    var datepicker: UIDatePicker? = nil
    
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
        
        dateFormatter.dateFormat = "HH:mm"
        selectedDate = dateFormatter.date(from: "12:00")!
        
    }
    
    @IBAction func hourTapped(_ sender: Any) {
        if isExpanded {
            UIView.animate(withDuration: 0.3) {
                self.datepicker?.isHidden = true
            }
            datepicker?.removeFromSuperview()
            datepicker = nil
            isExpanded = false
        } else {
            datepicker = UIDatePicker()
            datepicker?.addTarget(self, action: #selector(datepickerValueChanged(_:)), for: .valueChanged)
            datepicker?.datePickerMode = .time
            datepicker?.minuteInterval = 5
            dateFormatter.dateFormat = "HH:mm"
            datepicker?.date = dateFormatter.date(from: "12:00")!
            datepicker?.isHidden = true
            stackView.addArrangedSubview(datepicker!)
            UIView.animate(withDuration: 0.3) {
                self.datepicker?.isHidden = false
            }
            isExpanded = true
        }
        
    }
}

extension HourPickerStackView {
    
    @objc func datepickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
}
