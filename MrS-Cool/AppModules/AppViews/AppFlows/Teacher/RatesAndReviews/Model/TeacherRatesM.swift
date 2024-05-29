//
//  TeacherRatesM.swift
//  MrS-Cool
//
//  Created by wecancity on 09/03/2024.
//

import Foundation

//import Foundation

// MARK: - TeacherRateM -
struct TeacherRateM: Codable {
    var items: [RateItem]?
    var totalCount: Int?
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount
    }
}

// MARK: - Item
struct RateItem: Codable , Hashable{
    static func == (lhs: RateItem, rhs: RateItem) -> Bool {
        return lhs.creationDate == rhs.creationDate && lhs.teacherLessonComment == rhs.teacherLessonComment
    }
    var teacherRate: Float?
    var teacherLessonName: String?
    var teacherLessonRate: Float?
    var teacherLessonComment, creationDate: String?
    enum CodingKeys: String, CodingKey {
        case teacherRate
        case teacherLessonName
        case teacherLessonRate
        case teacherLessonComment, creationDate
    }
}

