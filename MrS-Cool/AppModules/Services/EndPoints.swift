//
//  EndPoints.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import Foundation

struct Constants {
// MARK: - APIs Constants
    static var baseURL:String {return "https://mrscoolapi.azurewebsites.net/"} //TEST
//static var baseURL:String {return "https://mrscoolapi.azurewebsites.net/"} //LIVE

    static var apiURL:String {return "\(baseURL)api/\(LocalizeHelper.shared.currentLanguage)/"}
//    static var imagesURL:String {return "http://mrscoolapi.azurewebsites.net/"}

//var TermsAndConditionsURL =  "https://camelgate.app/terms.html"

    static var WhatsAppNum = "+201011138900"
}

enum EndPoints: String {
    //MARK: -- Lookups --
   case GetGender = "Lookups/GetGender"
    
    
    // MARK: - Auth
    case Register = "RegisterRequest/Create"
    case Login = "Customer/Login"

    case sendOTP = "Customer/SendOTP"
    case VerifyOTP = "Customer/VerifyOTP"

    case ResetPassword = "Customer/ResetPassword"
    case ChangePassword = "Customer/ChangePassword"

}
