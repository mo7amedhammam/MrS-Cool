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
    var teacherlessonID, teacherlessonsessionID, teachersubjectAcademicSemesterYearID, teacherLessonSessionSchedualSlotID: Int?
    var teacherSujectAcademicSemesterYearID: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink: String?
    var teacherAttended: Bool?
    var subjectName, sessionName: String?
    var students: Int?

    enum CodingKeys: String, CodingKey {
        case teacherlessonID = "teacherlessonId"
        case teacherlessonsessionID = "teacherlessonsessionId"
        case teachersubjectAcademicSemesterYearID = "teachersubjectAcademicSemesterYearId"
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case teacherSujectAcademicSemesterYearID = "teacherSujectAcademicSemesterYearId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, teacherAttended, subjectName, sessionName, students
    }
}



// MARK: - StudentHomeM
struct StudentHomeM: Codable {
    var items: [TeacherHomeItemM]?
    var totalCount: Int?
}
// MARK: - StudentHomeItemM
struct StudentHomeItemM: Codable,Hashable {
    var teacherLessonSessionSchedualSlotID, bookTeacherlessonsessionDetailID: Int?
    var lessonName, groupName, date, timeFrom: String?
    var timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink, subjectName, teacherName: String?
    
    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case bookTeacherlessonsessionDetailID = "bookTeacherlessonsessionDetailId"
        case lessonName, groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, subjectName, teacherName
    }
}
