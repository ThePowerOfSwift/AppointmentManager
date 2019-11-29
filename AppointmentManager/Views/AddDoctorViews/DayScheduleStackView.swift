import UIKit

@IBDesignable
class DayScheduleStackView: UIStackView {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var startingHourStackView: HourPickerStackView!
    @IBOutlet weak var endingHourStackView: HourPickerStackView!
    @IBOutlet weak var workingDaySwitch: UISwitch!
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBInspectable var day: String = "" {
        didSet {
            dayLabel.text = day
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
        UIView.animate(withDuration: 0.3) {
            self.startingHourStackView.isHidden = !sender.isOn
            self.endingHourStackView.isHidden = !sender.isOn
        }
        
    }
    
    @IBAction func startingHourTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.startingHourStackView.datepicker.isHidden.toggle()
            self.endingHourStackView.datepicker.isHidden = true
        }
    }
    
    @IBAction func endingHourTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.endingHourStackView.datepicker.isHidden.toggle()
            self.startingHourStackView.datepicker.isHidden = true
        }
    }
    
    var viewIsValid: Bool {
        print("Validating view")
        print(startingHourStackView.selectedDate)
        print(endingHourStackView.selectedDate)
        return startingHourStackView.selectedDate.compare(endingHourStackView.selectedDate) == .orderedAscending
    }
    
    func configureView() {
        errorMessage.isHidden = viewIsValid
        startingHourStackView.textLabel.textColor = viewIsValid ? .black : .red
        endingHourStackView.textLabel.textColor = viewIsValid ? .black : .red
    }
    
    func configureView(startingDate: Date, endingDate: Date) {
        
        workingDaySwitch.isOn = true
        
        startingHourStackView.isHidden = false
        endingHourStackView.isHidden = false
        
        startingHourStackView.selectedDate = startingDate
        endingHourStackView.selectedDate = endingDate
    }
}
