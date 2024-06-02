//
//  SubjectDetailsM.swift
//  MrS-Cool
//
//  Created by wecancity on 27/01/2024.
//

//import Foundation

// MARK: - TeacherSubjectDetailsM -
struct TeacherSubjectDetailsM: Codable {
    var SubjectOrLessonDto: SubjectOrLessonDto?
    var teacherID, teacherLessonID, teacherSubjectID: Int?
    var teacherImage, teacherName, teacherBIO, teacherBrief: String?
    var teacherRate,price : Float?
    var teacherReview, duration : Int?
    var lessonsCount, minGroup, maxGroup: Int?
    var SubjectGroups: [SubjectGroup]?
    var teacherRateDto: TeacherRateDto?

    enum CodingKeys: String, CodingKey {
        case SubjectOrLessonDto = "getSubjectOrLessonDto"
        case teacherID = "teacherId"
        case teacherLessonID = "teacherLessonId"
        case teacherSubjectID = "teacherSubjectId"
        case teacherImage, teacherName, teacherBIO, teacherBrief, teacherRate, teacherReview, duration, price, lessonsCount, minGroup, maxGroup
        case SubjectGroups = "getSubjectGroups"
        case teacherRateDto
    }
}

// MARK: - SubjectGroup
struct SubjectGroup: Codable,Hashable {
    var teacherLessonSessionID: Int?
    var groupName, startDate, endDate: String?
    var getSubjectScheduleGroups: [SubjectScheduleGroup]?

    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionID = "teacherLessonSessionId"
        case groupName, startDate, endDate, getSubjectScheduleGroups
    }
}

// MARK: - SubjectScheduleGroup
struct SubjectScheduleGroup: Codable,Hashable {
    var dayName, fromTime: String?
}

// MARK: - GetSubjectOrLessonDto
struct SubjectOrLessonDto: Codable {
    var image, headerName, subjectName, systemBrief: String?
}

// MARK: - TeacherRateDto
struct TeacherRateDto: Codable {
    var teacherRate: Int?
    var ratePercents: [RatePercent]?
}

// MARK: - RatePercent
struct RatePercent: Codable {
    var rateNumber: Int?
    var ratePercent: Float?
}



