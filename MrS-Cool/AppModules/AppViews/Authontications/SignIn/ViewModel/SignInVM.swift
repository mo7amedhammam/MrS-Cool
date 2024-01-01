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
    @Published var selecteduser = UserType()
    @Published var phone = "" 
    @Published var Password = ""
    
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
                }
        }
    }
    init()  {
        //        getGendersArr()
        
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
                      let isPhoneValid = phone.count == 11
                      let isPasswordValid = password.count >= 6
                      
                      // Return the overall form validity
                      return isPhoneValid && isPasswordValid
                  }
                  .assign(to: &$isFormValid)
    }
}
