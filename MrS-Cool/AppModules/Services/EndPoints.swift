//
//  EndPoints.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import Foundation

struct Constants {
// MARK: - APIs Constants
//    static var baseURL:String {return "https://mrscoolapi.azurewebsites.net/"} //TEST
static var baseURL:String {return "https://alnada-devmrsapi.azurewebsites.net/"} //LIVE

    static var apiURL:String {return "\(baseURL)api/\(LocalizeHelper.shared.currentLanguage)/"}
//    static var imagesURL:String {return "http://mrscoolapi.azurewebsites.net/"}

    static var TermsAndConditionsURL:String {return "\(baseURL)Files/TermsAndConditions\(LocalizeHelper.shared.currentLanguage.uppercased()).pdf"}

//    static var WhatsAppNum = "+201011138900"
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
    case GetDocumentTypes = "DocumentType/Get"
    case GetMaterialTypes = "MaterialType/Get"
    case GetDays = "Lookups/GetDay"
    case GetAcademicSemester = "AcademicSemester/Get"
    case GetStatus = "Lookups/GetStatus"
    case GetBankForList = "Bank/GetBankForList"

    // ... new Change for teacher register/ subjects ...
    case GetAllForListByEducationLevelId = "Subject/GetAllForListByEducationLevelId"
    case GetAllSubjectBySubjectIdAndEducationLevelId = "SubjectSemesterYear/GetAllSubjectBySubjectIdAndEducationLevelId"
    
    // MARK: -- Teacher Auth --
    //Teacher personal Date
    case RegisterTeacher = "Teacher/Register" ///post
    case LoginTeacher = "Teacher/Login"///post
    
    //Teacher Subjects
    case RegisterTeacherSubjects = "TeacherSubjectAcademicSemesterYear/CreateForRegister" /// new changed api
    case UpdateTeacherSubjects = "TeacherSubjectAcademicSemesterYear/Create"///Post
    case GetTeacherSubjects = "TeacherSubjectAcademicSemesterYear/GetTeacherSubjectAcademicSemesterYearList"///post
    case DeleteTeacherSubject = "TeacherSubjectAcademicSemesterYear/Delete"///get
    
    //Teacher Documents
    case RegisterTeacherDocuments = "TeacherDocument/Create" ///post
    case GetTeacherDocument​ = "TeacherDocument/GetMyDocuments"///post
    case DeleteTeacherDocument​ = "TeacherDocument/Delete"///get
    
    //Teacher Subjects
    case sendOTPTeacher = "Teacher/SendOTP" ///Post
    case VerifyOTPTeacher = "Teacher/VefiryUser" /// Post
    case VerifyResetOTPTeacher = "Teacher/VerifyOTP" /// Post

    case ResetPasswordTeacher = "Teacher/ResetPassword"
    case ChangePasswordTeacher = "Teacher/ChangePassword"
    
    // MARK: -- Student Auth --
    case RegisterStudent = "Student/Register" ///post
    case LoginStudent = "Student/Login"///post
    
    case sendOTPStudent = "Student/SendOTP" ///Post
    case VerifyOTPStudent = "Student/VefiryUser" /// Post
    case VerifyResetOTPStudent = "Student/VerifyOTP" /// Post

    case ResetPasswordStudent = "Student/ResetPassword"
    case ChangePasswordStudent = "Student/ChangePassword"
    
    // MARK: -- parent Auth --
    case RegisterParent = "Parent/Register" ///post
    case LoginParent = "Parent/Login"///post
    
    case sendOTPParent = "Parent/SendOTP" ///Post
    case VerifyOTPParent = "Parent/VefiryUser" /// Post
    case VerifyResetOTPParent = "Parent/VerifyOTP" /// Post

    case ResetPasswordParent = "Parent/ResetPassword"
    case ChangePasswordParent = "Parent/ChangePassword"
    
    // MARK: -- Teacher Profile --
    case GetTeacherProfile = "Teacher/Profile"
    case UpdateTeacherProfile = "Teacher/UpdateProfile"
    
    // MARK: -- Teacher Home --
    case GetTeacherHomeCalenderSchedualPaged = "TeacherCalenderSchedual/GetMyCalenderSchedualPaged"
    
    // MARK: -- Teacher Subject --
    case UpdateTeacherSubject = "TeacherSubjectAcademicSemesterYear/Update"
    
    // MARK: -- Teacher Subject Lessons --
    case GetTeacherSubjectLessons = "TeacherLesson/GetMyLessons"
    case UpdateTeacherSubjectLessons = "TeacherLesson/CreateOrUpdate"
    
    case GetSubjectLessonBrief = "TeacherLesson/GetTeacherBerifById"
    case UpdateSubjectLessonBrief = "TeacherLesson/UpdateTeacherLessonBerif"
    
    // MARK: -- Teacher Subject Lessons Material --
    case GetMyLessonMaterials = "TeacherLessonMaterial/GetMyLessonMaterials"
    case CreateMyLessonMaterials = "TeacherLessonMaterial/Create"
    case UpdateMyLessonMaterials = "TeacherLessonMaterial/Update"
    case DeleteMyLessonMaterials = "TeacherLessonMaterial/Delete"
    
    // MARK: -- Teacher Scheduals --
    case GetMySchedules = "TeacherSchedule/GetMySchedules"
    case CreateMySchedules = "TeacherSchedule/Create"
    case DeleteMySchedules = "TeacherSchedule/Delete"
    
    // MARK: -- Teacher Groups for lesson --
    case GetTeacherSubjectForList = "TeacherSubjectAcademicSemesterYear/GetTeacherSubjectAcademicSemesterYearForList"
    case GetTeacherLessonForList = "TeacherLesson/GetTeacherLessonForList"
    case CreateLessonTeacherScheduleGroup = "TeacherSchedule/CreateLessonTeacherScheduleGroup"
    case GetMyLessonSchedualGroup = "TeacherSchedule/GetMyLessonSchedualGroup"
    case DeleteLessonTeacherScheduleGroup = "TeacherSchedule/DeleteLessonTeacherScheduleGroup"
    
    case GetAllTeacherLessonForList = "TeacherLesson/GetAllTeacherLessonForList" // for extra sessions
    case CreateExtraSession = "TeacherSchedule/CreateExtraSession"
    
    // MARK: -- Teacher Subject Group --
    case GetSubjectScheduals = "TeacherSchedule/GetMySubjectSchedualGroup"
    case GetSubjectSchedualDetails = "TeacherSchedule/GetSubjectSchedualGroupDetails"
    case ReviewSubjectSchedual = "TeacherSchedule/ReviewSubjectSchedualGroup"
    case CreateSubjectSchedual = "TeacherSchedule/CreateSubjectTeacherScheduleGroup"
    case DeleteSubjectSchedual = "TeacherSchedule/DeleteSubjectTeacherScheduleGroup"
    
    // MARK: -- Teacher Completed Lessons --
    case GetMyCompletedLessons = "TeacherCompletedLesson/GetMyCompletedLesson"
    case GetMyCompletedLessonDetails = "TeacherCompletedLesson/GetMyCompletedLessonDetail"
    
    // MARK: -- Teacher Calendar Schedual --
    case GetMyCalenderSchedual = "TeacherCalenderSchedual/GetMyCalenderSchedual"
    case CancelMyCalenderSchedual = "TeacherCalenderSchedual/CancelBookLessonSession"
    case TeacherAttendanceCalenderSchedual = "TeacherCalenderSchedual/TeacherAttendance"

    
    // MARK: -- Chats --
    case GetAllStudentsChat = "TeacherLessonSessionComment/GetAllStudentsChatWithTeacher"
    case GetAllStudentsChatComments = "TeacherLessonSessionComment/GetAllLessonChatByTeacher"
    case CreateComment = "TeacherLessonSessionComment/CreateComment"
    
    // MARK: -- Teacher Rates --
    case GetTeacherRates = "Teacher/TeacherLessonRate"
    
    //    MARK: -- Student Home --
    case GetStudentHomeCalenderSchedualPaged = "StudentCalenderSchedule/GetMyCalenderSchedualPaged"
    
    case GetStudentSubjects = "Student/GetStudentSubjects" // for loggedin student
    case GetAllAnonymousSubjects = "SubjectOrLessonTeachers/GetAllSubjects" // for anonymous
    
    case MostViewedLessons = "Lesson/MostViewedLessons"
    case MostBookedLessons = "Lesson/MostBookedLessons"
    
    case MostViewedSubjects = "SubjectSemesterYear/TopViewedSubjects"
    case MostBookedSubjects = "SubjectSemesterYear/TopBookedSubjects"
    
    case MostViewedTeacher = "Teacher/MostViewedTeacher"
    case MostRatedTeacher = "Teacher/MostRatedTeacher"
    case MostBookedTeacher = "SubjectOrLessonTeachers/GetTeachersMostBooked"
    case GetTeacherProfileView = "Teacher/TeacherProfileView"
    
    case GetHomeSubjectDetails = "SubjectSemesterYear/GetSubjectLessons"
    
    case GetSubjectOrLessonTeachers = "SubjectOrLessonTeachers/GetAllTeacher"
    
    case GetTeacherSubjectGroupDetail = "SubjectOrLessonTeachers/GetTeacherSubjectGroupDetail"
    case GetTeacherLessonGroupDetail = "SubjectOrLessonTeachers/GetTeacherLessonGroupDetail"
    case GetTeacherAvaliableSchedual = "SubjectOrLessonTeachers/GetTeacherAvaliableSchedual"
    
    case GetCheckOutBookTeacherSession = "BookTeacherLessonSession/GetCheckOutBookTeacherSession"
    case CreateBookTeacherSession = "BookTeacherLessonSession/CreateBookTeacherLessonSession"

    // MARK: -- student completed lessons --
    case GetStudentCompletedLessons = "StudentCompletedLesson/GetStudentCompletedLessons"
    case GetStudentCompletedLessonDetails = "StudentCompletedLesson/GetStudentLessonMaterials"
    case GetBookedStudentSubjects = "Student/GetBookedStudentSubjects"
    case GetBookedStudentLessons = "Student/GetBookedStudentLessons"

    // MARK: -- student Calendar Schedual --
    case GetStudentCalenderSchedual = "StudentCalenderSchedule/GetMyCalenderSchedual"
    case CancelStudentCalenderSchedual = "StudentCalenderSchedule/CancelBookLessonSession"
    case StudentAttendanceCalenderSchedual = "StudentCalenderSchedule/StudentAttendance"
 
    // MARK: -- Chats --
    case GetStudentAllStudentsChat = "StudentLessonSessionComment/GetAllTeachersChatWithStudent"
    case GetStudentAllStudentsChatComments = "StudentLessonSessionComment/GetAllLessonChatByStudent"
    case CreateStudentComment = "StudentLessonSessionComment/CreateComment"
    
    // MARK: -- student profile --
    case GetStudentProfile = "Student/Profile"
    case UpdateStudentProfile = "Student/UpdateProfile"
    case GetStudentProfileByParent = "Student/GetStudentProfile"
    
    //MARK: - firebase notifications -
    case UpdateTeacherDeviceToken = "Teacher/UpdateTeacherDeviceToken"
    case UpdateStudentDeviceToken = "Student/UpdateStudentDeviceToken"
    case UpdateParentDeviceToken = "Parent/UpdateParentDeviceToken"
    
    //MARK: - Student Finance -
    case GetStudentFinance = "student/FinanceView"
    case GetStudentPagedFinanceLessons = "student/PagedFinanceLessons"
    case GetStudentPagedFinanceSubjects = "student/PagedFinanceSubjects"

    //MARK: - Student Finance -
    case GetTeacherFinance = "Teacher/TeacherFinance"
    case GetTeacherdPurchasedFinanceLessons = "Teacher/TeacherPurchasedLessons"
    case GetTeacherPurchasedFinanceSubjects = "Teacher/TeacherPurchasedSubjects"
    
    //MARK: - Student Add Rate -
    case StudentAddRate = "TeacherLesson/StudentAddRate"

    //MARK: - Delete Account -
    case DeleteAccount = "Settings/DeleteAccount"

}

enum ParentEndPoints:String{
    // MARK: -- parent --
    case GetMyChildren = "Parent/GetMyChildren"
    case CreateStudentByParent = "Student/CreateByParent"
    case DeleteStudentByParent = "Student/Delete"

    case GetParentProfile = "Parent/Profile"
    case UpdateParentProfile = "Parent/UpdateProfile"

}



