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
        return lhs.unitName == rhs.unitName
    }
    
    var unitName: String?
    var teacherUnitLessons: [TeacherUnitLesson]?
}

// MARK: - TeacherUnitLesson
struct TeacherUnitLesson: Codable,Hashable {
    static func == (lhs: TeacherUnitLesson, rhs: TeacherUnitLesson) -> Bool {
        return lhs.lessonID == rhs.lessonID
    }
    var id: Int?
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String?
    var teacherID: Int?
    var lessonName: String?
    var defaultGroupCost: Double?
    var defaultGroupDuration: Int?
    var defaultIndividualCost: Double?
    var defaultIndividualDuration, lessonID, groupCost, groupDuration: Int?
    var individualCost, individualDuration: Int?
    var teacherBrief: String?

    enum CodingKeys: String, CodingKey {
        case id, educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName
        case teacherID = "teacherId"
        case lessonName, defaultGroupCost, defaultGroupDuration, defaultIndividualCost, defaultIndividualDuration
        case lessonID = "lessonId"
        case groupCost, groupDuration, individualCost, individualDuration, teacherBrief
    }
}

// MARK: - UpdatedTeacherSubjectLessonsM -
struct UpdatedTeacherSubjectLessonsM: Codable {
    var lessonID, groupCost, groupDuration, individualCost: Int?
    var individualDuration: Int?
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
