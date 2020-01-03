import UIKit

@IBDesignable
class DayScheduleStackView: UIStackView {
    
    //MARK: Elemements
    var startingHourStackView: HourPickerStackView? = nil
    var endingHourStackView: HourPickerStackView? = nil
    var selectedDay: Day = Day.monday
    fileprivate lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    //MARK: Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var workingDaySwitch: UISwitch!
    @IBOutlet weak var errorMessage: UILabel!
    
    //MARK: Inspectables
    @IBInspectable var day: Int = 1 {
        didSet {
            dayLabel.text = Day.dayDictionary[day]
            selectedDay = Day(rawValue: day) ?? .monday
        }
    }
    
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
        let bundle = Bundle(for: DayScheduleStackView.self)
        bundle.loadNibNamed("DayScheduleStackView", owner: self, options: nil)
        addArrangedSubview(stackView)
        self.frame = bounds
    }
    
    //MARK: Switch toggled
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            startingHourStackView = HourPickerStackView()
            endingHourStackView = HourPickerStackView()
            startingHourStackView?.isHidden = true
            endingHourStackView?.isHidden = true
            stackView.addArrangedSubview(startingHourStackView!)
            stackView.addArrangedSubview(endingHourStackView!)
            UIView.animate(withDuration: 0.3) {
                self.startingHourStackView?.isHidden = false
                self.endingHourStackView?.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.startingHourStackView?.isHidden = true
                self.endingHourStackView?.isHidden = true
            }
            startingHourStackView?.removeFromSuperview()
            endingHourStackView?.removeFromSuperview()
        }
            
    }
    
    //MARK: Validations
    fileprivate var viewIsValid: Bool {
        guard let startingTime = startingHourStackView?.selectedTime, let startingDate = dateFormatter.date(from: startingTime) else {
            return false
        }
        guard let endingTime = endingHourStackView?.selectedTime, let endingDate = dateFormatter.date(from: endingTime) else {
            return false
        }
        return startingDate.compare(endingDate) == .orderedAscending
    }
    
    func validateView() -> Bool {
        if workingDaySwitch.isOn {
            errorMessage.isHidden = viewIsValid
            startingHourStackView?.textLabel.textColor = viewIsValid ? .black : .red
            endingHourStackView?.textLabel.textColor = viewIsValid ? .black : .red
            return viewIsValid
        } else {
            return true
        }
    }
    
    
    //MARK: View configuration
    func configureView(startingDate: String, endingDate: String) {
        
        workingDaySwitch.isOn = true

        if startingHourStackView == nil {
        startingHourStackView = HourPickerStackView()
            stackView.addArrangedSubview(startingHourStackView!)
        }
        
        if endingHourStackView == nil {
            endingHourStackView = HourPickerStackView()
                    stackView.addArrangedSubview(endingHourStackView!)
        }
    
        startingHourStackView!.selectedTime = startingDate
        endingHourStackView!.selectedTime = endingDate
    }
}
