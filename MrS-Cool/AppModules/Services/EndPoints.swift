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
    case GetGender = "Lookups/GetGender"///get
    case GetCountries = "Country/Get"///get
    case GetGovernorates = "Governorate/Get"///get
    case GetCities = "City/Get" ///get
    case GetEducationType = "EducationType/Get" ///get
    case GetEducationLevel = "EducationLevel/GetByEducationType" /// get
    case GetAcademicYear = "AcademicYear/GetByEducationLevel" ///get
    case GetAllSubject = "SubjectSemesterYear/GetAllSubjectByAcademicEducationLevelId" /// get
    
    // MARK: -- Auth --
    //Teacher personal Date
    case RegisterTeacher = "Teacher/Register" ///post
    case LoginTeacher = "Teacher/Login"///post
    
    //Teacher Subjects
    case RegisterTeacherSubjects = "TeacherSubjectAcademicSemesterYear/Create"///Post
    case GetTeacherSubjects = "TeacherSubjectAcademicSemesterYear/GetTeacherSubjectAcademicSemesterYearList"///post
    case DeleteTeacherSubject = "TeacherSubjectAcademicSemesterYear/Delete"///get
   
    //Teacher Documents
    case RegisterTeacherDocuments = "TeacherDocument​/Create" ///post
    case GetTeacherDocument​ = "TeacherDocument​/GetMyDocuments"///post
    case DeleteTeacherDocument​ = "TeacherDocument​/Delete"///get
    
    //Teacher Subjects
    case sendOTPTeacher = "Teacher/SendOTP" ///Post
    case VerifyOTPTeacher = "Teacher/VefiryUser" /// Post

    case ResetPassword = "Customer/ResetPassword"
    case ChangePassword = "Customer/ChangePassword"

    
}
