//
//  TeacherServices.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import Alamofire

enum teacherServices{
    case GetHomeScheduals(parameters : [String:Any])
    case GetHomeAlternateSessions
    case CreateAlternateSession(parameters : [String:Any])
    case GetEgyptDateTime

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
    case CreateExtraSession(parameters : [String:Any])

    case GetMyCompletedLessons(parameters : [String:Any])
    case GetMyCompletedLessonDetails(parameters : [String:Any])
    
    case GetMyCalenderSchedual(parameters : [String:Any])
    case cancelMyCalenderSchedual(parameters : [String:Any])
    case AttendanceStudentCalenderSchedual(parameters : [String:Any])

    case GetAllComentsList(parameters : [String:Any])
    case GetAllComentsListById(parameters : [String:Any])
    case CreateComment(parameters : [String:Any])
        
    case GetTeacherFinance
    case GetTeacherFinanceSubjects(FinanceFor : StudentFinanceCases ,parameters : [String:Any])
    case GetTeacherLessonsForSubjectGroup(parameters : [String:Any])

    case GetTeacherRates(parameters : [String:Any])
}

extension teacherServices:TargetType{
    var path: String {
        switch self {
        case .GetHomeScheduals:
            return EndPoints.GetTeacherHomeCalenderSchedualPaged.rawValue
        case .GetHomeAlternateSessions:
            return EndPoints.GetMissedSessionList.rawValue
        case .CreateAlternateSession:
            return EndPoints.CreateAlternateSession.rawValue
        case .GetEgyptDateTime:
            return EndPoints.GetEgyptDateTime.rawValue
            
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
        case .CreateExtraSession:
            return EndPoints.CreateExtraSession.rawValue

        case .GetMyCompletedLessons:
            return EndPoints.GetMyCompletedLessons.rawValue
        case .GetMyCompletedLessonDetails:
            return EndPoints.GetMyCompletedLessonDetails.rawValue
            
        case .GetMyCalenderSchedual:
           if Helper.shared.getSelectedUserType() == .Teacher{
               return EndPoints.GetMyCalenderSchedual.rawValue
            }else{
                return EndPoints.GetStudentCalenderSchedual.rawValue
            }
        case .cancelMyCalenderSchedual:
            if Helper.shared.getSelectedUserType() == .Teacher{
                return EndPoints.CancelMyCalenderSchedual.rawValue
             }else{
                 return EndPoints.CancelStudentCalenderSchedual.rawValue
             }
            
        case .AttendanceStudentCalenderSchedual: // this for student Only
            if Helper.shared.getSelectedUserType() == .Teacher{
                return EndPoints.TeacherAttendanceCalenderSchedual.rawValue
            }else{
                return EndPoints.StudentAttendanceCalenderSchedual.rawValue
            }
        case .GetAllComentsList:
            if Helper.shared.getSelectedUserType() == .Teacher{
                return EndPoints.GetAllStudentsChat.rawValue

             }else{
                 return EndPoints.GetStudentAllStudentsChat.rawValue

             }
        case .GetAllComentsListById:
            if Helper.shared.getSelectedUserType() == .Teacher{
                return EndPoints.GetAllStudentsChatComments.rawValue

             }else{
                 return EndPoints.GetStudentAllStudentsChatComments.rawValue

             }
        case .CreateComment:
            if Helper.shared.getSelectedUserType() == .Teacher{
                return EndPoints.CreateComment.rawValue

             }else{
                 return EndPoints.CreateStudentComment.rawValue

             }

        case .GetTeacherFinance:
            return EndPoints.GetTeacherFinance.rawValue
        case .GetTeacherFinanceSubjects(FinanceFor: let FinanceFor, _):
            switch FinanceFor{
            case .Subjects:
                return EndPoints.GetTeacherPurchasedFinanceSubjects.rawValue
            case .Lessons:
                return EndPoints.GetTeacherdPurchasedFinanceLessons.rawValue
            }
        case .GetTeacherLessonsForSubjectGroup:
            return EndPoints.GetTeacherLessonsForSubjectGroup.rawValue

        case .GetTeacherRates:
            return EndPoints.GetTeacherRates.rawValue

        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetTeacherProfile,
                .GetEgyptDateTime,
                .GetSubjectLessonsBrief,
                .DeleteLessonMaterial,
                .DeleteMySchedual,
                .DeleteMyLessonScheduleGroup,
                .DeleteMySubjectGroup,.GetMySubjectGroupDetails,
                .GetMyCompletedLessonDetails,
                .GetMyCalenderSchedual,.cancelMyCalenderSchedual,.AttendanceStudentCalenderSchedual,
                .GetAllComentsList,.GetAllComentsListById,
                .GetTeacherFinance,.GetTeacherLessonsForSubjectGroup,
                .GetHomeAlternateSessions:
            return .get
            
        case  .GetHomeScheduals,
                .CreateAlternateSession,
                .UpdateTeacherProfile,
                .UpdateTeacherSubject,
                .GetTeacherSubjectLessons,
                .UpdateTeacherSubjectLessons,
                .UpdateSubjectLessonsBrief,
                .GetMyLessonMaterial,.CreateMyLessonMaterial,.UpdateMyLessonMaterial,
                .GetMyScheduals,.CreateMyNewSchedual,
                .GetMyLessonSchedualGroup, .CreateMyLessonScheduleGroup,
                .GetMySubjectGroup,.ReviewMySubjectGroup,.CreateMySubjectGroup,.CreateExtraSession,
                .GetMyCompletedLessons,
                .CreateComment,
                .GetTeacherFinanceSubjects,
                .GetTeacherRates:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetTeacherProfile,
                .GetEgyptDateTime,
                .GetTeacherFinance,
                .GetHomeAlternateSessions:
            return .plainRequest
            
        case .GetSubjectLessonsBrief(parameters: let Parameters),
                .DeleteLessonMaterial(parameters: let Parameters),
                .DeleteMySchedual(parameters: let Parameters),
                .DeleteMyLessonScheduleGroup(parameters: let Parameters),
                .DeleteMySubjectGroup(parameters: let Parameters),
                .GetMySubjectGroupDetails(parameters: let Parameters),
                .GetMyCompletedLessonDetails(parameters: let Parameters),
                .GetMyCalenderSchedual(parameters:let Parameters),
                .cancelMyCalenderSchedual(parameters: let Parameters),
                .AttendanceStudentCalenderSchedual(parameters: let Parameters),
//                .GetAllComentsList(parameters: let Parameters),
//                .GetAllComentsListById(parameters: let Parameters)
                .GetTeacherLessonsForSubjectGroup(parameters: let Parameters)
            :
            return .BodyparameterRequest(Parameters: Parameters, Encoding: .default)
            
        case .GetHomeScheduals(parameters: let Parameters),
                .CreateAlternateSession(parameters: let Parameters),
                .UpdateTeacherProfile(parameters: let Parameters),
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
                .CreateExtraSession(parameters: let Parameters),
                .GetMyCompletedLessons(parameters: let Parameters),
                .CreateComment(parameters: let Parameters),
                .GetTeacherFinanceSubjects(_, parameters: let Parameters),
                .GetTeacherRates(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
            
        case  .GetAllComentsList(parameters: let Parameters),
                .GetAllComentsListById(parameters: let Parameters):
            return .parameterdGetRequest(Parameters: Parameters, Encoding: .default)

        }
    }
    
}
