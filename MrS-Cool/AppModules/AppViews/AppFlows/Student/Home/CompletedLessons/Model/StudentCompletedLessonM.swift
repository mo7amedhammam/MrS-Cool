//
//  StudentCompletedLessonM.swift
//  MrS-Cool
//
//  Created by wecancity on 20/02/2024.
//

import Foundation


// MARK: - CompletedLessonsM
struct StudentCompletedLessonM: Codable {
    var items: [StudentCompletedLessonItemM]?
    var totalCount: Int?
}
// MARK: - StudentCompletedLessonM -
struct StudentCompletedLessonItemM: Codable ,Hashable,Identifiable{
    var id,teacherLessonId: Int?
    var subject,teacherName,lessonname,groupName,date,startTime,endTime: String?
    var attendance,isRated: Bool?
    var bookSessionDetailId: Int?

    enum CodingKeys: String, CodingKey {
        case id = "studentId"
        case teacherLessonId = "teacherLessonId"
        case lessonname = "lessonname"
        case subject,teacherName, groupName, date, startTime, endTime
        case attendance,bookSessionDetailId,isRated
    }
}

// MARK: - StudentCompletedLessonDetailsM -
struct StudentCompletedLessonDetailsM: Codable {
    var subjectName,lessonName,groupName,subjectBrief,lessonBrief:String?
    var educationTypeName,educationLevelName,academicYearName,subjectSemesterYearName: String?
    var teacherLessonId : Int?
    var teacherLessonMaterials: [StudentCompletedLessonMaterialM]?

    enum CodingKeys: String, CodingKey {
        case subjectName,lessonName,groupName,subjectBrief,lessonBrief
        case educationTypeName,educationLevelName,academicYearName,subjectSemesterYearName
        case teacherLessonId
        case teacherLessonMaterials = "teacherLessonMaterialDtos"
    }
}

// MARK: - studentCompletedLessonStudentList -
struct StudentCompletedLessonMaterialM: Codable ,Hashable,Identifiable{
    
    var name,materialUrl,materialTypeName,nameEn: String?
    var id,teacherLessonId,materialTypeId : Int?
    
    enum CodingKeys: String, CodingKey {
        case name,materialUrl,materialTypeName,nameEn
        case id,teacherLessonId,materialTypeId
    }
}

