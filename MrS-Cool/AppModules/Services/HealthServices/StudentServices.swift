//
//  StudentServices.swift
//  MrS-Cool
//
//  Created by wecancity on 07/01/2024.
//

import Foundation
import Alamofire

enum StudentServices{
    case GetStudentSubjects(parameters : [String:Any])
    case GetMostLessons(mostType:studentLessonMostCases,parameters : [String:Any])
    case GetMostSubjects(mostType:studentLessonMostCases,parameters : [String:Any])
    case GetMostTeachers(mostType:studentTeacherMostCases,parameters : [String:Any])

//    case GetMostBookedLessons(parameters : [String:Any])
}

extension StudentServices:TargetType{
    var path: String {
        switch self {
        case .GetStudentSubjects:
            return EndPoints.GetStudentSubjects.rawValue
            
        case .GetMostLessons(mostType:let mostType,_):
            switch mostType{
            case .mostviewed:
                return EndPoints.MostViewedLessons.rawValue
            case .mostBooked:
                return EndPoints.MostBookedLessons.rawValue
            }

        case .GetMostSubjects(mostType: let mostType,_):
            switch mostType {
            case .mostviewed:
                return EndPoints.MostViewedSubjects.rawValue

            case .mostBooked:
                return EndPoints.MostBookedSubjects.rawValue
            }
        case .GetMostTeachers(mostType: let mostType,_):
            switch mostType {
            case .mostviewed:
                return EndPoints.MostViewedTeacher.rawValue

            case .topRated:
                return EndPoints.MostRatedTeacher.rawValue
            }
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetStudentSubjects,
                .GetMostLessons,
                .GetMostSubjects,
                .GetMostTeachers:
            
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
//        case .GetStudentSubjects:
//            return .plainRequest
            
        case .GetStudentSubjects(parameters: let Parameters),
                .GetMostLessons(_,parameters: let Parameters),
                .GetMostSubjects(_,parameters: let Parameters),
                .GetMostTeachers(_,parameters: let Parameters):
            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
//        case .UpdateTeacherProfile(parameters: let Parameters),
//                .CreateComment(parameters: let Parameters):
//            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
