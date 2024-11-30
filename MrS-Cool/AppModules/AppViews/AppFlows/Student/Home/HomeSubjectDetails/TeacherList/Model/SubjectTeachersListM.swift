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
struct SubjectTeacherM: Codable,Identifiable,Hashable {
    var id: Int?
    var getSubjectOrLessonDto: GetSubjectOrLessonDto?
    var teacherLessonID, teacherSubjectID: Int?
    var teacherImage, teacherName, teacherBIO, teacherBrief: String?
    var teacherRate,price: Float?
    var teacherReview, duration : Int?
    var academicSemesterName, academicEducationLevelName : String?
    var minPrice, maxPrice: Float?
    enum CodingKeys: String, CodingKey {
        case id = "teacherId"
        case getSubjectOrLessonDto
        case teacherLessonID = "teacherLessonId"
        case teacherSubjectID = "teacherSubjectId"
        case teacherImage, teacherName, teacherBIO, teacherBrief, teacherRate, teacherReview, duration, price
        case academicSemesterName, academicEducationLevelName
        case minPrice, maxPrice
    }
}

// MARK: - GetSubjectOrLessonDto -
struct GetSubjectOrLessonDto: Codable,Hashable {
    var image, headerName,subjectName, systemBrief: String?
}
