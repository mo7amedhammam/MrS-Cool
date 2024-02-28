//
//  CalendarSchedualM.swift
//  MrS-Cool
//
//  Created by wecancity on 19/12/2023.
//


// MARK: - EventM -
struct EventM: Codable,Identifiable ,Equatable{
    var id: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate
    }
}

// MARK: - StudentEventM -
struct StudentEventM: Codable,Identifiable ,Equatable{
    var id: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate: String?
    var lessonName: String? // student
    
    enum CodingKeys: String, CodingKey {
        case id = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate
        case lessonName // student
    }
}

