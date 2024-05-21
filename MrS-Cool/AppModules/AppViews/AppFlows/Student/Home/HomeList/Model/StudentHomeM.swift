//
//  StudentHomeM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/01/2024.
//

import Foundation
// MARK: - SubjectGroupM - for loged in student
struct StudentSubjectsM: Codable {
    var studentId: Int?
    var academicLevelName: String?
    var subjects: [HomeSubject]?
}

// MARK: - SubjectGroupM - for loged in student
struct HomeSubject: Codable,Hashable {
//    static func == (lhs: HomeSubject, rhs: HomeSubject) -> Bool {
//        return lhs.id == rhs.id && lhs.name == rhs.name
//    }
    var id: Int?
    var name, image: String?
    var teacherSubject: teacherTitle?

    enum CodingKeys: String, CodingKey {
        case id
        case  name, image
        case teacherSubject
    }
}

// MARK: - AnonymousallSubjectM - for anonymous
struct AnonymousallSubjectM: Codable {
    var academicLevelName: String?
    var getAllSubjects: [GetAllSubject]?
}

// MARK: - GetAllSubject - for anonymous
struct GetAllSubject: Codable {
    var id: Int?
    var name, image, systemBrief: String?
    var availableTeacherCount,lessonsCount: Int?
    var academicEducationLevelName, academicSemesterName: String?
    var minPrice, maxPrice: Float?
}

// MARK: - mostviewedlessons -
struct StudentMostViewedLessonsM: Codable,Hashable {
    var id: Int?
    var lessonName, subjectName,lessonBrief: String?
    var availableTeacher:Int?
    var minPrice,maxPrice: Float?
    enum CodingKeys: String, CodingKey {
        case id = "lessonId"
        case  lessonName, subjectName
        case availableTeacher,minPrice,maxPrice,lessonBrief
    }
}

// MARK: - mostviewedSubjects -
struct StudentMostViewedSubjectsM: Codable,Hashable {
    var id: Int?
    var subjectName, image,subjectBrief: String?
    var lessonsCount,teacherCount: Int?
    enum CodingKeys: String, CodingKey {
        case id = "subjectId"
        case subjectName, image
        case lessonsCount,teacherCount,subjectBrief
    }
}

// MARK: - mostviewedTeachers -
struct StudentMostViewedTeachersM: Codable,Hashable {
    var id: Int?
    var teacherName, teacherImage: String?
    var teacherLessonId,teacherSubjectId,duration,teacherReview: Int?
    var teacherRate, price : Float?
    enum CodingKeys: String, CodingKey {
        case id = "teacherId"
        case teacherName, teacherImage
        case teacherLessonId,teacherSubjectId,teacherReview,duration,price
        case teacherRate
    }
}

