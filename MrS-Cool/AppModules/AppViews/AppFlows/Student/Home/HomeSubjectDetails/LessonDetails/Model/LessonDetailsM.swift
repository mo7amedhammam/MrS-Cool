//
//  LessonDetailsM.swift
//  MrS-Cool
//
//  Created by wecancity on 30/01/2024.
//

import Foundation

// MARK: - TeacherLessonDetailsM
struct TeacherLessonDetailsM: Codable {
    var SubjectOrLessonDto: SubjectOrLessonDto?
    var teacherID, teacherLessonID, teacherSubjectID: Int?
    var teacherImage, teacherName, teacherBIO, teacherBrief: String?
    var teacherRate: Float?
    var teacherReview, duration, price: Int?
    var minGroup, maxGroup, individualCost, individualDuration: Int?
    var LessonGroupsDto: [LessonGroupsDto]?
    var teacherRateDto: TeacherRateDto?
    var TeacherAvaliableSchedualDtos: [TeacherAvaliableSchedualDto]?

    enum CodingKeys: String, CodingKey {
        case SubjectOrLessonDto = "getSubjectOrLessonDto"
        case teacherID = "teacherId"
        case teacherLessonID = "teacherLessonId"
        case teacherSubjectID = "teacherSubjectId"
        case teacherImage, teacherName, teacherBIO, teacherBrief, teacherRate, teacherReview, duration, price, minGroup, maxGroup, individualCost, individualDuration
        case LessonGroupsDto = "getLessonGroupsDto"
        case teacherRateDto
        case TeacherAvaliableSchedualDtos = "getTeacherAvaliableSchedualDtos"
    }
}

// MARK: - LessonGroupsDto
struct LessonGroupsDto: Codable,Hashable {
    var teacherLessonSessionID: Int?
    var groupName, date, timeFrom, timeTo: String?

    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionID = "teacherLessonSessionId"
        case groupName, date, timeFrom, timeTo
    }
}

// MARK: - TeacherAvaliableSchedualDto
struct TeacherAvaliableSchedualDto: Codable,Hashable {
    var date, dayName, fromTime, toTime: String?
}

