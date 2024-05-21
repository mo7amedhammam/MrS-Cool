//
//  TeacherInfoM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/03/2024.
//

import Foundation

// MARK: - TeacherInfoM -
struct TeacherInfoM: Codable,Hashable {
    var totalReviews: Int?
    var teacherName, teacherBIO: String?
    var teacherRate: Float?
    var teacherImage: String?
    var teacherRatePercents: [TeacherRatePercent]?
    var subjects: [Subject]?
}

// MARK: - Subject -
struct Subject: Codable,Hashable {
    var subjectImage, subjectEducationType, subjectAcademicYear, subjectName: String?
    var subjectLevel: String?
}

// MARK: - TeacherRatePercent -
struct TeacherRatePercent: Codable,Hashable {
    var rateNumber, ratePercents: Float?
}

extension Array where Element == Subject {
    func convertToStudentSubjectsM() -> [HomeSubject] {
        return self.map { subject in
            return HomeSubject(id: 0, name: subject.subjectName, image: subject.subjectImage,teacherSubject: teacherTitle(subjectAcademicYear: subject.subjectAcademicYear,subjectLevel: subject.subjectLevel))
        }
    }
}
