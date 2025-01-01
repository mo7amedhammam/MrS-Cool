//
//  TeacherFinanceM.swift
//  MrS-Cool
//
//  Created by wecancity on 12/09/2024.
//

import Foundation

// MARK: - FinanceM
struct TeacherFinanceM: Codable {
    var totalIncome:Double?
    var totalDue: Double?
    var remaining,totalStudentNotattend,totalTeacherNotattend,totalCanceled,totalPurchases: Double?
//    var nextCycleDue: Double?
    enum CodingKeys: String, CodingKey {
        case totalIncome
        case totalDue
        case remaining,totalStudentNotattend,totalTeacherNotattend,totalCanceled,totalPurchases
//        case nextCycleDue
    }
}

// MARK: - FinanceSubjectsAndLessonsM
struct TeacherFinanceSubjectsAndLessonsM: Codable {
    var items: [TeacherFinanceItem]?
    var totalCount: Int?
}
// MARK: - Item
struct TeacherFinanceItem : Codable ,Equatable,Hashable{
    var subjectOrLessonID: Int?
    var subjectOrLessonName:String?
//    var teacherName: String?
    var profit: Double?
    var count: Int?

    var teacherLessonSessionId:Int?
    var studentAttend:Int?
    var studentNotAttend:Int?
    var studentCanceled:Int?
    var teacherCanceled:Int?
    var teacherAttended:Bool?
    var extraSession:Bool?

    enum CodingKeys: String, CodingKey {
        case subjectOrLessonID = "subjectId"
        case subjectOrLessonName = "subjectName"
        case profit,count
        
        case teacherLessonSessionId,studentAttend,studentNotAttend,studentCanceled,teacherCanceled,teacherAttended,extraSession
    }
    
    init() {
           self.subjectOrLessonID = nil
           self.subjectOrLessonName = nil
//           self.teacherName = nil
           self.profit = nil
           self.count = nil
        
        self.teacherLessonSessionId = nil
        self.studentAttend = nil
        self.studentNotAttend = nil
        self.studentCanceled = nil
        self.teacherCanceled = nil
        self.teacherAttended = nil
        self.extraSession = nil
    }
    
    enum AlternativeCodingKeys: String, CodingKey {
        case lessonName
        case lessonId
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode all known properties
        profit = try? container.decodeIfPresent(Double.self, forKey: .profit)
        count = try? container.decodeIfPresent(Int.self, forKey: .count)

        // Decode the subjectOrLessonName using either "subjectName" or "lessonName"
        if let subjectName = try? container.decodeIfPresent(String.self, forKey: .subjectOrLessonName) {
            subjectOrLessonName = subjectName
        } else {
            let alternativeContainer = try decoder.container(keyedBy: AlternativeCodingKeys.self)
            subjectOrLessonName = try? alternativeContainer.decodeIfPresent(String.self, forKey: .lessonName)
        }
        // Decode the subjectOrLessonName using either "subjectName" or "lessonName"
        if let subjectId = try? container.decodeIfPresent(Int.self, forKey: .subjectOrLessonID) {
            subjectOrLessonID = subjectId
        } else {
            let alternativeContainer = try decoder.container(keyedBy: AlternativeCodingKeys.self)
            subjectOrLessonID = try? alternativeContainer.decodeIfPresent(Int.self, forKey: .lessonId)
        }
        
        teacherLessonSessionId = try? container.decodeIfPresent(Int.self, forKey: .teacherLessonSessionId)
        studentAttend = try? container.decodeIfPresent(Int.self, forKey: .studentAttend)
        studentCanceled = try? container.decodeIfPresent(Int.self, forKey: .studentCanceled)
        studentNotAttend = try? container.decodeIfPresent(Int.self, forKey: .studentNotAttend)
        teacherCanceled = try? container.decodeIfPresent(Int.self, forKey: .teacherCanceled)
        teacherAttended = try? container.decodeIfPresent(Bool.self, forKey: .teacherAttended)
        extraSession = try? container.decodeIfPresent(Bool.self, forKey: .extraSession)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Encode all known properties
        try container.encodeIfPresent(profit, forKey: .profit)
        try container.encodeIfPresent(count, forKey: .count)
        
        // Encode subjectOrLessonName using the appropriate key
        if let subjectOrLessonName = subjectOrLessonName {
            try container.encode(subjectOrLessonName, forKey: .subjectOrLessonName)
        }
        // Encode subjectOrLessonName using the appropriate key
        if let subjectOrLessonID = subjectOrLessonID {
            try container.encode(subjectOrLessonID, forKey: .subjectOrLessonID)
        }
        
        try container.encodeIfPresent(teacherLessonSessionId, forKey: .teacherLessonSessionId)
        try container.encodeIfPresent(studentAttend, forKey: .studentAttend)
        try container.encodeIfPresent(studentNotAttend, forKey: .studentNotAttend)
        try container.encodeIfPresent(studentCanceled, forKey: .studentCanceled)
        try container.encodeIfPresent(teacherCanceled, forKey: .teacherCanceled)
        try container.encodeIfPresent(teacherAttended, forKey: .teacherAttended)
        try container.encodeIfPresent(extraSession, forKey: .extraSession)

    }
    
}
