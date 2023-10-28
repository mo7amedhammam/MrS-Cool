//
//  Authintications.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import Foundation
import Alamofire

//enum OTPVerificationType{
//    case Registeration, ResetingPassword
//}

enum Authintications {
    case TeacherRegisterDate(parameters : [String:Any])
    
    case TeacherGetSubjects(parameters : [String:Any])
    case TeacherRegisterSubjects(parameters : [String:Any])
    case TeacherDeleteSubjects(parameters : [String:Any])

    case TeacherRegisterDocuments(parameters : [String:Any])
    case TeacherGetDocuments(parameters : [String:Any])
    case TeacherDeleteDocuments(parameters : [String:Any])

    case TeacherLogin(parameters : [String:Any])

    case SendOtpTeacher(parameters : [String:Any])
    case VerifyOtpTeacher(parameters : [String:Any])

    case ResetPassword(parameters : [String:Any])
    case ChangePassword(parameters:[String:Any])
    
}

extension Authintications : TargetType {
    var path: String {
        switch self {
        case .TeacherRegisterDate:
            return EndPoints.RegisterTeacher.rawValue
            
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

        case .TeacherLogin:
            return EndPoints.LoginTeacher.rawValue

        case .SendOtpTeacher:
            return EndPoints.sendOTPTeacher.rawValue
            
        case .VerifyOtpTeacher:
            return EndPoints.VerifyOTPTeacher.rawValue
            
        case .ResetPassword:
            return EndPoints.ResetPassword.rawValue
            
        case .ChangePassword:
            return EndPoints.ChangePassword.rawValue
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .TeacherRegisterDate,
                .TeacherRegisterSubjects,
                .TeacherGetSubjects,
                .TeacherRegisterDocuments,
                .TeacherGetDocuments,
                .TeacherLogin,
                .SendOtpTeacher,
                .VerifyOtpTeacher,
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
        case .TeacherRegisterDate(parameters: let parameters),
                .TeacherRegisterSubjects(parameters: let parameters),
                .TeacherGetSubjects(parameters: let parameters),
                .TeacherRegisterDocuments(parameters: let parameters),
                .TeacherGetDocuments(parameters: let parameters),
                .TeacherLogin(parameters: let parameters),
                .SendOtpTeacher(parameters: let parameters),
                .VerifyOtpTeacher(parameters: let parameters),
                .ResetPassword(parameters: let parameters),
                .ChangePassword(parameters: let parameters):
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
