//
//  LookupsServices.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Foundation
import Alamofire
enum LookupsServices {
    case GetGenders
}


extension LookupsServices : TargetType {
    var path: String {
        switch self {
        case .GetGenders:
            return EndPoints.GetGender.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetGenders:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetGenders:
            return .plainRequest
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
