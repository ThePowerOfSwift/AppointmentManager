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
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    var isExpanded = false
    
    var selectedTime: String = "12:00" {
        didSet {
            hourLabel.text = selectedTime
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
        
    }
    
    //MARK: Tapping hour
    @IBAction func hourTapped(_ sender: Any) {
        if isExpanded {
            UIView.animate(withDuration: 0.3) {
                self.datepicker?.isHidden = true
            }
            datepicker?.removeFromSuperview()
            datepicker = nil
            isExpanded = false
        } else {
            addDatepicker()
            isExpanded = true
        }
        
    }
    
    //MARK: Adding datepicker
    func addDatepicker() {
        datepicker = UIDatePicker()
        datepicker?.date = dateFormatter.date(from: "12:00")!
        datepicker?.addTarget(self, action: #selector(datepickerValueChanged(_:)), for: .valueChanged)
        datepicker?.datePickerMode = .time
        datepicker?.minuteInterval = 5
        datepicker?.isHidden = true
        stackView.addArrangedSubview(datepicker!)
        UIView.animate(withDuration: 0.3) {
            self.datepicker?.isHidden = false
        }
    }
}

//MARK: Datepicker actions
extension HourPickerStackView {
    
    @objc func datepickerValueChanged(_ sender: UIDatePicker) {
        selectedTime = dateFormatter.string(from: sender.date)
    }
}
