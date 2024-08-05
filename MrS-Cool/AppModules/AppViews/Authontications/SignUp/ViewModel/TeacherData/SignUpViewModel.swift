//
//  SignUpViewModel.swift
//  MrS-Cool
//
//  Created by wecancity on 23/10/2023.
//

import Combine
import Foundation
import UIKit
//struct CustomState{
//    var isLoading:Bool?
//    var isError:Bool?
//    var error: Error?
//}
class SignUpViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
//    @Published var selecteduser = UserType()
    @Published var image : UIImage?{
        didSet{
            if image != nil {
                isimagevalid = true
            }
        }
    }
    @Published var isimagevalid : Bool? = true
    
    @Published var imageStr : String?

    @Published var name = ""
    @Published var phone = ""{
        didSet{
            if phone.count == 11{
                isphonevalid = true
            }
        }
    }
    @Published var isphonevalid : Bool? = true

    @Published var Password = ""{
        didSet{
            if Password.count >= 6{
                isPasswordvalid = true
            }
        }
    }
    @Published var isPasswordvalid : Bool? = true
    @Published var selectedGender : DropDownOption?
    @Published var confirmPassword = ""{
        didSet{
            if !confirmPassword.isEmpty{
                if  confirmPassword == Password {
                    isconfirmPasswordvalid = true
                }else{
                    isconfirmPasswordvalid = false
                }
            }
        }
    }
    @Published var isconfirmPasswordvalid : Bool? = true
    @Published var acceptTerms = false

    //Student data
//    @Published var birthDate : Date?
//    // next 4  common with teacher subjects
//    @Published var birthDateStr = ""
//    @Published var educationType : DropDownOption?
//    @Published var educationLevel : DropDownOption?
//    @Published var academicYear : DropDownOption?
    
    //Teacher personal data
    @Published var isTeacher : Bool? = true
    @Published var country : DropDownOption?
    @Published var governorte : DropDownOption?
    @Published var city : DropDownOption?
    @Published var bio = ""

    //Teacher subjects data (have 4 common with student)
//    @Published var subject : DropDownOption?

    //Teacher documents data
    @Published var isFormValid : Bool =  false
//    @Published var documentTitle : DropDownOption?
//    @Published var documentOrder : String?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
//    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var isDataUploaded: Bool = false
    @Published var OtpM: OtpM?{
        didSet{
            isDataUploaded = true
        }
    }
    
    @Published var isTeacherHasSubjects: Bool = false
    @Published var isTeacherHasDocuments: Bool = false
    init()  {
//        getGendersArr()
        setupFormValidation()
    }
}

extension SignUpViewModel{
    func RegisterTeacherData(){
        guard checkValidfields() else{return}

        guard let teacherImage = image,let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
        var parameters:[String:Any] = ["TeacherImage":teacherImage,"Name":name,"Mobile":phone,"PasswordHash":Password,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher]
        parameters["TeacherBio"] = bio
//        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        let target = Authintications.Register(user: .Teacher, parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<OtpM>.self, progressHandler: {progress in})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
//                    self.error = error
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")

                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    OtpM = model
                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearSelections(){
        image = nil
        name = ""
        phone = ""
        selectedGender = nil
        Password = ""
        confirmPassword = ""
        acceptTerms = false
        country = nil
        governorte = nil
        city = nil
        bio = ""
        
//        birthDate = nil
//        birthDateStr = ""
    }
    
//    func clearTeachersSubject(){
//        educationType = nil
//        educationLevel = nil
//        academicYear = nil
//        subject = nil
//    }

//    func clearTeachersDocument(){
//        documentType = nil
//        documentTitle = nil
//        documentOrder = nil
//    }

}




extension SignUpViewModel{
    
    // Publisher for checking if the name is not empty
    var isNameValidPublisher: AnyPublisher<Bool, Never> {
        $name
            .map { name in
                return !name.isEmpty
            }
            .eraseToAnyPublisher()
    }
    // Publisher for checking if the phone is not empty and 11 char
    var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
        $phone
            .map { phone in
                return !phone.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the gender is not empty
    var isGenderSelectedPublisher: AnyPublisher<Bool, Never> {
        $selectedGender
            .map { gender in
                return gender != nil
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the educationtype is not empty
    var isCountrySelectedPublisher: AnyPublisher<Bool, Never> {
        $country
            .map { country in
                return country != nil
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the educationlevel is not empty
    var isGovernorateSelectedPublisher: AnyPublisher<Bool, Never> {
        $governorte
            .map { governorte in
                return governorte != nil
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the academicyear is not empty
    var isCitySelectedPublisher: AnyPublisher<Bool, Never> {
        $city
            .map { city in
                return city != nil
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the password is not empty and meets the length requirement
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $Password
            .map { password in
                return !password.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the confirmPassword matches the Password
    var isConfirmPasswordValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($Password, $confirmPassword)
            .map { password, confirmPassword in
                return confirmPassword == password
            }
            .eraseToAnyPublisher()
    }
    
    
    // Publisher for checking if the user has accepted the terms
    var hasAcceptedTermsPublisher: AnyPublisher<Bool, Never> {
        $acceptTerms
            .eraseToAnyPublisher()
    }
    
    
    // Publisher for checking if the personal data is valid
    var isPersonalInfoValid : AnyPublisher<Bool,Never>{
        Publishers.CombineLatest3(isNameValidPublisher,isPhoneValidPublisher,isGenderSelectedPublisher)
            .map{valid1,valid2,valid3 in
                guard valid1 && valid2 && valid3  else{return false}
                return true
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the academic data is valid
    var isAddressInfoValid : AnyPublisher<Bool,Never>{
        Publishers.CombineLatest3(isCountrySelectedPublisher,isGovernorateSelectedPublisher,isCitySelectedPublisher)
            .map{valid1,valid2,valid3 in
                guard valid1 && valid2 && valid3  else{return false}
                return true
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the password & its confirmation is valid
    var isPasswordValid : AnyPublisher<Bool,Never>{
        Publishers.CombineLatest3(isPasswordValidPublisher,isConfirmPasswordValidPublisher,hasAcceptedTermsPublisher)
            .map{valid1,valid2,valid3 in
                guard valid1 && valid2 && valid3  else{return false}
                return true
            }
            .eraseToAnyPublisher()
    }
    
    
    private func setupFormValidation() {
        Publishers.CombineLatest3(isPersonalInfoValid, isAddressInfoValid, isPasswordValid)
            .map { valid1,valid2,valid3 in
                guard valid1 && valid2 && valid3  else{return false}
                return true
            }
            .assign(to: &$isFormValid)
        
    }
    
    private func checkValidfields()->Bool{
        isimagevalid = image?.size.width ?? 0 > 0
        isphonevalid = phone.count == 11
        isPasswordvalid = Password.count >= 5
        isconfirmPasswordvalid = confirmPassword.count >= 5 && Password == confirmPassword
        return isimagevalid ?? true && isphonevalid ?? true && isPasswordvalid ?? true && isconfirmPasswordvalid ?? true
    }
}
