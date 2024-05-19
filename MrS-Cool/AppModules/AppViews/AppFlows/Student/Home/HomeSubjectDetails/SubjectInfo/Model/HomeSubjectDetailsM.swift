//
//  HomeSubjectDetailsM.swift
//  MrS-Cool
//
//  Created by wecancity on 15/01/2024.
//

//import Foundation

// MARK: - StudentHomeSubjectDetailsM -
struct StudentHomeSubjectDetailsM: Codable,Hashable {
    var id: Int?
    var name, image, systemBrief: String?
    var availableTeacherCount,lessonsCount: Int?
    var minPrice, maxPrice: Float?
    var getSubjectLessonsDetailsDtoList: [GetSubjectLessonsDetailsDtoList]?
    var unitLessonDtoList: [UnitLessonDtoList]?
}

// MARK: - GetSubjectLessonsDetailsDtoList -
struct GetSubjectLessonsDetailsDtoList: Codable,Hashable {
    var unitName: String?
    var lessonsCount: Int?
    var unitLessonDtoList: [UnitLessonDtoList]?
}

// MARK: - UnitLessonDtoList -
struct UnitLessonDtoList: Codable,Hashable {
    var lessonID: Int?
    var lessonName, unitName: String?
    var unitID, availableTeacherCount: Int?
    var minPrice, maxPrice: Float?
    enum CodingKeys: String, CodingKey {
        case lessonID = "lessonId"
        case lessonName, unitName
        case unitID = "unitId"
        case availableTeacherCount, minPrice, maxPrice
    }
}
