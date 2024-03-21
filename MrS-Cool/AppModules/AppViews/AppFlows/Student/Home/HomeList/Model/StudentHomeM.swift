//
//  StudentHomeM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/01/2024.
//

import Foundation

// MARK: - SubjectGroupM - for loged in student
struct StudentSubjectsM: Codable,Hashable {
    var id: Int?
    var name, image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case  name, image
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
    var availableTeacherCount: Int?
    var academicEducationLevelName, academicSemesterName: String?
    var minPrice, maxPrice, lessonsCount: Int?
}

// MARK: - mostviewedlessons -
struct StudentMostViewedLessonsM: Codable,Hashable {
    var id: Int?
    var lessonName, subjectName,lessonBrief: String?
    var availableTeacher,minPrice,maxPrice: Int?
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
    var teacherLessonId,teacherSubjectId,duration,teacherReview,price: Int?
    var teacherRate : Float?
    enum CodingKeys: String, CodingKey {
        case id = "teacherId"
        case teacherName, teacherImage
        case teacherLessonId,teacherSubjectId,teacherReview,duration,price
        case teacherRate
    }
}

