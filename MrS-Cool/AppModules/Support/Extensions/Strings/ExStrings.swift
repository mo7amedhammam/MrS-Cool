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
    func getValidLanguageCode() -> String {
        if self.contains("ar"){
            return "ar"
        }else if self.contains("en"){
            return "en"
        }else{
            return "en"
        }
    }
}
