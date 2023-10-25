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
    case GetCountries
    case GetGovernorates(parameters : [String:Any])
    case GetCities(parameters : [String:Any])

}


extension LookupsServices : TargetType {
    var path: String {
        switch self {
        case .GetGenders:
            return EndPoints.GetGender.rawValue
            
        case .GetCountries:
            return EndPoints.GetCountries.rawValue
        case .GetGovernorates:
            return EndPoints.GetGovernorates.rawValue
        case .GetCities:
            return EndPoints.GetCities.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetGenders,
                .GetCountries,
                .GetGovernorates,
                .GetCities:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetGenders,
                .GetCountries:
            return .plainRequest
        case .GetGovernorates(parameters: let parameters),
                .GetCities(parameters: let parameters):
            return .BodyparameterRequest(Parameters: parameters, Encoding: encoding)
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
