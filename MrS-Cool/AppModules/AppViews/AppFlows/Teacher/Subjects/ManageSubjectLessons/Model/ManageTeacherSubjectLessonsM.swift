//
//  ManageTeacherSubjectLessonsM.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import Foundation

// MARK: - ManageTeacherSubjectLessonsM
struct ManageTeacherSubjectLessonsM: Codable, Hashable {
    static func == (lhs: ManageTeacherSubjectLessonsM, rhs: ManageTeacherSubjectLessonsM) -> Bool {
        return lhs.unitName == rhs.unitName && lhs.teacherUnitLessons == rhs.teacherUnitLessons
    }
     
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String?
    var unitName: String?
    var teacherUnitLessons: [TeacherUnitLesson]?
}

// MARK: - TeacherUnitLesson
struct TeacherUnitLesson: Codable,Hashable {
    static func == (lhs: TeacherUnitLesson, rhs: TeacherUnitLesson) -> Bool {
        return lhs.lessonID == rhs.lessonID && lhs.lessonName == rhs.lessonName
    }
    var id: Int?
    var teacherID: Int?
    var lessonName: String?
    var defaultGroupCost,groupCost: Float?
    var defaultIndividualCost,individualCost: Float?
    var defaultIndividualDuration, defaultGroupDuration: Int?
    var lessonID,minGroup,maxGroup : Int?
    var individualDuration,groupDuration: Int?
    var teacherBrief,teacherBriefEn: String?
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String? //not in api but edded to handle design

    enum CodingKeys: String, CodingKey {
        case id
        case teacherID = "teacherId"
        case lessonName, defaultGroupCost, defaultGroupDuration, defaultIndividualCost, defaultIndividualDuration
        case lessonID = "lessonId",minGroup,maxGroup
        case groupCost, groupDuration, individualCost, individualDuration, teacherBrief, teacherBriefEn

        case educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName  //not in api but edded to handle design
    }
}

// MARK: - UpdatedTeacherSubjectLessonsM -
struct UpdatedTeacherSubjectLessonsM: Codable {
    var lessonID: Int?
    var groupCost, individualCost: Float?
    var individualDuration,groupDuration: Int?
    var teacherBrief: String?
    var id, teacherSubjectAcademicSemesterYearID: Int?

    enum CodingKeys: String, CodingKey {
        case lessonID = "lessonId"
        case groupCost, groupDuration, individualCost, individualDuration, teacherBrief, id
        case teacherSubjectAcademicSemesterYearID = "teacherSubjectAcademicSemesterYearId"
    }
}

// MARK: - SubjecLessonBriefM -
struct SubjecLessonBriefM: Codable {
    var teacherBrief: String?
    var teacherBriefEn: String?
    var id: Int?
}
