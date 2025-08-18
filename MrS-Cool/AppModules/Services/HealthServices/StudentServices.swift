//
//  StudentServices.swift
//  MrS-Cool
//
//  Created by wecancity on 07/01/2024.
//

import Foundation
import Alamofire

enum StudentFinanceCases{
    case Subjects,Lessons
}

enum StudentServices{
    case GetStudentSubjects(parameters : [String:Any])
    case GetMostLessons(mostType:studentLessonMostCases,parameters : [String:Any])
    case GetMostSubjects(mostType:studentLessonMostCases,parameters : [String:Any])
    case GetMostTeachers(mostType:studentTeacherMostCases,parameters : [String:Any])
    case GetMostBookedTeachers(parameters : [String:Any])
    case GetTeacherProfileView(parameters : [String:Any])
    
    case GetHomeScheduals(parameters : [String:Any])
    case GetMyCalenderDetail(parameters: [String:Any])

    case GetHomeSubjectDetails(parameters : [String:Any])
    case GetSubjectOrLessonTeachers(parameters : [String:Any])
    
    case GetSubjectGroupDetails(parameters : [String:Any])
    case GetLessonGroupDetails(parameters : [String:Any])
    case GetAvaliableScheduals(parameters : [String:Any])
    case GetCheckOutBookTeacherSession(parameters : [String:Any])
    case CreateOutBookTeacherSession(parameters : [String:Any])
    case UpdateOfflinePayment(parameters : [String:Any])

    case GetStudentCompletedLessons(parameters : [String:Any])
    case GetStudentCompletedLessonDetails(parameters : [String:Any])
    
    case GetStudentProfile(parameters : [String:Any])
    case UpdateStudentProfile(parameters : [String:Any])

    case GetStudentFinance(parameters : [String:Any])
    case GetStudentFinanceSubjects(FinanceFor : StudentFinanceCases ,parameters : [String:Any])
    
    case StudentAddRate(parameters : [String:Any])
}

extension StudentServices:TargetType{
    var path: String {
        switch self {
        case .GetStudentSubjects:
            if Helper.shared.CheckIfLoggedIn() && !(Helper.shared.getSelectedUserType() == .Teacher){
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
        case .GetMostBookedTeachers:
            return EndPoints.MostBookedTeacher.rawValue
            
        case .GetHomeScheduals:
            return EndPoints.GetStudentHomeCalenderSchedualPaged.rawValue
        case .GetMyCalenderDetail:
            return EndPoints.GetMyCalenderDetail.rawValue
            
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
        case .UpdateOfflinePayment:
            return EndPoints.UpdateOfflinePayment.rawValue
            
            
        case .GetStudentCompletedLessons:
            return EndPoints.GetStudentCompletedLessons.rawValue
        case .GetStudentCompletedLessonDetails:
            return EndPoints.GetStudentCompletedLessonDetails.rawValue
            
        case .GetStudentProfile:
            if Helper.shared.getSelectedUserType() == .Parent{
                return EndPoints.GetStudentProfileByParent.rawValue
            }else{
                return EndPoints.GetStudentProfile.rawValue
            }
        case .UpdateStudentProfile:
            return EndPoints.UpdateStudentProfile.rawValue
            
        case .GetTeacherProfileView:
            return EndPoints.GetTeacherProfileView.rawValue
            
        case .GetStudentFinance:
            return EndPoints.GetStudentFinance.rawValue
        case .GetStudentFinanceSubjects(FinanceFor: let FinanceFor, _):
            switch FinanceFor{
            case .Subjects:
                return EndPoints.GetStudentPagedFinanceSubjects.rawValue
            case .Lessons:
                return EndPoints.GetStudentPagedFinanceLessons.rawValue
            }
            
        case .StudentAddRate:
            return EndPoints.StudentAddRate.rawValue

        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetStudentSubjects:
            if Helper.shared.CheckIfLoggedIn() && !(Helper.shared.getSelectedUserType() == .Teacher){
                return .get
            }else {
                return .post
            }

        case .GetMostLessons,
//                .GetMostSubjects,
                .GetMostTeachers,
                .GetHomeSubjectDetails,
                .GetSubjectGroupDetails,.GetLessonGroupDetails,.GetAvaliableScheduals,
                .GetStudentCompletedLessonDetails,
                .GetStudentProfile,
                .GetTeacherProfileView,
                .GetStudentFinance,
                .GetMyCalenderDetail:
            return .get
            
        case  .GetHomeScheduals,
                .GetSubjectOrLessonTeachers,
                .GetMostBookedTeachers,
                .GetCheckOutBookTeacherSession,.CreateOutBookTeacherSession,.UpdateOfflinePayment,
                .GetStudentCompletedLessons,
                .UpdateStudentProfile,
                .GetStudentFinanceSubjects,
                .StudentAddRate,
                .GetMostSubjects:
            return .post
            
        }
    }
    
    var parameter: parameterType {
        switch self {
//        case :
//            return .plainRequest
        case .GetStudentSubjects(parameters: let Parameters):
            if Helper.shared.CheckIfLoggedIn() && !(Helper.shared.getSelectedUserType() == .Teacher){
                return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            }else {
                return .parameterRequest(Parameters: Parameters, Encoding: .default)
            }
            
        case .GetStudentProfile(parameters: let Parameters),
                .GetMostLessons(_,parameters: let Parameters),
//                .GetMostSubjects(_,parameters: let Parameters),
                .GetMostTeachers(_,parameters: let Parameters),
                .GetHomeSubjectDetails(parameters: let Parameters),
                .GetSubjectGroupDetails(parameters: let Parameters),
                .GetLessonGroupDetails(parameters: let Parameters),.GetAvaliableScheduals(parameters: let Parameters),
                .GetTeacherProfileView(parameters: let Parameters),
                .GetStudentFinance(parameters: let Parameters),
                .GetMyCalenderDetail(parameters: let Parameters):
            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .GetHomeScheduals(parameters: let Parameters),
                .GetSubjectOrLessonTeachers(parameters: let Parameters),
                .GetMostBookedTeachers(parameters: let Parameters),
                .GetCheckOutBookTeacherSession(parameters: let Parameters),
                .CreateOutBookTeacherSession(parameters: let Parameters),
                .UpdateOfflinePayment(parameters: let Parameters),
                .GetStudentCompletedLessons(parameters: let Parameters),
                .UpdateStudentProfile(parameters: let Parameters),
                .GetStudentFinanceSubjects(_, parameters: let Parameters),
                .StudentAddRate(parameters: let Parameters),
                .GetMostSubjects(_,let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .GetStudentCompletedLessonDetails(parameters: let Parameters):
            return .parameterdGetRequest(Parameters: Parameters, Encoding: .default)

        }
    }
    
}
