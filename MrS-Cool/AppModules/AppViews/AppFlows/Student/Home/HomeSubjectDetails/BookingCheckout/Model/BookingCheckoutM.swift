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
    var numOfLessons:Int?
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
    var paymentId:Int?
    var withoutPaymentGateway: Bool?

    enum CodingKeys: String, CodingKey {
        case studentID = "studentId"
        case teacherlessonsessionID = "teacherlessonsessionId"
        case bookTeacherLessonSessionID = "bookTeacherLessonSessionId"
        case paymentURL = "paymentUrl"
        case amount
        case paymentId,withoutPaymentGateway
    }
}

// MARK: - OfflinePaymentM
struct OfflinePaymentM: Codable {
    var teacherlessonsessionID, bookTeacherlessonsessionID, studentID, parentID: Int?
    var amount: Int?
    var paid: Bool?
    var language, sessionID: String?
    var appCountryID: Int?
    var orderID, merchantReferenceID: String?
    var rate, paymentGatewayID, statusID: Int?
    var paymentURL: String?
    var withoutPaymentGateway: Bool?

    enum CodingKeys: String, CodingKey {
        case teacherlessonsessionID = "teacherlessonsessionId"
        case bookTeacherlessonsessionID = "bookTeacherlessonsessionId"
        case studentID = "studentId"
        case parentID = "parentId"
        case amount, paid, language
        case sessionID = "sessionId"
        case appCountryID = "appCountryId"
        case orderID = "orderId"
        case merchantReferenceID = "merchantReferenceId"
        case rate
        case paymentGatewayID = "paymentGatewayId"
        case statusID = "statusId"
        case paymentURL = "paymentUrl"
        case withoutPaymentGateway
    }
}
