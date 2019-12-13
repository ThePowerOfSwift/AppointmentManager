import UIKit

class DayScheduleReadOnlyView: UIStackView {
    
    var workingDay: WorkingDay? = nil {
        didSet {
            guard let settedWorkingDay = workingDay else { return }
            _ = addLabel(text: Day.dayDictionary[Int(settedWorkingDay.day)] ?? "")
            let schedule = generateDayScheduleHours(from: settedWorkingDay)
            addLabel(text: schedule).textAlignment = .right 
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        axis = .horizontal
        distribution = .fillEqually
    }
    
    fileprivate func generateDayScheduleHours(from workingDay: WorkingDay) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var startingHourText = ""
        var endingHourText = ""
        
        if let startingHour = workingDay.startingTime {
            startingHourText = startingHour
        }
        
        if let endingHour = workingDay.endingTime {
            endingHourText = endingHour
        }
        
        return startingHourText + " - " + endingHourText
    }
    
    fileprivate func addLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        addArrangedSubview(label)
        return label
    }
}
