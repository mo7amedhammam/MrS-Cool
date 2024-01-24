//
//  SubjectTeachersListM.swift
//  MrS-Cool
//
//  Created by wecancity on 24/01/2024.
//

import Foundation

// MARK: - StudentHomeSubjectTeachersListM -
struct StudentHomeSubjectTeachersListM: Codable {
    var items: [SubjectTeacherM]?
    var totalCount: Int?
}

// MARK: - Item -
struct SubjectTeacherM: Codable,Hashable {
    var getSubjectOrLessonDto: GetSubjectOrLessonDto?
    var teacherID, teacherLessonID, teacherSubjectID: Int?
    var teacherImage, teacherName, teacherBIO, teacherBrief: String?
    var teacherRate: Float?
    var teacherReview, duration, price: Int?

    enum CodingKeys: String, CodingKey {
        case getSubjectOrLessonDto
        case teacherID = "teacherId"
        case teacherLessonID = "teacherLessonId"
        case teacherSubjectID = "teacherSubjectId"
        case teacherImage, teacherName, teacherBIO, teacherBrief, teacherRate, teacherReview, duration, price
    }
}

// MARK: - GetSubjectOrLessonDto -
struct GetSubjectOrLessonDto: Codable,Hashable {
    var image, headerName, systemBrief: String?
}
