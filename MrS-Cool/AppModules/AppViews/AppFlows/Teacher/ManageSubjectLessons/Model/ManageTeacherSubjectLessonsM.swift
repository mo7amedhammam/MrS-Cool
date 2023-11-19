//
//  ManageTeacherSubjectLessonsM.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import Foundation

// MARK: - ManageTeacherSubjectLessonsM -
struct ManageTeacherSubjectLessonsM: Codable,Identifiable {
    var id = UUID()
    
    var unitName: String?
    var teacherUnitLessons: [TeacherUnitLesson]?
}

// MARK: - TeacherUnitLesson -
struct TeacherUnitLesson: Codable ,Identifiable{
    var lessonID, groupCost, groupDuration, individualCost: Int?
    var individualDuration: Int?
    var teacherBrief: String?
    var id: Int?
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String?
    var teacherID: Int?
    var lessonName: String?
    var defaultGroupCost, defaultGroupDuration, defaultIndividualCost, defaultIndividualDuration: Int?

    enum CodingKeys: String, CodingKey {
        case lessonID = "lessonId"
        case groupCost, groupDuration, individualCost, individualDuration, teacherBrief, id, educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName
        case teacherID = "teacherId"
        case lessonName, defaultGroupCost, defaultGroupDuration, defaultIndividualCost, defaultIndividualDuration
    }
}
