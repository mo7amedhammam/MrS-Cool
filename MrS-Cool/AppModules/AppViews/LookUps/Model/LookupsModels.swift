//
//  LookupsModels.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Foundation

// MARK: - GendersM - Countries - Academic Year - Subject -
struct GendersM: Codable {
    var id: Int?
    var name: String?
}

// MARK: - GovernorateM -
struct GovernorateM: Codable {
    var name: String?
    var countryID, id: Int?
    var countryName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case countryID = "countryId"
        case id, countryName
    }
}

// MARK: - CityM -
struct CityM: Codable {
    var name: String?
    var governorateID, id: Int?
    var governorateName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case governorateID = "governorateId"
        case id, governorateName
    }
}


// MARK: - EducationTypeM -
struct EducationTypeM: Codable {
    var name: String?
    var order, id: Int?
}


// MARK: - EducationLevellM -
struct EducationLevellM: Codable {
    var id: Int?
    var name, educationTypeName: String?
}

// MARK: - DocumentTypeM -
struct DocumentTypeM: Codable {
    var name: String?
    var isRequired: Bool?
    var order, id: Int?
}

// MARK: - Subject For List M -
struct SubjectForListM: Codable {
    var  id: Int?
    var subjectDisplayName: String?
    var groupSessionCost:Float?
}
// MARK: - Lesson For List M -
struct LessonForListM: Codable,Hashable {
        static func == (lhs: LessonForListM, rhs: LessonForListM) -> Bool {
            return lhs.id == rhs.id
        }
    var id,groupDuration: Int?
    var lessonName: String?
    var count,order: Int?
}

extension LessonForListM{
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = id
        dictionary["groupDuration"] = groupDuration
        dictionary["lessonName"] = lessonName
        dictionary["count"] = count
        dictionary["order"] = order
        return dictionary
    }
}


// MARK: - AcademicSemesterM -
struct AcademicSemesterM: Codable {
    var id, createdByID: Int?
    var createdByName, creationDate, name, startDate: String?
    var endDate: String?
    var order: Int?
    var isSystem: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case createdByID = "createdById"
        case createdByName, creationDate, name, startDate, endDate, order, isSystem
    }
}

// MARK: - st booked subjects list -
struct BookedStudentSubjectsM: Codable {
    var id: Int?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id = "subjectId"
        case name = "subjectName"
    }
}

// MARK: - st booked Lessons list -
struct BookedStudentLessonsM: Codable {
    var id: Int?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id = "lessonId"
        case name = "lessonName"
    }
}
