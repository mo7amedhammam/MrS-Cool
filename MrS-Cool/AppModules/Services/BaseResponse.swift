//
//  BaseResponse.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import Foundation
    
struct BaseResponse<T:Codable> : Codable {
        let id : String?
        let message: String?
        let messageCode: Int?
        let data: T?
        let success: Bool?

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case message = "message"
            case messageCode = "messageCode"
            case data = "data"
            case success = "success"
        }
    
    init() {
        self.id = ""
        self.message = ""
        self.messageCode = 0
        self.success = false
        self.data = T.self as? T
    }
}


//public enum StateHandler:Equatable {
//    case none
//    case loading
//    case stopLoading
//    case success
//    case error(Int?=0,String?)
//}
