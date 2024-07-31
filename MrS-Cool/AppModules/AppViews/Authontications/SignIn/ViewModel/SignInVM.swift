//
//  SignInVM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/10/2023.
//

import Combine
import Foundation
import SwiftUI

class SignInVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var selectedUser : UserType
//    @State var selectedUser : UserType = UserType.init()

    @Published var phone = "" {
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
    @Published var isPasswordvalid :Bool? = true
    
    //  MARK: -- validations --
    // Published properties for length validation
    @Published var isFormValid = false
    
    //    MARK: --- outpust ---
    @Published var isLogedin = false
    
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?
    
    @Published var teachermodel: TeacherModel?{
        didSet{
            if teachermodel != nil{
                isLogedin = true
                Helper.shared.saveUser(user: teachermodel)
                if Helper.shared.getSelectedUserType() == .Teacher &&  teachermodel?.profileStatusID != 3{
                    Helper.shared.IsLoggedIn(value: false)
                }
            }
        }
    }
    init(selecteduser : UserType){
        selectedUser = selecteduser
        monitorTextFields()
    }
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}

extension SignInVM{
    func TeacherLogin(){
        guard checkValidfields() else {return}
        
        isLogedin = false
        //        guard let genderid = selectedGender?.id, let cityid = city?.id else {return}
        let parameters:[String:Any] = ["mobile":phone,"password":Password]
        
        //        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        let target = Authintications.TeacherLogin(user: Helper.shared.getSelectedUserType() ?? .Teacher, parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherModel>.self)
            .receive(on: DispatchQueue.main)
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
                    self.teachermodel = model
                    FirebaseNotificationsVM.shared.SendFirebaseToken()
                    
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
        // Combine publishers for form validation
        Publishers.CombineLatest($phone, $Password)
            .map { [weak self] phone, password in
                // Perform the validation checks
                let isPhoneValid = !phone.isEmpty
                let isPasswordValid = !password.isEmpty
                
                // Return the overall form validity
                return isPhoneValid && isPasswordValid
            }
            .assign(to: &$isFormValid)
    }
    
    private func checkValidfields()->Bool{
        isphonevalid = phone.count == 11
        isPasswordvalid = Password.count >= 6
        // Publisher for checking if the phone is 11 char
        //        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
        //            $phone
        //                .map { phone in
        //                    return phone.count == 11
        //                }
        //                .eraseToAnyPublisher()
        //        }
        return isphonevalid ?? true && isPasswordvalid ?? true
    }
}
