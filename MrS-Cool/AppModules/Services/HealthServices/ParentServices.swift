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
    case AddNewChild(parameters : [String:Any])
    
}

extension ParentServices:TargetType{
    var path: String {
        switch self {
        case .GetMyChildern:
            return ParentEndPoints.GetMyChildren.rawValue
     
        case .AddNewChild:
            return ParentEndPoints.CreateStudentByParent.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetMyChildern:
            return .get
            
        case .AddNewChild:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetMyChildern:
            return .plainRequest
            
//        case .GetStudentCompletedLessonDetails(parameters: let Parameters):
//            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .AddNewChild(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
