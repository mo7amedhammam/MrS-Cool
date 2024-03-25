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
    case GetTeacherProfileView(parameters : [String:Any])
    
    case GetHomeSubjectDetails(parameters : [String:Any])
    case GetSubjectOrLessonTeachers(parameters : [String:Any])
    
    case GetSubjectGroupDetails(parameters : [String:Any])
    case GetLessonGroupDetails(parameters : [String:Any])
    case GetAvaliableScheduals(parameters : [String:Any])
    case GetCheckOutBookTeacherSession(parameters : [String:Any])
    case CreateOutBookTeacherSession(parameters : [String:Any])

    case GetStudentCompletedLessons(parameters : [String:Any])
    case GetStudentCompletedLessonDetails(parameters : [String:Any])
    
    case GetStudentProfile
    case UpdateStudentProfile(parameters : [String:Any])


}

extension StudentServices:TargetType{
    var path: String {
        switch self {
        case .GetStudentSubjects:
            if Helper.shared.CheckIfLoggedIn(){
                return EndPoints.GetStudentSubjects.rawValue
            }else {
                return EndPoints.GetAllAnonymousSubjects.rawValue
            }
            
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
        case .GetHomeSubjectDetails:
            return EndPoints.GetHomeSubjectDetails.rawValue
        case .GetSubjectOrLessonTeachers:
            return EndPoints.GetSubjectOrLessonTeachers.rawValue

        case .GetSubjectGroupDetails:
            return EndPoints.GetTeacherSubjectGroupDetail.rawValue
        case .GetLessonGroupDetails:
            return EndPoints.GetTeacherLessonGroupDetail.rawValue

        case .GetAvaliableScheduals:
            return EndPoints.GetTeacherAvaliableSchedual.rawValue
        case .GetCheckOutBookTeacherSession:
            return EndPoints.GetCheckOutBookTeacherSession.rawValue
        case .CreateOutBookTeacherSession:
            return EndPoints.CreateBookTeacherSession.rawValue
            
        case .GetStudentCompletedLessons:
            return EndPoints.GetStudentCompletedLessons.rawValue
        case .GetStudentCompletedLessonDetails:
            return EndPoints.GetStudentCompletedLessonDetails.rawValue
            
        case .GetStudentProfile:
            return EndPoints.GetStudentProfile.rawValue
        case .UpdateStudentProfile:
            return EndPoints.UpdateStudentProfile.rawValue

        case .GetTeacherProfileView:
            return EndPoints.GetTeacherProfileView.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetStudentSubjects,
                .GetMostLessons,
                .GetMostSubjects,
                .GetMostTeachers,
                .GetHomeSubjectDetails,
                .GetSubjectGroupDetails,.GetLessonGroupDetails,.GetAvaliableScheduals,
                .GetStudentCompletedLessonDetails,
                .GetStudentProfile,
                .GetTeacherProfileView:
            return .get
            
        case  .GetSubjectOrLessonTeachers,
                .GetCheckOutBookTeacherSession,.CreateOutBookTeacherSession,
                .GetStudentCompletedLessons,
                .UpdateStudentProfile:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetStudentProfile:
            return .plainRequest
            
        case .GetStudentSubjects(parameters: let Parameters),
                .GetMostLessons(_,parameters: let Parameters),
                .GetMostSubjects(_,parameters: let Parameters),
                .GetMostTeachers(_,parameters: let Parameters),
                .GetHomeSubjectDetails(parameters: let Parameters),
                .GetSubjectGroupDetails(parameters: let Parameters),
                .GetLessonGroupDetails(parameters: let Parameters),.GetAvaliableScheduals(parameters: let Parameters),
                .GetStudentCompletedLessonDetails(parameters: let Parameters),
                .GetTeacherProfileView(parameters: let Parameters):
            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .GetSubjectOrLessonTeachers(parameters: let Parameters),
                .GetCheckOutBookTeacherSession(parameters: let Parameters),
                .CreateOutBookTeacherSession(parameters: let Parameters),
                .GetStudentCompletedLessons(parameters: let Parameters),
                .UpdateStudentProfile(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
