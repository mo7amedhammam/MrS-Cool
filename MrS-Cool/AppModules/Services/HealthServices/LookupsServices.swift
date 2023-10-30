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
    
    case GetEducationTypes
    case GetEducationLevels(parameters : [String:Any])
    case GetAcademicYears(parameters : [String:Any])
    case GetAllSubjects(parameters : [String:Any])
    case GetDocumentTypes

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
        case .GetEducationTypes:
            return EndPoints.GetEducationType.rawValue
        case .GetEducationLevels:
            return EndPoints.GetEducationLevel.rawValue
        case .GetAcademicYears:
            return EndPoints.GetAcademicYear.rawValue
        case .GetAllSubjects:
            return EndPoints.GetAllSubject.rawValue
            
        case .GetDocumentTypes:
            return EndPoints.GetDocumentTypes.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetGenders,
                .GetCountries,
                .GetGovernorates,
                .GetCities,
                .GetEducationTypes,
                .GetEducationLevels,
                .GetAcademicYears,
                .GetAllSubjects,
                .GetDocumentTypes:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetGenders,
                .GetCountries,
                .GetEducationTypes,
                .GetDocumentTypes:
            return .plainRequest
        case .GetGovernorates(parameters: let parameters),
                .GetCities(parameters: let parameters),
                .GetEducationLevels(parameters: let parameters),
                .GetAcademicYears(parameters: let parameters),
                .GetAllSubjects(parameters: let parameters):
            return .BodyparameterRequest(Parameters: parameters, Encoding: .default)
        }
    }
    
//    var encoding: ParameterEncoding {
//        switch method {
//        case .get:
//            return URLEncoding.default
//        default:
//            return JSONEncoding.default
//        }
//    }
}
