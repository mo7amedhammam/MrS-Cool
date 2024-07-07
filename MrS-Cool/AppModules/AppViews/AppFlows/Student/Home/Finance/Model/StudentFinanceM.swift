//
//  StudentFinanceM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/07/2024.
//

import Foundation

// MARK: - FinanceM
struct FinanceM: Codable {
    var currentBalance:Double?
    var studentID: Int?

    enum CodingKeys: String, CodingKey {
        case currentBalance
        case studentID = "studentId"
    }
}

// MARK: - FinanceSubjectsAndLessonsM
struct FinanceSubjectsAndLessonsM: Codable {
    var items: [FinanceItem]?
    var totalCount: Int?
}

// MARK: - Item
struct FinanceItem : Codable ,Equatable,Hashable{
    var subjectID: Int?
    var subjectOrLessonName:String?
    var teacherName: String?
    var amount: Double?
    var date: String?

    enum CodingKeys: String, CodingKey {
        case subjectID = "subjectId"
        case subjectOrLessonName = "subjectName"
        case teacherName, amount, date
    }
    
    init() {
           self.subjectID = nil
           self.subjectOrLessonName = nil
           self.teacherName = nil
           self.amount = nil
           self.date = nil
       }
    
    enum AlternativeCodingKeys: String, CodingKey {
        case lessonName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode all known properties
        subjectID = try? container.decodeIfPresent(Int.self, forKey: .subjectID)
        teacherName = try? container.decodeIfPresent(String.self, forKey: .teacherName)
        amount = try? container.decodeIfPresent(Double.self, forKey: .amount)
        date = try? container.decodeIfPresent(String.self, forKey: .date)

        // Decode the subjectOrLessonName using either "subjectName" or "lessonName"
        if let subjectName = try? container.decodeIfPresent(String.self, forKey: .subjectOrLessonName) {
            subjectOrLessonName = subjectName
        } else {
            let alternativeContainer = try decoder.container(keyedBy: AlternativeCodingKeys.self)
            subjectOrLessonName = try? alternativeContainer.decodeIfPresent(String.self, forKey: .lessonName)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Encode all known properties
        try container.encodeIfPresent(subjectID, forKey: .subjectID)
        try container.encodeIfPresent(teacherName, forKey: .teacherName)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(date, forKey: .date)
        
        // Encode subjectOrLessonName using the appropriate key
        if let subjectOrLessonName = subjectOrLessonName {
            try container.encode(subjectOrLessonName, forKey: .subjectOrLessonName)
        }
    }    
    
}
