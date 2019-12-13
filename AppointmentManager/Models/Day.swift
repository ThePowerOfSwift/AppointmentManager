import Foundation

enum Day: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    static let dayDictionary = [2: "Monday",
                                3: "Tuesday",
                                4: "Wednesday",
                                5: "Thursday",
                                6: "Friday",
                                7: "Saturday",
                                1: "Sunday"]
}
