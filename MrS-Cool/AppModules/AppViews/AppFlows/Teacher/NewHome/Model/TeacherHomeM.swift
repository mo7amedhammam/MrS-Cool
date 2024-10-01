//
//  TeacherHomeM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

// MARK: - TeacherHomeM
struct TeacherHomeM: Codable {
    var items: [TeacherHomeItemM]?
    var totalCount: Int?
}

// MARK: - TeacherHomeItemM
struct TeacherHomeItemM: Codable,Hashable {
    var teacherlessonID, teacherlessonsessionID, teacherLessonSessionSchedualSlotID: Int?
    var teachersubjectAcademicSemesterYearID: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink: String?
    var teacherAttended: Bool?
    var subjectName, sessionName: String?
    var students,groupDuration: Int?

    enum CodingKeys: String, CodingKey {
        case teacherlessonID = "teacherlessonId"
        case teacherlessonsessionID = "teacherlessonsessionId"
        case teachersubjectAcademicSemesterYearID = "teacherSubjectAcademicSemesterYearId"
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, teacherAttended, subjectName, sessionName, students,groupDuration
    }
}


// MARK: - StudentHomeM
struct StudentHomeM: Codable {
    var items: [StudentHomeItemM]?
    var totalCount: Int?
}
// MARK: - StudentHomeItemM
struct StudentHomeItemM: Codable,Hashable {
    var teacherLessonSessionSchedualSlotID, bookTeacherlessonsessionDetailID: Int?
    var lessonName, groupName, date, timeFrom,timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink, subjectName, teacherName: String?
    
    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case bookTeacherlessonsessionDetailID = "bookTeacherlessonsessionDetailId"
        case lessonName, groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, subjectName, teacherName
    }
}
