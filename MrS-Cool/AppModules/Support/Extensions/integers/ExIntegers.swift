//
//  ExIntegers.swift
//  MrS-Cool
//
//  Created by wecancity on 25/10/2023.
//

import Foundation

extension Int{
    func formattedTime() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func formattedHrsMins() -> String {
        let hours = self / 60
        let minutes = self % 60
        return String(format: "%02d hrs, %02d mins", hours, minutes)
    }
    var hours: Int {
          return self / 60
      }

      var minutes: Int {
          return self % 60
      }
}
