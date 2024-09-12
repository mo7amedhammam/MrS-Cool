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
    var nextCycleDue: Double?
    enum CodingKeys: String, CodingKey {
        case totalIncome
        case totalDue
        case nextCycleDue
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

    enum CodingKeys: String, CodingKey {
        case subjectOrLessonID = "subjectId"
        case subjectOrLessonName = "subjectName"
        case profit,count
    }
    
    init() {
           self.subjectOrLessonID = nil
           self.subjectOrLessonName = nil
//           self.teacherName = nil
           self.profit = nil
           self.count = nil
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
    }
    
}
