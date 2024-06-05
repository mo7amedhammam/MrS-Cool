//
//  ManageLessonMaterialM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/11/2023.
//

//import Foundation


// MARK: - GetLessonMaterialM -
struct GetLessonMaterialM: Codable {
    var teacherLessonMaterialBasicData: TeacherLessonMaterialBasicData?
    var teacherLessonMaterialDtos: [TeacherLessonMaterialDto]?
}

// MARK: - TeacherLessonMaterialBasicData -
struct TeacherLessonMaterialBasicData: Codable, Hashable {
    var educationTypeName, educationLevelName, academicYearName, subjectSemesterYearName: String?
    var lessonName: String?
}

// MARK: - TeacherLessonMaterialDto -
struct TeacherLessonMaterialDto: Codable,Hashable,Identifiable {
    var name: String?
    var teacherLessonID, materialTypeID: Int?
    var materialURL, materialTypeName: String?
    var id: Int?
    var nameEn: String?

    enum CodingKeys: String, CodingKey {
        case name
        case teacherLessonID = "teacherLessonId"
        case materialTypeID = "materialTypeId"
        case materialURL = "materialUrl"
        case materialTypeName, id, nameEn
    }
}

// MARK: - CreateLessonMaterialM
struct CreateLessonMaterialM: Codable {
    var name: String?
    var teacherLessonID, materialTypeID: Int?
    var materialURL, nameEn: String?
//    var materialFile: String?

    enum CodingKeys: String, CodingKey {
        case name
        case teacherLessonID = "teacherLessonId"
        case materialTypeID = "materialTypeId"
        case materialURL = "materialUrl"
        case nameEn
//        case materialFile
    }
}
