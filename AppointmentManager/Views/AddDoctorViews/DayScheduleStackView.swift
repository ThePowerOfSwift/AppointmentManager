import UIKit

@IBDesignable
class DayScheduleStackView: UIStackView {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var workingDaySwitch: UISwitch!
    @IBOutlet weak var errorMessage: UILabel!
    
    var startingHourStackView: HourPickerStackView? = nil
    var endingHourStackView: HourPickerStackView? = nil
    
    @IBInspectable var day: Int = 1 {
        didSet {
            dayLabel.text = Day.dayDictionary[day]
            selectedDay = Day(rawValue: day) ?? .monday
        }
    }
    
    var selectedDay: Day = Day.monday
    
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
    
    var viewIsValid: Bool {
        return startingHourStackView?.selectedDate.compare(endingHourStackView!.selectedDate) == .orderedAscending
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
    
    
    func configureView(startingDate: Date, endingDate: Date) {
        
        workingDaySwitch.isOn = true

        if startingHourStackView == nil {
        startingHourStackView = HourPickerStackView()
            stackView.addArrangedSubview(startingHourStackView!)
        }
        
        if endingHourStackView == nil {
            endingHourStackView = HourPickerStackView()
                    stackView.addArrangedSubview(endingHourStackView!)
        }
    
        startingHourStackView!.selectedDate = startingDate
        endingHourStackView!.selectedDate = endingDate
    }
}
