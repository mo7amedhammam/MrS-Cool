//
//  CompletedLessonsM.swift
//  MrS-Cool
//
//  Created by wecancity on 13/12/2023.
//

import Foundation

// MARK: - CompletedLessonsM
struct CompletedLessonsM: Codable {
    var items: [CompletedLessonItem]?
    var totalCount: Int?
}

// MARK: - Item
struct CompletedLessonItem: Codable,Hashable {
    var teacherLessonSessionSchedualSlotID: Int?
    var subjectName, lessonName, groupName, date: String?
    var timeFrom, timeTo: String?
    var teacherAttended:Bool?

    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionSchedualSlotID = "teacherLessonSessionSchedualSlotId"
        case subjectName, lessonName, groupName, date, timeFrom, timeTo
        case teacherAttended
    }
}

// MARK: - CompletedLessonDetailsM -
struct CompletedLessonDetailsM: Codable {
    var subjectName: String?
    var teacherLessonID: Int?
    var lessonName, groupName, subjectBrief, lessonBrief,subjectSystemBrief,lessonSystemBrief: String?
    var teacherCompletedLessonStudentList: [TeacherCompletedLessonStudentList]?

    enum CodingKeys: String, CodingKey {
        case subjectName
        case teacherLessonID = "teacherLessonId"
        case lessonName, groupName, subjectBrief, lessonBrief,subjectSystemBrief,lessonSystemBrief, teacherCompletedLessonStudentList
    }
}

// MARK: - TeacherCompletedLessonStudentList -
struct TeacherCompletedLessonStudentList: Codable ,Hashable{
    var studentID: Int?
    var studentName: String?
    var parentID: Int?
    var parentName: String?
    var studentAttended: Bool?
    var studentImageURL: String?
    var bookSessionDetailID: Int?

    enum CodingKeys: String, CodingKey {
        case studentID = "studentId"
        case studentName
        case parentID = "parentId"
        case parentName, studentAttended
        case studentImageURL = "studentImageUrl"
        case bookSessionDetailID = "bookSessionDetailId"
    }
}


