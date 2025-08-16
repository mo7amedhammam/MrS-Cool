//
//  ExStrings.swift
//  MrS-Cool
//
//  Created by wecancity on 18/10/2023.
//

import Foundation
import UIKit

enum SupportedLocale: String {
    case current
    case english = "en_US"
    case arabic = "ar_EG"
//    case french = "fr_FR"
//    case german = "de_DE"
//    case spanish = "es_ES"
    // Add more cases as needed

    var locale: Locale {
        switch self {
        case .current:
            return Locale.current

         default:
            return Locale(identifier: self.rawValue)

        }
    }
}

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
    
//    func ChangeDateFormat( FormatFrom:String, FormatTo:String, local:Locale? = .current,timeZone:TimeZone? = .current) -> String {
//        var newdate = ""
//        let formatter = DateFormatter()
////        formatter.locale = Locale(identifier: local ?? "en_US")
////        formatter.timeZone = TimeZone(identifier: "GMT")
//        formatter.locale = local ?? .current
//        formatter.timeZone = timeZone ?? .current
//        formatter.dateFormat = FormatFrom
//        if let date = formatter.date(from: self) {
//            formatter.dateFormat = FormatTo
//            newdate = formatter.string(from: date)
//        }
//        return newdate
//    }
    
//    func ChangeDateFormat(
//        FormatFrom: String
//        , FormatTo: String
//        , inputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english:.arabic
//        , outputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english:.arabic
//        , inputTimeZone: TimeZone? = appTimeZone
//        , outputTimeZone: TimeZone? = appTimeZone
//    ) -> String {
////        let formatter = DateFormatter()
//        let formatter = DateFormatter.cachedFormatter
//
//        formatter.locale = inputLocal?.locale ?? .current
//        formatter.timeZone = inputTimeZone ?? .current
//        formatter.dateFormat = FormatFrom
//        
////        print("Original String: \(self)")
////        print("Formatter Locale: \(formatter.locale?.identifier ?? "nil")")
////        print("Formatter TimeZone: \(formatter.timeZone?.identifier ?? "nil")")
//        
//        // Add this to help parsing ambiguous/invalid DST dates
//        formatter.isLenient = true
//
////        guard let date = formatter.date(from: self) else {
////            print("Failed to parse date")
////            return self
////        }
//        guard let date = formatter.date(from: self) else {
//            print("❌ Failed to parse date: '\(self)' with format: '\(FormatFrom)'")
//            print("Expected format example: \(formatter.string(from: Date()))")
//            return self
//        }
//        
//        formatter.locale = outputLocal?.locale ?? SupportedLocale.english.locale
//        formatter.timeZone = outputTimeZone ?? .current
//        formatter.dateFormat = FormatTo
//        let newDate = formatter.string(from: date)
////        print("Formatted Date: \(newDate)")
//        return newDate
//    }
    
        func ChangeDateFormat(
            FormatFrom inputFormat: String,
            FormatTo outputFormat: String,
            inputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english:.arabic,
            outputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english:.arabic,
            inputTimeZone: TimeZone = appTimeZone,
            outputTimeZone: TimeZone = appTimeZone
        ) -> String {
            let inputFormatter = DateFormatter.cachedFormatter
            inputFormatter.dateFormat = inputFormat
            inputFormatter.timeZone = inputTimeZone
            inputFormatter.locale = inputLocal?.locale
            inputFormatter.isLenient = true
            guard let date = inputFormatter.date(from: self) else {
                print("❌ Failed to parse date: '\(self)' with format: '\(inputFormat)'")
                print("Expected format example: \(inputFormatter.string(from: Date()))")
                return self
            }
    
            let outputFormatter = DateFormatter.cachedFormatter
            outputFormatter.dateFormat = outputFormat
            outputFormatter.timeZone = outputTimeZone
            outputFormatter.locale = outputLocal?.locale
            outputFormatter.isLenient = true
    
            let result = outputFormatter.string(from: date)
            print("✅ Date conversion: '\(self)' -> '\(result)'")
            return result
        }
    
    
//    func toDate(withFormat format: String, inputTimeZone: TimeZone? = appTimeZone, inputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english : .arabic, outputTimeZone: TimeZone? = appTimeZone, outputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english : .arabic) -> Date? {
////        let dateFormatter = DateFormatter()
//        let dateFormatter = DateFormatter.cachedFormatter
//        // Add this to help parsing ambiguous/invalid DST dates
//        dateFormatter.isLenient = true
//
//        // Set up the input formatter
//        dateFormatter.dateFormat = format
//        dateFormatter.locale = inputLocal?.locale ?? .current
//        dateFormatter.timeZone = inputTimeZone
//        
//        // Parse the date using the input formatter
//        if let date = dateFormatter.date(from: self) {
//            // Set up the output formatter
//            dateFormatter.locale = outputLocal?.locale ?? .current
//            dateFormatter.timeZone = outputTimeZone
//            
//            // Convert the date to the output time zone
//            let dateString = dateFormatter.string(from: date)
//            return dateFormatter.date(from: dateString)
//        }
//        
//        return nil
//    }
    
    func toDate(
        withFormat format: String,
        inputTimeZone: TimeZone? = appTimeZone,
        inputLocal: SupportedLocale? = LocalizeHelper.shared.currentLanguage == "en" ? .english : .arabic
    ) -> Date? {
        let dateFormatter = DateFormatter.cachedFormatter
        dateFormatter.isLenient = true
        dateFormatter.dateFormat = format
        dateFormatter.locale = inputLocal?.locale ?? .current
        dateFormatter.timeZone = inputTimeZone
        return dateFormatter.date(from: self)
    }

    
    
    func toDate() -> Date? {
//        let dateFormatter = DateFormatter()
        let dateFormatter = DateFormatter.cachedFormatter

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.timeZone = appTimeZone
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
        let englishLettersAndNumbersCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:'\",.<>?/`~")
        
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
    
    func splitBy(separatedBy:String) -> [String] {
        return self.components(separatedBy: separatedBy)
    }

     func isValidURL() -> Bool {
        // Check if the string can be converted to a valid URL
//        guard let url = URL(string: self), UIApplication.shared.canOpenURL(url) else {
//            return false
//        }
//
//        // Optionally, you can use a regular expression to further validate the URL format
//        let regexPattern = "^(http|https)://[^\\s/$.?#].[^\\s]*$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return predicate.evaluate(with: self)
         
//         let urlRegEx = "(https://)(www\\.)?([-a-zA-Z0-9@:%._+~#=]{1,256}\\.[a-zA-Z0-9()]{2,6}\\b)([-a-zA-Z0-9()@:%_+.~#?&/=]*)"
//         let urlRegEx = "(https://)(www\\.)?([-a-zA-Z0-9@:%._+~#=]{1,256}\\.[a-zA-Z0-9()]{2,6}\\b)([-a-zA-Z0-9()@:%_+.~#?&/=\\\\]*)(\\.pdf|\\.docx|\\.jpg|\\.png|\\.jpeg)$"
//              let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
//              return urlTest.evaluate(with: self)
         
         let regexPattern = #"^(http|https)://(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/\S*)?$"#

         let urlRegex = try! NSRegularExpression(pattern: regexPattern, options: [])
//         let urlString = "https://google.com" // Replace with your URL string

         let range = NSRange(location: 0, length: self.utf16.count)
         return urlRegex.firstMatch(in: self, options: [], range: range) != nil


    }
    /// Removes the last character if it is a comma
    func removingTrailingComma() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        if trimmedString.hasSuffix(",") {
            return String(trimmedString.dropLast())
        } else {
            return trimmedString
        }
    }

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
    var isEnglishNumber: Bool {
          // English digits range: 48-57
          return (48...57 ~= unicodeScalars.first?.value ?? 0)
      }
}
