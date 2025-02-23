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
//        static func == (lhs: TeacherHomeItemM, rhs: TeacherHomeItemM) -> Bool {
//            return lhs.teacherlessonID == rhs.teacherlessonID
//        }

    var teacherlessonID, teacherlessonsessionID, teacherLessonSessionSchedualSlotID: Int?
    var teachersubjectAcademicSemesterYearID: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink: String?
    var teacherAttended: Bool?
    var subjectName, sessionName: String?
    var students,groupDuration: Int?
    var canCancel:Bool?

    enum CodingKeys: String, CodingKey {
        case teacherlessonID = "teacherlessonId"
        case teacherlessonsessionID = "teacherlessonsessionId"
        case teachersubjectAcademicSemesterYearID = "teacherSubjectAcademicSemesterYearId"
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, teacherAttended, subjectName, sessionName, students,groupDuration
        case canCancel
    }
}


// MARK: - StudentHomeM
struct StudentHomeM: Codable {
    var items: [StudentHomeItemM]?
    var totalCount: Int?
}
// MARK: - StudentHomeItemM
struct StudentHomeItemM: Codable,Hashable {
//    static func == (lhs: StudentHomeItemM, rhs: StudentHomeItemM) -> Bool {
//        return lhs.teacherLessonSessionSchedualSlotID == rhs.teacherLessonSessionSchedualSlotID
//    }

    var teacherLessonSessionSchedualSlotID, bookTeacherlessonsessionDetailID: Int?
    var lessonName, groupName, date, timeFrom,timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink, subjectName, teacherName: String?
    var canCancel:Bool?
    
    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case bookTeacherlessonsessionDetailID = "bookTeacherlessonsessionDetailId"
        case lessonName, groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, subjectName, teacherName
        case canCancel
    }
}


// MARK: - AlternateSessoinM
struct AlternateSessoinM: Codable,Hashable {
    var teacherLessonSessionSlotID, absentStudentCount, teacherLessonSessionID, teacherSujectAcademicSemesterYearid: Int?
    var subjectName: String?
    var teacherLessonID: Int?
    var groupName, lessonName, date: String?

    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSlotID = "teacherLessonSessionSlotId"
        case absentStudentCount
        case teacherLessonSessionID = "teacherLessonSessionId"
        case teacherSujectAcademicSemesterYearid, subjectName
        case teacherLessonID = "teacherLessonId"
        case groupName, lessonName, date
    }
}


