//
//  TeacherRatesM.swift
//  MrS-Cool
//
//  Created by wecancity on 09/03/2024.
//

//import Foundation

// MARK: - TeacherRateM -
struct TeacherRateM: Codable,Hashable {
    var items: [RateItem]?
    var totalCount: Int?
}

// MARK: - Item
struct RateItem: Codable, Hashable {
    static func == (lhs: RateItem, rhs: RateItem) -> Bool {
        return lhs.creationDate == rhs.creationDate && lhs.teacherLessonComment == rhs.teacherLessonComment
    }
    var teacherRate: Float?
    var teacherLessonName: String?
    var teacherLessonRate: Float?
    var teacherLessonComment, creationDate: String?
}

