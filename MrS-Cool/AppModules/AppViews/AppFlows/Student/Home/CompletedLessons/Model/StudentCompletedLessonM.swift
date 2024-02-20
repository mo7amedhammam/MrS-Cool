//
//  StudentCompletedLessonM.swift
//  MrS-Cool
//
//  Created by wecancity on 20/02/2024.
//

import Foundation


// MARK: - CompletedLessonsM
struct StudentCompletedLessonM: Codable {
    var items: [StudentCompletedLessonItemM]?
    var totalCount: Int?
}
// MARK: - StudentCompletedLessonM -
struct StudentCompletedLessonItemM: Codable ,Hashable{
    var studentID,teacherLessonId: Int?
    var subject,teacherName,lessonname,groupName,date,startTime,endTime: String?
    var attendance: Bool?

    enum CodingKeys: String, CodingKey {
        case studentID = "studentId"
        case teacherLessonId = "teacherLessonId"
        case lessonname = "lessonname"
        case subject,teacherName, groupName, date, startTime, endTime
        case attendance
    }
}
