//
//  ParentSignupVM.swift
//  MrS-Cool
//
//  Created by wecancity on 17/03/2024.
//

import Foundation
import Combine

class ParentSignupVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isUserChangagble = true // available unless teacher save personal data
    
    //    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    //    @Published var selecteduser = UserType()
    @Published var name = ""
    @Published var phone = ""{
        didSet{
            if phone.count == Helper.shared.getAppCountry()?.mobileLength ?? 11{
                isphonevalid = true
            }
        }
    }
    @Published var isphonevalid : Bool? = true
    @Published var email = ""{
        didSet{
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            if !email.isEmpty{
                if  emailPredicate.evaluate(with: email){
                    isemailvalid = true
                }else{
                    isemailvalid = false
                    }
                }
            }
    }
    
    @Published var isemailvalid : Bool? = true

    @Published var selectedGender : DropDownOption?

    @Published var country : DropDownOption?
    @Published var governorte : DropDownOption?
    @Published var city : DropDownOption?

    @Published var birthDateStr : String?
    
    @Published var Password = ""{
        didSet{
            if Password.count >= 6{
                isPasswordvalid = true
            }
        }
    }
    @Published var isPasswordvalid : Bool? = true
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
    
    
//    @Published var educationType : DropDownOption?
//    @Published var educationLevel : DropDownOption?
//    @Published var academicYear : DropDownOption?
    
    //Teacher personal data
    @Published var isFormValid : Bool = false
//    @Published var bio = ""

    //Teacher subjects data (have 4 common with student)
//    @Published var subject : DropDownOption?

    //Teacher documents data
//    @Published var documentType : DropDownOption?
//    @Published var documentTitle : DropDownOption?
//    @Published var documentOrder : String?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
//    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")


    @Published var isDataUploaded: Bool = false
    @Published var OtpM: OtpM?
    
//    @Published var isTeacherHasSubjects: Bool = false
//    @Published var isTeacherHasDocuments: Bool = false
    init()  {
//        getGendersArr()
        setupFormValidation()
    }
}

extension ParentSignupVM{
    func RegisterParent(){
        guard checkValidfields() else{return}
        guard let genderid = selectedGender?.id,let cityid = city?.id ,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current) else {return}
        var parameters:[String:Any] = ["name":name,"mobile":phone,"email":email,"passwordHash":Password,"genderId":genderid,"cityId":cityid,"birthdate":birthdate]
        if let appCountryId = Helper.shared.getAppCountry()?.id{
            parameters["appCountryId"] = appCountryId
        }
        
        print("parameters",parameters)
        let target = Authintications.Register(user: .Parent, parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<OtpM>.self)
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
                    isDataUploaded = true
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
        name = ""
        phone = ""
        email = ""
        selectedGender = nil
        country = nil
        governorte = nil
        city = nil
        //        educationType = nil
        //        educationLevel = nil
        //        academicYear = nil
        
        Password = ""
        confirmPassword = ""
        acceptTerms = false
        
        //        birthDate = nil
        birthDateStr = nil
    }
}

extension ParentSignupVM{
    
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
    
    // Publisher for checking if the birthDateStr is not empty
    var isBirthDateValidPublisher: AnyPublisher<Bool, Never> {
        $birthDateStr
            .map { birthDateStr in
                return birthDateStr != nil
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the birthDateStr is not empty
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { email in
                return !email.isEmpty
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
    var isgovernorateSelectedPublisher: AnyPublisher<Bool, Never> {
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
                return !confirmPassword.isEmpty
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
        Publishers.CombineLatest4(isNameValidPublisher,isPhoneValidPublisher,isGenderSelectedPublisher,isBirthDateValidPublisher)
            .map{valid1,valid2,valid3,valid4 in
                guard valid1 && valid2 && valid3 && valid4 else{return false}
                return true
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher for checking if the academic data is valid
    var isAddressInfoValid : AnyPublisher<Bool,Never>{
        Publishers.CombineLatest4(isEmailValidPublisher,isCountrySelectedPublisher,isgovernorateSelectedPublisher,isCitySelectedPublisher)
            .map{valid1,valid2,valid3,valid4 in
                guard valid1 && valid2 && valid3 && valid4  else{return false}
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
            isphonevalid = phone.count == Helper.shared.getAppCountry()?.mobileLength ?? 11
            isPasswordvalid = Password.count >= 5
            isconfirmPasswordvalid = confirmPassword.count >= 5 && Password == confirmPassword
        return isphonevalid ?? true && isPasswordvalid ?? true && isconfirmPasswordvalid ?? true
    }
}



