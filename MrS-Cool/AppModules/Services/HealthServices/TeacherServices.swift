//
//  TeacherServices.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import Alamofire

enum teacherServices{
    case GetTeacherProfile
    case UpdateTeacherProfile(parameters : [String:Any])
    case UpdateTeacherSubject(parameters : [String:Any])
    
    case GetTeacherSubjectLessons(parameters : [String:Any])
    case UpdateTeacherSubjectLessons(parameters : [String:Any])

    case GetSubjectLessonsBrief(parameters : [String:Any])
    case UpdateSubjectLessonsBrief(parameters : [String:Any])

    case GetMyLessonMaterial(parameters : [String:Any])
    case CreateMyLessonMaterial(parameters : [String:Any])
    case UpdateMyLessonMaterial(parameters : [String:Any])
    case DeleteLessonMaterial(parameters : [String:Any])

    case GetMyScheduals(parameters : [String:Any])
    case CreateMyNewSchedual(parameters : [String:Any])
    case DeleteMySchedual(parameters : [String:Any])
    
    case GetMyLessonSchedualGroup(parameters : [String:Any])
    case CreateMyLessonScheduleGroup(parameters : [String:Any])
    case DeleteMyLessonScheduleGroup(parameters : [String:Any])
    
    case GetMySubjectGroup(parameters : [String:Any])
    case GetMySubjectGroupDetails(parameters : [String:Any])
    case ReviewMySubjectGroup(parameters : [String:Any])
    case CreateMySubjectGroup(parameters : [String:Any])
    case DeleteMySubjectGroup(parameters : [String:Any])
    
    case GetMyCompletedLessons(parameters : [String:Any])
    case GetMyCompletedLessonDetails(parameters : [String:Any])
    
    case GetMyCalenderSchedual
    case cancelMyCalenderSchedual(parameters : [String:Any])
    
    case GetAllComentsList
    case GetAllComentsListById(parameters : [String:Any])
    case CreateComment(parameters : [String:Any])
    
    case GetTeacherRates(parameters : [String:Any])

}

extension teacherServices:TargetType{
    var path: String {
        switch self {
        case .GetTeacherProfile:
            return EndPoints.GetTeacherProfile.rawValue
        case .UpdateTeacherProfile:
            return EndPoints.UpdateTeacherProfile.rawValue
        case .UpdateTeacherSubject:
            return EndPoints.UpdateTeacherSubject.rawValue
        case .GetTeacherSubjectLessons:
            return EndPoints.GetTeacherSubjectLessons.rawValue
        case .UpdateTeacherSubjectLessons:
            return EndPoints.UpdateTeacherSubjectLessons.rawValue

        case .GetSubjectLessonsBrief:
            return EndPoints.GetSubjectLessonBrief.rawValue
        case .UpdateSubjectLessonsBrief:
            return EndPoints.UpdateSubjectLessonBrief.rawValue

        case .GetMyLessonMaterial:
            return EndPoints.GetMyLessonMaterials.rawValue
        case .CreateMyLessonMaterial:
            return EndPoints.CreateMyLessonMaterials.rawValue
        case .UpdateMyLessonMaterial:
            return EndPoints.UpdateMyLessonMaterials.rawValue
        case .DeleteLessonMaterial:
            return EndPoints.DeleteMyLessonMaterials.rawValue

        case .GetMyScheduals:
            return EndPoints.GetMySchedules.rawValue
        case .CreateMyNewSchedual:
            return EndPoints.CreateMySchedules.rawValue
        case .DeleteMySchedual:
            return EndPoints.DeleteMySchedules.rawValue

        case .GetMyLessonSchedualGroup:
            return EndPoints.GetMyLessonSchedualGroup.rawValue
        case .CreateMyLessonScheduleGroup:
            return EndPoints.CreateLessonTeacherScheduleGroup.rawValue
        case .DeleteMyLessonScheduleGroup:
            return EndPoints.DeleteLessonTeacherScheduleGroup.rawValue
            
        case .GetMySubjectGroup:
            return EndPoints.GetSubjectScheduals.rawValue
        case .GetMySubjectGroupDetails:
            return EndPoints.GetSubjectSchedualDetails.rawValue
        case .ReviewMySubjectGroup:
            return EndPoints.ReviewSubjectSchedual.rawValue
        case .CreateMySubjectGroup:
            return EndPoints.CreateSubjectSchedual.rawValue
        case .DeleteMySubjectGroup:
            return EndPoints.DeleteSubjectSchedual.rawValue
            
        case .GetMyCompletedLessons:
            return EndPoints.GetMyCompletedLessons.rawValue
        case .GetMyCompletedLessonDetails:
            return EndPoints.GetMyCompletedLessonDetails.rawValue
            
        case .GetMyCalenderSchedual:
           if Helper.shared.getSelectedUserType() == .Student{
                return EndPoints.GetStudentCalenderSchedual.rawValue
            }else{
                return EndPoints.GetMyCalenderSchedual.rawValue
            }
        case .cancelMyCalenderSchedual:
            if Helper.shared.getSelectedUserType() == .Student{
                 return EndPoints.CancelStudentCalenderSchedual.rawValue
             }else{
                 return EndPoints.CancelMyCalenderSchedual.rawValue
             }
            
        case .GetAllComentsList:
            if Helper.shared.getSelectedUserType() == .Student{
                 return EndPoints.GetStudentAllStudentsChat.rawValue
             }else{
                 return EndPoints.GetAllStudentsChat.rawValue
             }
        case .GetAllComentsListById:
            if Helper.shared.getSelectedUserType() == .Student{
                 return EndPoints.GetStudentAllStudentsChatComments.rawValue
             }else{
                 return EndPoints.GetAllStudentsChatComments.rawValue
             }
        case .CreateComment:
            if Helper.shared.getSelectedUserType() == .Student{
                 return EndPoints.CreateStudentComment.rawValue
             }else{
                 return EndPoints.CreateComment.rawValue
             }

        case .GetTeacherRates:
            return EndPoints.GetTeacherRates.rawValue

        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetTeacherProfile,
                .GetSubjectLessonsBrief,
                .DeleteLessonMaterial,
                .DeleteMySchedual,
                .DeleteMyLessonScheduleGroup,
                .DeleteMySubjectGroup,.GetMySubjectGroupDetails,
                .GetMyCompletedLessonDetails,
                .GetMyCalenderSchedual,
                .cancelMyCalenderSchedual,
                .GetAllComentsList,.GetAllComentsListById:
            return .get
        case .UpdateTeacherProfile,
                .UpdateTeacherSubject,
                .GetTeacherSubjectLessons,
                .UpdateTeacherSubjectLessons,
                .UpdateSubjectLessonsBrief,
                .GetMyLessonMaterial,.CreateMyLessonMaterial,.UpdateMyLessonMaterial,
                .GetMyScheduals,.CreateMyNewSchedual,
                .GetMyLessonSchedualGroup, .CreateMyLessonScheduleGroup,
                .GetMySubjectGroup,.ReviewMySubjectGroup,.CreateMySubjectGroup,
                .GetMyCompletedLessons,
                .CreateComment,
                .GetTeacherRates:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetTeacherProfile,
                .GetMyCalenderSchedual,
                .GetAllComentsList:
            return .plainRequest
            
        case .GetSubjectLessonsBrief(parameters: let Parameters),
                .DeleteLessonMaterial(parameters: let Parameters),
                .DeleteMySchedual(parameters: let Parameters),
                .DeleteMyLessonScheduleGroup(parameters: let Parameters),
                .DeleteMySubjectGroup(parameters: let Parameters),
                .GetMySubjectGroupDetails(parameters: let Parameters),
                .GetMyCompletedLessonDetails(parameters: let Parameters),
                .cancelMyCalenderSchedual(parameters: let Parameters),
                .GetAllComentsListById(parameters: let Parameters):
            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .UpdateTeacherProfile(parameters: let Parameters),
                .UpdateTeacherSubject(parameters: let Parameters),
                .GetTeacherSubjectLessons(parameters: let Parameters),
                .UpdateTeacherSubjectLessons(parameters: let Parameters),
                .UpdateSubjectLessonsBrief(parameters: let Parameters),
                .GetMyLessonMaterial(parameters: let Parameters),
                .CreateMyLessonMaterial(parameters: let Parameters),
                .UpdateMyLessonMaterial(parameters: let Parameters),
                .GetMyScheduals(parameters: let Parameters),
                .CreateMyNewSchedual(parameters: let Parameters),
                .GetMyLessonSchedualGroup(parameters: let Parameters),
                .CreateMyLessonScheduleGroup(parameters: let Parameters),
                .GetMySubjectGroup(parameters: let Parameters),
                .ReviewMySubjectGroup(parameters: let Parameters),
                .CreateMySubjectGroup(parameters: let Parameters),
                .GetMyCompletedLessons(parameters: let Parameters),
                .CreateComment(parameters: let Parameters),
                .GetTeacherRates(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
