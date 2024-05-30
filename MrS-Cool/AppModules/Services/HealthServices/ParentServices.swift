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
    case DeleteChild(parameters : [String:Any])

    case GetParentProfile
    case UpdateParentProfile(parameters : [String:Any])
}

extension ParentServices:TargetType{
    var path: String {
        switch self {
        case .GetMyChildern:
            return ParentEndPoints.GetMyChildren.rawValue
     
        case .AddNewChild:
            return ParentEndPoints.CreateStudentByParent.rawValue
        case .DeleteChild:
            return ParentEndPoints.DeleteStudentByParent.rawValue
            
        case .GetParentProfile:
            return ParentEndPoints.GetParentProfile.rawValue
        case .UpdateParentProfile:
            return ParentEndPoints.UpdateParentProfile.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetMyChildern,
                .GetParentProfile,
                .DeleteChild:
            return .get
            
        case .AddNewChild,
                .UpdateParentProfile:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetMyChildern,
                .GetParentProfile:
            return .plainRequest
            
        case .DeleteChild(parameters: let Parameters):
            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .AddNewChild(parameters: let Parameters),
                .UpdateParentProfile(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
