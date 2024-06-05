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
    var teamMeetingLink: String?

    
    enum CodingKeys: String, CodingKey {
        case id = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate
        case teamMeetingLink
    }
}

// MARK: - StudentEventM -
struct StudentEventM: Codable,Identifiable ,Equatable{
    var id,bookTeacherlessonsessionDetailId: Int?
    var lessonName,groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate: String?
    var teamMeetingLink: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "teacherLessonSessionSchedualSlotId"
        case bookTeacherlessonsessionDetailId
        case lessonName,groupName, date, timeFrom, timeTo, isCancel, cancelDate
        case teamMeetingLink
    }
}


