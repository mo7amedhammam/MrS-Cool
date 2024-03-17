//
//  ParentServices.swift
//  MrS-Cool
//
//  Created by wecancity on 16/03/2024.
//

import Foundation
import Alamofire

enum ParentServices{
    case GetMyChildern
    case CreateChilren(parameters : [String:Any])
}

extension ParentServices:TargetType{
    var path: String {
        switch self {
        case .GetMyChildern:
            return ParentEndPoints.GetMyChildren.rawValue
     
        case .CreateChilren:
            return ParentEndPoints.CreateStudentByParent.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetMyChildern:
            return .get
            
        case .CreateChilren:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetMyChildern:
            return .plainRequest
            
//        case .GetStudentCompletedLessonDetails(parameters: let Parameters):
//            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .CreateChilren(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
