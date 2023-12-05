//
//  Exdates.swift
//  MrS-Cool
//
//  Created by wecancity on 05/12/2023.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
}
