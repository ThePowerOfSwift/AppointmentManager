import CoreData

class StaffMemberCoreDataManager: CoreDataManager {
    
    func createStaffMember(firstName: String, lastName: String, position: String, phoneNumber: String? = nil) -> StaffMember {
        let staffMember = StaffMember(context: managedObjectContext)
        staffMember.firstName = firstName
        staffMember.lastName = lastName
        staffMember.phoneNumber = phoneNumber
        staffMember.position = position
        return staffMember
    }
    
    func updateStaffMember(staffMember: StaffMember, firstName: String? = nil, lastName: String? = nil, phoneNumber: String? = nil) {
        if firstName != nil {
            staffMember.firstName = firstName
        }
        if lastName != nil {
            staffMember.lastName = lastName
        }
        if phoneNumber != nil {
            staffMember.phoneNumber = phoneNumber
        }
    }
    
    func deleteAllWorkingDays(from staffMember: StaffMember) {
        guard let workingDays = staffMember.workingDays as? Set<WorkingDay> else { return }
        workingDays.forEach {
            staffMember.removeFromWorkingDays($0)
            managedObjectContext.delete($0)
        }
    }
    
    func delete(staffMember: StaffMember) {
        deleteAllWorkingDays(from: staffMember)
        managedObjectContext.delete(staffMember)
    }
    
}
