//
//  ChangePasswordVM.swift
//  MrS-Cool
//
//  Created by wecancity on 16/11/2023.
//

//import Foundation


//
//  SignInVM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/10/2023.
//

import Combine
import Foundation
//import SwiftUI

//struct StateHandler1 {
//    var isLoading:Binding<Bool?>
//    var isError:Binding<Bool>
//    var alert:Binding<AlertType>
//}

//final class Shared {
//    
//    static var shared = Shared()
//    var state : Binding<StateHandler1> = .constant(StateHandler1(isLoading: .constant(false), isError: .constant(false), alert: .constant(.error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "",mainBtnAction: {},secondBtnAction: {}))))
//}

class ChangePasswordVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
//    @Published var selecteduser = UserType()
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""

    //  MARK: -- validations --
    // Published properties for length validation
    @Published var isFormValid = false
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?
    
    @Published var isPasswordChanged: Bool = false
    init()  {
        //        getGendersArr()
        
                monitorTextFields()
    }
}

extension ChangePasswordVM{
    func ChangePassword(){
        //        guard let genderid = selectedGender?.id, let cityid = city?.id else {return}
        let parameters:[String:Any] = ["currentPassword":currentPassword,"newPassword":newPassword]
        
        //        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        guard let user = Helper.shared.getSelectedUserType() else {return}
        let target = Authintications.ChangePassword(user: user, parameters: parameters)
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
                    isPasswordChanged = true
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
}

extension ChangePasswordVM{
    private func monitorTextFields() {
        
        // Combine publishers for form validation
              Publishers.CombineLatest3($currentPassword,$newPassword, $confirmNewPassword)
                  .map { [weak self] currentPassword, newPassword,confirmNewPassword in
                      // Perform the validation checks
                      guard let self = self else {return false}
                      let isPhoneValid = self.currentPassword.count >= 6
                      let isPasswordValid = self.newPassword.count >= 6
                      let isNewPasswordMatched = self.newPassword == self.confirmNewPassword

                      // Return the overall form validity
                      return isPhoneValid && isPasswordValid && isNewPasswordMatched
                  }
                  .assign(to: &$isFormValid)
    }
}
