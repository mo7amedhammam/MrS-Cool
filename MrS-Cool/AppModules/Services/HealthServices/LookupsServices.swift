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
    
    case GetEducationTypes(parameters : [String:Any])
    case GetEducationLevels(parameters : [String:Any])
    case GetAcademicYears(parameters : [String:Any])
    case GetAllSubjects(parameters : [String:Any])
    
    // ... added new for change in design ...
    case GetAllForListByEducationLevelId(parameters : [String:Any])
    case GetAllSubjectBySubjectIdAndEducationLevelId(parameters : [String:Any])

    case GetDocumentTypes
    case GetMaterialTypes
    case GetDays
    case GetSemesters
    
    case GetSubjectsForList
    case GetLessonsForList(parameters : [String:Any])
    case GetAllTeacherLessonForList(parameters : [String:Any]) // for extra sessions
    
    case GetStatus
    
    case GetBookedStudentSubjects(parameters : [String:Any])
    case GetBookedStudentLessons(parameters : [String:Any])

    case GetBankForList
    case GetAppCountriesList

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
            return Helper.shared.CheckIfLoggedIn() ? EndPoints.GetEducationType.rawValue : EndPoints.GetEducationTypeHome.rawValue
        case .GetEducationLevels:
            return EndPoints.GetEducationLevel.rawValue
        case .GetAcademicYears:
            return EndPoints.GetAcademicYear.rawValue
        case .GetAllSubjects:
            return EndPoints.GetAllSubject.rawValue
            
            //... added for change ...
        case .GetAllForListByEducationLevelId:
            return EndPoints.GetAllForListByEducationLevelId.rawValue
        case .GetAllSubjectBySubjectIdAndEducationLevelId:
            return EndPoints.GetAllSubjectBySubjectIdAndEducationLevelId.rawValue
            
        case .GetDocumentTypes:
            return EndPoints.GetDocumentTypes.rawValue
        case .GetMaterialTypes:
            return EndPoints.GetMaterialTypes.rawValue
        case .GetDays:
            return EndPoints.GetDays.rawValue
        case .GetSemesters:
            return EndPoints.GetAcademicSemester.rawValue
            
        case .GetSubjectsForList:
            return EndPoints.GetTeacherSubjectForList.rawValue
        case .GetLessonsForList:
            return EndPoints.GetTeacherLessonForList.rawValue
            
        case .GetAllTeacherLessonForList: // for extrs sessions
            return EndPoints.GetAllTeacherLessonForList.rawValue

        case .GetStatus:
            return EndPoints.GetStatus.rawValue
            
        case .GetBookedStudentSubjects:
            return EndPoints.GetBookedStudentSubjects.rawValue
        case .GetBookedStudentLessons:
            return EndPoints.GetBookedStudentLessons.rawValue

        case .GetBankForList:
            return EndPoints.GetBankForList.rawValue

        case .GetAppCountriesList:
            return EndPoints.GetAppCountriesList.rawValue

        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetGenders,
                .GetCountries,.GetGovernorates,.GetCities,
                .GetEducationTypes,.GetEducationLevels,.GetAcademicYears,.GetAllSubjects,
                .GetAllForListByEducationLevelId,
                .GetDocumentTypes,
                .GetMaterialTypes,
                .GetDays,
                .GetSubjectsForList,.GetLessonsForList,.GetAllTeacherLessonForList,
                .GetSemesters,
                .GetStatus,
                .GetBookedStudentSubjects,.GetBookedStudentLessons,
                .GetBankForList,
                .GetAppCountriesList:
            return .get
            
        case .GetAllSubjectBySubjectIdAndEducationLevelId:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetGenders,
                .GetCountries,
//                .GetEducationTypes,
                .GetDocumentTypes,
                .GetMaterialTypes,
                .GetDays,
                .GetSubjectsForList,
                .GetSemesters,
                .GetStatus,
                .GetBankForList,
                .GetAppCountriesList:
            return .plainRequest
            
        case .GetGovernorates(parameters: let parameters),
                .GetCities(parameters: let parameters),
                .GetEducationLevels(parameters: let parameters),
                .GetAcademicYears(parameters: let parameters),
                .GetLessonsForList(parameters: let parameters),.GetAllTeacherLessonForList(parameters: let parameters),
                .GetAllForListByEducationLevelId(parameters: let parameters),
                .GetBookedStudentSubjects(parameters: let parameters),
                .GetBookedStudentLessons(parameters: let parameters),
                .GetEducationTypes(parameters: let parameters):
            return .BodyparameterRequest(Parameters: parameters, Encoding: .default)
            
        case .GetAllSubjectBySubjectIdAndEducationLevelId(parameters: let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: .default)
            
        case .GetAllSubjects(parameters: let parameters):
            return .parameterdGetRequest(Parameters: parameters, Encoding: .default)
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
