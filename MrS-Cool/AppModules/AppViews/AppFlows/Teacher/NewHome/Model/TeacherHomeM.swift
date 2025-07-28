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
struct TeacherHomeItemM: Codable,Hashable,Identifiable {
//        static func == (lhs: TeacherHomeItemM, rhs: TeacherHomeItemM) -> Bool {
//            return lhs.teacherlessonID == rhs.teacherlessonID
//        }
    var id: ObjectIdentifier?
    
    var teacherlessonID, teacherlessonsessionID, teacherLessonSessionSchedualSlotID: Int?
    var teachersubjectAcademicSemesterYearID: Int?
    var groupName, date, timeFrom, timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink,teamLink: String?
    var teacherAttended: Bool?
    var subjectName, sessionName: String?
    var students,groupDuration: Int?
    var canCancel,isAlternate:Bool?

    enum CodingKeys: String, CodingKey {
        case teacherlessonID = "teacherlessonId"
        case teacherlessonsessionID = "teacherlessonsessionId"
        case teachersubjectAcademicSemesterYearID = "teacherSubjectAcademicSemesterYearId"
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink, teamLink, teacherAttended, subjectName, sessionName, students,groupDuration
        case canCancel,isAlternate
    }
}


// MARK: - StudentHomeM
struct StudentHomeM: Codable {
    var items: [StudentHomeItemM]?
    var totalCount: Int?
}
// MARK: - StudentHomeItemM
struct StudentHomeItemM: Codable,Hashable,Identifiable {
//    static func == (lhs: StudentHomeItemM, rhs: StudentHomeItemM) -> Bool {
//        return lhs.teacherLessonSessionSchedualSlotID == rhs.teacherLessonSessionSchedualSlotID
//    }
    var id: ObjectIdentifier?

    var teacherLessonSessionSchedualSlotID, bookTeacherlessonsessionDetailID: Int?
    var lessonName, groupName, date, timeFrom,timeTo: String?
    var isCancel: Bool?
    var cancelDate, teamMeetingLink, teamLink, subjectName, teacherName: String?
    var canCancel,isAlternate:Bool?
    var originalBookDetailId:Int?
    
    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case bookTeacherlessonsessionDetailID = "bookTeacherlessonsessionDetailId"
        case lessonName, groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink,teamLink , subjectName, teacherName
        case canCancel,isAlternate
        case originalBookDetailId
    }
}

// MARK: - StudentCalendarDetailM
//struct StudentCalendarDetailM: Codable {
//    var teacherLessonSessionSchedualSlotID, bookTeacherlessonsessionDetailID: Int?
//    var lessonName, groupName, date, timeFrom: String?
//    var timeTo: String?
//    var isCancel: Bool?
//    var cancelDate, teamMeetingLink: String?
//    var originalBookDetailID: Int?
//    var isAlternate: Bool?
//    var subjectName, teacherName: String?
//    var canCancel: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
//        case bookTeacherlessonsessionDetailID = "bookTeacherlessonsessionDetailId"
//        case lessonName, groupName, date, timeFrom, timeTo, isCancel, cancelDate, teamMeetingLink
//        case originalBookDetailID = "originalBookDetailId"
//        case isAlternate, subjectName, teacherName, canCancel
//    }
//}


// MARK: - AlternateSessoinM
struct AlternateSessoinM: Codable,Hashable {
    var teacherLessonSessionSlotID, absentStudentCount, teacherLessonSessionID, teacherSujectAcademicSemesterYearid: Int?
    var subjectName: String?
    var teacherLessonID, duration: Int?
    var groupName, lessonName, date: String?

    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSlotID = "teacherLessonSessionSlotId"
        case absentStudentCount
        case teacherLessonSessionID = "teacherLessonSessionId"
        case teacherSujectAcademicSemesterYearid, subjectName
        case teacherLessonID = "teacherLessonId"
        case groupName, lessonName, date,duration
    }
}

