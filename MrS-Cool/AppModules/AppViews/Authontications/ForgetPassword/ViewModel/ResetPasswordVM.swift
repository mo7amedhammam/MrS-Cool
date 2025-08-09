//
//  ResetPasswordVM.swift
//  MrS-Cool
//
//  Created by wecancity on 20/03/2024.
//

import Combine
import Foundation
//import SwiftUI

class ResetPasswordVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var phone = ""{
        didSet{
            if phone.count == Helper.shared.getAppCountry()?.mobileLength ?? 11 {
                isPhoneValid = true
            }else{
                isPhoneValid = false
            }
        }
    }
    @Published var isPhoneValid = false

//    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    @Published var isFormValid = false

    //  MARK: -- validations --
    // Published properties for length validation
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?
    
    @Published var OtpM: OtpM?

    @Published var isOtpReceived: Bool = false
    @Published var isPasswordReset: Bool = false

    init()  {
//                monitorTextFields()
    }
}

extension ResetPasswordVM{
    func SendResetOtp(){
        //        guard let genderid = selectedGender?.id, let cityid = city?.id else {return}
        var parameters:[String:Any] = ["mobile":phone]
        if let appCountryId = Helper.shared.getAppCountry()?.id{
            parameters["appCountryId"] = appCountryId
        }
        print("parameters",parameters)
        guard let user = Helper.shared.getSelectedUserType() else {return}
        let target = Authintications.SendOtp(user: user, parameters: parameters)
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
                    self.error = error
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    OtpM = model
                    isOtpReceived = true
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func ResetPassword(){
        //        guard let genderid = selectedGender?.id, let cityid = city?.id else {return}
        var parameters:[String:Any] = ["mobile":phone,"newPassword":newPassword]
        if let appCountryId = Helper.shared.getAppCountry()?.id{
            parameters["appCountryId"] = appCountryId
        }
        
        //        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        guard let user = Helper.shared.getSelectedUserType() else {return}
        let target = Authintications.ResetPassword(user: user, parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<ChangePasswordM>.self)
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
                if receivedData.success == true{
//                    teachermodel = model
                    isPasswordReset = true
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
}

extension ResetPasswordVM{
     func monitorTextFields() {
        
        // Combine publishers for form validation
              Publishers.CombineLatest($newPassword, $confirmNewPassword)
                  .map { [weak self]  newPassword,confirmNewPassword in
                      // Perform the validation checks
                      guard let self = self else {return false}
//                      let isPhoneValid = self.currentPassword.count >= 6
                      let isPasswordValid = self.newPassword.count >= 6
                      let isNewPasswordMatched = self.newPassword == self.confirmNewPassword

                      // Return the overall form validity
                      return isPasswordValid && isNewPasswordMatched
                  }
                  .assign(to: &$isFormValid)
    }
}
