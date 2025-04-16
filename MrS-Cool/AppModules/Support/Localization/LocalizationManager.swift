//
//  LocalizationManager.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/03/2025.
//

import Foundation

//struct LocalizationManager {
//    static let shared = LocalizationManager()
//    private let translationsKey = "dynamic_translations"
//    
//    // Save translations in UserDefaults
//    func saveTranslations(_ translations: [String: String]) {
//        UserDefaults.standard.set(translations, forKey: translationsKey)
//    }
//    
//    // Retrieve saved translations
//    func getTranslations() -> [String: String] {
//        return UserDefaults.standard.dictionary(forKey: translationsKey) as? [String: String] ?? [:]
//    }
//    
//    // Get translation for a key (fallback to default Localizable.strings)
//    func localizedString(forKey key: String) -> String {
//        let translations = getTranslations()
//        return translations[key] ?? NSLocalizedString(key, comment: "")
//    }
//    
//     func fetchTranslations(language: String,completion: @escaping (Bool) -> Void) {
//        let urlString = "https://alnada-devmrsapi.azurewebsites.net/api/\(language)/Translations/GetTranslationFile/ios"
//        
//        guard let url = URL(string: urlString) else {
//            completion(false)
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(false)
//                return
//            }
//            
//            do {
//                let translations = try JSONDecoder().decode([String: String].self, from: data)
//                self.saveTranslations(translations)
//                completion(true)
//            } catch {
//                completion(false)
//            }
//            
//        }.resume()
//    }
//}




class LocalizationManager {
    static let shared = LocalizationManager()
    
    private let queue = DispatchQueue(label: "com.yourapp.localization", attributes: .concurrent)
    private var translations: [String: String] = [:]
    private var currentLanguage: String = "en" // Default language
    
    private init() {}
    
    func setLanguage(_ language: String, completion: @escaping (Bool) -> Void) {
        currentLanguage = language
        fetchTranslations { success in
            completion(success)
        }
    }
    
    func localizedString(forKey key: String) -> String {
        queue.sync {
            return translations[key] ?? key
        }
    }
    
    private func cacheTranslations(_ translations: [String: String], for language: String) {
        queue.async(flags: .barrier) {
            UserDefaults.standard.set(translations, forKey: "cachedTranslations_\(language)")
        }
    }

    private func loadCachedTranslations(for language: String) -> [String: String]? {
        queue.sync {
            return UserDefaults.standard.dictionary(forKey: "cachedTranslations_\(language)") as? [String: String]
        }
    }
    
    private func loadDefaultTranslations() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] else {
            return [:]
        }
        return dictionary
    }
    
    private func fetchTranslations(completion: @escaping (Bool) -> Void) {
//        if let cachedTranslations = loadCachedTranslations(for: currentLanguage){
//            self.updateTranslations(cachedTranslations)
//            completion(true)
//            return
//        }
        let urlString = Constants.baseURL + "api/\(currentLanguage)/Translations/GetTranslationFile/ios"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            self.updateTranslations(self.loadDefaultTranslations())
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching translations: \(error.localizedDescription)")
                self.updateTranslations(self.loadDefaultTranslations())
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.updateTranslations(self.loadDefaultTranslations())
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    print("Localization updated for : \(self.currentLanguage)")
                    self.updateTranslations(json)
                    self.cacheTranslations(json, for: self.currentLanguage)
                    completion(true)
                } else {
                    print("Invalid JSON format")
                    self.updateTranslations(self.loadDefaultTranslations())
                    completion(false)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                self.updateTranslations(self.loadDefaultTranslations())
                completion(false)
            }
        }.resume()
    }
    
    private func updateTranslations(_ newTranslations: [String: String]) {
        queue.async(flags: .barrier) {
            print("newTranslations",newTranslations)
            self.translations = newTranslations
        }
    }
}

import Foundation

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(forKey: self)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
