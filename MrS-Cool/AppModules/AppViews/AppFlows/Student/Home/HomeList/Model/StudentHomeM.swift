//
//  StudentHomeM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/01/2024.
//

import Foundation

// MARK: - SubjectGroupM -
struct StudentSubjectsM: Codable,Hashable {
    var id: Int?
    var name, image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case  name, image
    }
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

