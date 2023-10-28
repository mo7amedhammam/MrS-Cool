//
//  SignInVM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/10/2023.
//

import Combine
import Foundation

class SignInVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var selecteduser = UserType()
    @Published var phone = ""
    @Published var Password = ""
    
    //  MARK: -- validations --
    // Published properties for length validation
    @Published var isPhoneValid = false
    @Published var isPasswordValid = false
    @Published var isFormValid = false
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?
    
    @Published var teachermodel: TeacherModel?{
        didSet{
            if teachermodel != nil{
                Helper.saveUser(user: teachermodel)
            }
        }
    }
    init()  {
        //        getGendersArr()
        
//                monitorTextFields()
    }
}

extension SignInVM{
    func TeacherLogin(){
        //        guard let genderid = selectedGender?.id, let cityid = city?.id else {return}
        let parameters:[String:Any] = ["mobile":phone,"password":Password]
        
        //        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        let target = Authintications.TeacherLogin(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherModel>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = error
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    teachermodel = model
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
}

extension SignInVM{
    private func monitorTextFields() {
        // Limit phone to 11 characters
//        $phone
//              .map { phone in
//                  let limitedPhone = String(phone.prefix(11)) // Limit phone to 11 characters
//                  return limitedPhone
//              }
//              .assign(to: &$phone) // Assign back the limited phone to the @Published variable
//              .store(in: &cancellables)
        
        // Publisher for phone input validation
        $phone
            .map { $0.count == 11 }  // Check if the phone input is of exact 11 characters
            .assign(to: &$isPhoneValid)
        
        // Publisher for password input validation
        $Password
            .map { $0.count >= 6 }  // Check if the password input is at least 6 characters
            .assign(to: &$isPasswordValid)
        
        var isformValid: AnyPublisher<Bool, Never> {
               Publishers.CombineLatest($isPhoneValid, $isPasswordValid)
                   .map { $0 && $1 }
                   .eraseToAnyPublisher()
        }
        
        isformValid.sink(receiveValue: { [self]val in
            self.isFormValid = val
        })
        .store(in: &cancellables)
    }
}
