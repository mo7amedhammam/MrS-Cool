//
//  TeacherSubjectsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/10/2023.
//

import Foundation
import Combine

class TeacherSubjectsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
//    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
//    @Published var selecteduser = UserType()
//    @Published var name = ""
//    @Published var phone = ""
//    @Published var Password = ""
//    @Published var selectedGender : DropDownOption?
//    @Published var confirmPassword = ""
//    @Published var acceptTerms = false

    //Student data
//    @Published var birthDate : Date?
//    // next 4  common with teacher subjects
//    @Published var birthDateStr = ""
    
    @Published var educationType : DropDownOption?{
        didSet{
            educationLevel = nil
        }
    }
    @Published var educationLevel : DropDownOption?{
        didSet{
            if educationLevel == nil {
                academicYear = nil
            }
        }
    }
    @Published var academicYear : DropDownOption?{
        didSet{
            if academicYear == nil {
                subject = nil
            }
        }
    }
    @Published var subject : DropDownOption?

    //Teacher personal data
//    @Published var isTeacher : Bool?
//    @Published var country : DropDownOption?
//    @Published var governorte : DropDownOption?
//    @Published var city : DropDownOption?
//    @Published var bio = ""

    //Teacher subjects data (have 4 common with student)

    //Teacher documents data
//    @Published var documentType : DropDownOption?
//    @Published var documentTitle : DropDownOption?
//    @Published var documentOrder : String?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?

    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherSubjects : [DropDownOption]?{
        didSet{
            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
        }
    }

    init()  {
//        getGendersArr()
    }
}

extension TeacherSubjectsVM{
    
//    func AddSubject(){
//        guard let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
//        let parameters:[String:Any] = ["Name":name,"Mobile":phone,"PasswordHash":Password,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
//        
////        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
//        print("parameters",parameters)
//        let target = Authintications.TeacherRegisterDate(parameters: parameters)
//        isLoading = true
//        BaseNetwork.uploadApi(target, BaseResponse<OtpM>.self, progressHandler: {progress in})
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
//                    self.error = error
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if let model = receivedData.data{
//                    OtpM = model
//                }else{
//                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }
    

//    func GetTeacherSubjects(){
//        
//        guard let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
//        let parameters:[String:Any] = ["Name":name,"Mobile":phone,"PasswordHash":Password,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
//        
////        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
//        print("parameters",parameters)
//        let target = Authintications.TeacherRegisterDate(parameters: parameters)
//        isLoading = true
//        BaseNetwork.uploadApi(target, BaseResponse<OtpM>.self, progressHandler: {progress in})
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
//                    self.error = error
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if let model = receivedData.data{
//                    OtpM = model
//                }else{
//                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }
    
    
    
    func clearTeachersSubject(){
        educationType = nil
        educationLevel = nil
        academicYear = nil
        subject = nil
    }


}




