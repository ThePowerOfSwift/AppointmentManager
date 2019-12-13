import Foundation

class WorkingDayCoreDataManager: CoreDataManager {
    
    func createWorkingDays(from dayScheduleViews: [DayScheduleStackView]) -> NSSet {
        var workingDays = [WorkingDay]()
        for dayScheduleView in dayScheduleViews {
            let workingDay = createWorkingDay(from: dayScheduleView)
            workingDays.append(workingDay)
        }
        return NSSet(array: workingDays)
    }
    
    func createWorkingDay(from dayScheduleView: DayScheduleStackView) -> WorkingDay {
        let workingDay = WorkingDay(context: managedObjectContext)
        workingDay.day = Int16(dayScheduleView.day)
        workingDay.startingHour = dayScheduleView.startingHourStackView?.selectedDate
        workingDay.endingHour = dayScheduleView.endingHourStackView?.selectedDate
        return workingDay
    }
}
