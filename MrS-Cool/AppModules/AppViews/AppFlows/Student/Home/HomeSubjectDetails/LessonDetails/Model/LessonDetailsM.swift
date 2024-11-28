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
    var teacherImage, teacherName, teacherBIO, teacherBrief,academicSemesterName,academicEducationLevelName: String?
    var teacherRate,price,individualCost: Float?
    var teacherReview, duration : Int?
    var minGroup, maxGroup, individualDuration: Int?
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
        case academicSemesterName,academicEducationLevelName
    }
}

// MARK: - LessonGroupsDto
struct LessonGroupsDto: Codable,Hashable {
    var teacherLessonSessionID: Int?
    var groupName, date, timeFrom, timeTo: String?
    var groupCost:Float?

    enum CodingKeys: String, CodingKey {
        case teacherLessonSessionID = "teacherLessonSessionId"
        case groupName, date, timeFrom, timeTo
        case groupCost
    }
}

// MARK: - TeacherAvaliableSchedualDto
struct TeacherAvaliableSchedualDto: Codable,Hashable {
    var date, dayName, fromTime, toTime: String?
}

