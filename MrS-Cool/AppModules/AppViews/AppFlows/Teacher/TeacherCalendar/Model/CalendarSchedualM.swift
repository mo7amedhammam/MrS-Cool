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
    var bookTeacherlessonsessionDetailId: Int?
    
    var sessionName: String?
    var teacherlessonId,teacherlessonsessionId,teacherSubjectAcademicSemesterYearId,groupDuration: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate
        case teamMeetingLink
        case bookTeacherlessonsessionDetailId
        
        case sessionName, teacherlessonId, teacherlessonsessionId, teacherSubjectAcademicSemesterYearId, groupDuration
    }
    
//    
//    "sessionName": "string",
//         "teacherlessonId": 0,
//         "teacherlessonsessionId": 0,
//         "teacherSubjectAcademicSemesterYearId": 0,
//         "teacherLessonSessionSchedualSlotId": 0,
//         "groupDuration": 0,
//         "groupName": "string",
//         "date": "2024-10-01T12:05:24.359Z",
//         "timeFrom": "00:00:00",
//         "timeTo": "00:00:00",
//         "isCancel": true,
//         "cancelDate": "2024-10-01T12:05:24.359Z",
//         "teamMeetingLink": "string",
//         "teacherAttended": true
    
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


