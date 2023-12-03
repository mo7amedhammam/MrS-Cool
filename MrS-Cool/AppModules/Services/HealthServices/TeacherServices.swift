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
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .GetTeacherProfile,
                .GetSubjectLessonsBrief,
                .DeleteLessonMaterial,
                .DeleteMySchedual,
                .DeleteMyLessonScheduleGroup:
            return .get
        case .UpdateTeacherProfile,
                .UpdateTeacherSubject,
                .GetTeacherSubjectLessons,
                .UpdateTeacherSubjectLessons,
                .UpdateSubjectLessonsBrief,
                .GetMyLessonMaterial,.CreateMyLessonMaterial,.UpdateMyLessonMaterial,
                .GetMyScheduals,.CreateMyNewSchedual,
                .GetMyLessonSchedualGroup, .CreateMyLessonScheduleGroup:
            return .post
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .GetTeacherProfile:
            return .plainRequest
            
        case .GetSubjectLessonsBrief(parameters: let Parameters),
                .DeleteLessonMaterial(parameters: let Parameters),
                .DeleteMySchedual(parameters: let Parameters),
                .DeleteMyLessonScheduleGroup(parameters: let Parameters):
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
                .CreateMyLessonScheduleGroup(parameters: let Parameters):
            return .parameterRequest(Parameters: Parameters, Encoding: .default)
        }
    }
    
}
