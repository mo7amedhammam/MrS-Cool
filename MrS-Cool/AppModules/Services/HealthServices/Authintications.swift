//
//  Authintications.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import Foundation
import Alamofire

enum Authintications {
    case Register(user:UserTypeEnum,parameters : [String:Any])
    case VerifyOtpUser(user:UserTypeEnum,parameters : [String:Any])

    case TeacherGetSubjects(parameters : [String:Any])
    case TeacherRegisterSubjects(parameters : [String:Any])
    case TeacherDeleteSubjects(parameters : [String:Any])

    case TeacherRegisterDocuments(parameters : [String:Any])
    case TeacherGetDocuments(parameters : [String:Any])
    case TeacherDeleteDocuments(parameters : [String:Any])

    case TeacherLogin(user:UserTypeEnum, parameters : [String:Any])

    case SendOtp(user:UserTypeEnum,parameters : [String:Any])
//    case VerifyOtp(parameters : [String:Any])

    case ResetPassword(user:UserTypeEnum,parameters : [String:Any])
    case ChangePassword(user:UserTypeEnum,parameters : [String:Any])
    
}

extension Authintications : TargetType {
    var path: String {
        switch self {
        case .Register(let user,_):
            switch user {
            case .Student:
                return EndPoints.RegisterStudent.rawValue
            case .Parent:
                return EndPoints.RegisterParent.rawValue
            case .Teacher:
                return EndPoints.RegisterTeacher.rawValue
            }
            
        case .TeacherRegisterSubjects:
            return EndPoints.RegisterTeacherSubjects.rawValue
        case .TeacherGetSubjects:
            return EndPoints.GetTeacherSubjects.rawValue
        case .TeacherDeleteSubjects:
            return EndPoints.DeleteTeacherSubject.rawValue

        case .TeacherRegisterDocuments:
            return EndPoints.RegisterTeacherDocuments.rawValue
        case .TeacherGetDocuments:
            return EndPoints.GetTeacherDocument​.rawValue
        case .TeacherDeleteDocuments:
            return EndPoints.DeleteTeacherDocument​.rawValue

        case .TeacherLogin(let user,_):
            switch user{
            case .Student:
                return EndPoints.LoginStudent.rawValue
            case .Parent:
                return EndPoints.LoginParent.rawValue
            case .Teacher:
                return EndPoints.LoginTeacher.rawValue
            }

        case .SendOtp:
            return EndPoints.sendOTPTeacher.rawValue
            
        case .VerifyOtpUser(let user, _):
            switch user {
            case .Student:
                return EndPoints.VerifyOTPStudent.rawValue

            case .Parent:
                return EndPoints.VerifyOTPParent.rawValue

            case .Teacher:
                return EndPoints.VerifyOTPTeacher.rawValue

            }
            
        case .ResetPassword(let user, _):
            switch user {
            case .Student:
                return EndPoints.ResetPasswordStudent.rawValue

            case .Parent:
                return EndPoints.ResetPasswordParent.rawValue

            case .Teacher:
                return EndPoints.ResetPasswordTeacher.rawValue

            }
            
        case .ChangePassword(let user, _):
            switch user {
            case .Student:
                return EndPoints.ChangePasswordStudent.rawValue

            case .Parent:
                return EndPoints.ChangePasswordParent.rawValue

            case .Teacher:
                return EndPoints.ChangePasswordTeacher.rawValue

            }
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .Register,
                .VerifyOtpUser,
                .TeacherRegisterSubjects,
                .TeacherGetSubjects,
                .TeacherRegisterDocuments,
                .TeacherGetDocuments,
                .TeacherLogin,
                .SendOtp,
                .ResetPassword,
                .ChangePassword:
            return .post
            
        case .TeacherDeleteSubjects,
                .TeacherDeleteDocuments:
            return .get
        }
    }
    
    var parameter: parameterType {
        switch self {
        case .Register(_,let parameters),
                .TeacherRegisterSubjects( let parameters),
                .TeacherGetSubjects( let parameters),
                .TeacherRegisterDocuments( let parameters),
                .TeacherGetDocuments( let parameters),
                .TeacherLogin(_, let parameters),
                .SendOtp(_, let parameters),
                .VerifyOtpUser(_, let parameters),
                .ResetPassword(_, let parameters),
                .ChangePassword(_, let parameters):
            return .parameterRequest(Parameters: parameters, Encoding: .default)
            
        case .TeacherDeleteSubjects(parameters: let parameters),
                .TeacherDeleteDocuments(parameters: let parameters):
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
//    
}

