//
//  ExStrings.swift
//  MrS-Cool
//
//  Created by wecancity on 18/10/2023.
//

import Foundation

extension String {
    func removingSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    func reverseSlaches() -> String {
        return self.replacingOccurrences(of: "\\", with: "/")
    }
    func getValidLanguageCode() -> String {
        if self.contains("ar"){
            return "ar"
        }else if self.contains("en"){
            return "en"
        }else{
            return "en"
        }
    }
    
    func CharCountLimit(limit:Int)->String{
        if self.count > limit {
            return String(self.prefix(limit))
        }else{
            return self
        }
    }

    func ChangeDateFormat( FormatFrom:String, FormatTo:String, local:String? = "en" ) -> String {
         var newdate = ""
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: local ?? "ar")
         formatter.dateFormat = FormatFrom
         if let date = formatter.date(from: self) {
             formatter.dateFormat = FormatTo
             newdate = formatter.string(from: date)
         }
      return newdate
       }
}
