//
//  BookingCheckoutM.swift
//  MrS-Cool
//
//  Created by wecancity on 03/02/2024.
//

import Foundation

// MARK: - BookingCheckoutM -
//struct BookingCheckoutM: Codable {
//    var headerName, teacherName, lessonOrSubjectBrief, bookType: String?
//    var price, currentBalance: Float?
//    var startDate, endDate, fromTime, timeTo: String?
//    var bookSchedules: [bookSchedules]?
//
//    enum CodingKeys: String, CodingKey {
//        case headerName = "headerName"
//        case teacherName = "teacherName"
//        case lessonOrSubjectBrief = "lessonOrSubjectBrief"
//        case bookType = "bookType"
//        case price, currentBalance, startDate, endDate, fromTime, timeTo, bookSchedules
//    }
//}

// MARK: - BookingCheckoutM
struct BookingCheckoutM: Codable {
    var headerName, subjectSemesterName, academicYearName, teacherName: String?
    var lessonOrSubjectBrief, bookType, duration: String?
    var price, currentBalance: Float?
    var startDate, endDate, fromTime, toTime,image : String?
    var paymentAmount, taxAmount, totalPriceWithTax: Float?
    var bookSchedules: [BookSchedule]?
}



// MARK: - BookSchedule -
struct BookSchedule: Codable, Hashable {
    var dayName, fromTime: String?

    enum CodingKeys: String, CodingKey {
        case dayName = "dayName"
        case fromTime = "fromTime"
    }
}

// MARK: - BookingCreateM
struct BookingCreateM: Codable {
    var studentID, teacherlessonsessionID, bookTeacherLessonSessionID: Int?
    var paymentURL: String?
    var amount: Float?

    enum CodingKeys: String, CodingKey {
        case studentID = "studentId"
        case teacherlessonsessionID = "teacherlessonsessionId"
        case bookTeacherLessonSessionID = "bookTeacherLessonSessionId"
        case paymentURL = "paymentUrl"
        case amount
    }
}
