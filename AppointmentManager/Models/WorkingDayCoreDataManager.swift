import Foundation

class WorkingDayCoreDataManager: CoreDataManager {
    
    func createWorkingDays(from dayScheduleViews: [DayScheduleStackView]) -> NSSet {
        let workingDays = NSSet()
        for dayScheduleView in dayScheduleViews {
            let workingDay = createWorkingDay(from: dayScheduleView)
            workingDays.adding(workingDay)
        }
        return workingDays
    }
    
    func createWorkingDay(from dayScheduleView: DayScheduleStackView) -> WorkingDay {
        let workingDay = WorkingDay(context: managedObjectContext)
        workingDay.day = dayScheduleView.day
        workingDay.startingHour = dayScheduleView.startingHourStackView.selectedDate
        workingDay.endingHour = dayScheduleView.endingHourStackView.selectedDate
        return workingDay
    }
}
