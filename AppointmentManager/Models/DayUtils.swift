import Foundation

class DayUtils {
    
    static func generateIntervals(for date: Date) -> [Date] {
        let startOfDay = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: date)!
        let endOfDay = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: date)!
        let dateInterval = DateInterval(start: startOfDay, end: endOfDay)
        let intervalSplitter = 15 * 60
        var dates = [Date]()
        for index in 0...Int(dateInterval.duration) / intervalSplitter {
            dates.append(startOfDay.advanced(by: Double(intervalSplitter * index)))
        }
        return dates
    }
    
    static func generateDateInterval(staffMember: StaffMember, date: Date) -> DateInterval {
        let days = staffMember.workingDays as? Set<WorkingDay>
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let workingDay = days?.filter({$0.day == dayOfWeek}).first
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startingHour = Calendar.current.component(.hour, from: dateFormatter.date(from: workingDay!.startingTime!)!)
        let endingHour = Calendar.current.component(.hour, from: dateFormatter.date(from: workingDay!.endingTime!)!)
        
        let dateInterval = DateInterval(start: Calendar.current.date(bySettingHour: startingHour, minute: 0, second: 0, of: date)!, end: Calendar.current.date(bySettingHour: endingHour, minute: 0, second: 0, of: date)!)
        return dateInterval
    }
    
}
