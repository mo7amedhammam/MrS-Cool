//
//  ExStrings.swift
//  MrS-Cool
//
//  Created by wecancity on 18/10/2023.
//

import Foundation
import UIKit

extension String {
    func removingSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    func reverseSlaches() -> String {
        return self.replacingOccurrences(of: "\\", with: "/")
    }
    
    func openAsURL() {
        var urlString = self.reverseSlaches()
        
        // Ensure the URL starts with a valid scheme
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("Opened URL: \(urlString)")
            } else {
                print("Failed to open URL: \(urlString)")
            }
        }
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
//        formatter.locale = Locale(identifier: local ?? "ar")
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = FormatFrom
        if let date = formatter.date(from: self) {
            formatter.dateFormat = FormatTo
            newdate = formatter.string(from: date)
        }
        return newdate
    }
    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.date(from: self)
    }
    
    func convertTimeToMinutes() -> Int? {
        let components = self.components(separatedBy: ":")
        
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return nil // Invalid time format
        }
        
        let totalMinutes = hours * 60 + minutes
        return totalMinutes
    }
}

extension String {
    func containsNonEnglishOrNumbers() -> Bool {
        let englishLettersAndNumbersCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        // Check if the string contains characters other than English letters and numbers
        return self.rangeOfCharacter(from: englishLettersAndNumbersCharacterSet.inverted) != nil
    }
    
    // Function to validate the password and remove non-English characters or numbers if present
    //     func validatePassword() -> String {
    //        if self.containsNonEnglishOrNumbers() {
    //            // If the password contains non-English characters or numbers, drop the last character
    //            return String(self.dropLast())
    //        } else {
    //            // If the password is valid, return it as is
    //            return self
    //        }
    //    }
}

extension Character {
    var isArabic: Bool {
        // Arabic characters range: 1569-1594, 1601-1610, 1646-1647, 1649-1756
        // Arabic digits range: 1632-1641
        // Arabic special characters range: 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 58, 59, 60, 61, 62, 63, 64, 91, 92, 93, 94, 95, 96, 123, 124, 125, 126
        
        return (1569...1594 ~= unicodeScalars.first?.value ?? 0 ||
                1601...1610 ~= unicodeScalars.first?.value ?? 0 ||
                1646...1647 ~= unicodeScalars.first?.value ?? 0 ||
                1649...1756 ~= unicodeScalars.first?.value ?? 0 ||
                1632...1641 ~= unicodeScalars.first?.value ?? 0 ||
                (32...47 ~= unicodeScalars.first?.value ?? 0) ||
                (58...64 ~= unicodeScalars.first?.value ?? 0) ||
                (91...96 ~= unicodeScalars.first?.value ?? 0) ||
                (123...126 ~= unicodeScalars.first?.value ?? 0))
    }
    
    var isEnglish: Bool {
        // English uppercase range: 65-90
        // English lowercase range: 97-122
        // English digits range: 48-57
        // Common special characters: 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 58, 59, 60, 61, 62, 63, 64, 91, 92, 93, 94, 95, 96, 123, 124, 125, 126
        return (65...90 ~= unicodeScalars.first?.value ?? 0 ||
                97...122 ~= unicodeScalars.first?.value ?? 0 ||
                48...57 ~= unicodeScalars.first?.value ?? 0 ||
                (32...47 ~= unicodeScalars.first?.value ?? 0) ||
                (58...64 ~= unicodeScalars.first?.value ?? 0) ||
                (91...96 ~= unicodeScalars.first?.value ?? 0) ||
                (123...126 ~= unicodeScalars.first?.value ?? 0))
    }
    
}
