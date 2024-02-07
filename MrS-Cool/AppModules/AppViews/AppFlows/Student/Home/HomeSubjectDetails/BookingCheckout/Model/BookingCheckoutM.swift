//
//  BookingCheckoutM.swift
//  MrS-Cool
//
//  Created by wecancity on 03/02/2024.
//

import Foundation

// MARK: - BookingCheckoutM -
struct BookingCheckoutM: Codable {
    var headerName, teacherName, lessonOrSubjectBrief, bookType: String?
    var price, currentBalance: Int?
    var startDate, endDate, fromTime, timeTo: String?
    var bookSchedules: [bookSchedules]?

    enum CodingKeys: String, CodingKey {
        case headerName = "headerName"
        case teacherName = "teacherName"
        case lessonOrSubjectBrief = "lessonOrSubjectBrief"
        case bookType = "bookType"
        case price, currentBalance, startDate, endDate, fromTime, timeTo, bookSchedules
    }
}


// MARK: - bookSchedules -
struct bookSchedules: Codable, Hashable {
    var dayName, fromTime: String?

    enum CodingKeys: String, CodingKey {
        case dayName = "dayName"
        case fromTime = "fromTime"
    }
}
