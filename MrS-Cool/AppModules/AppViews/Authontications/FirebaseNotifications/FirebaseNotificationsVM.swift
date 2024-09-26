//
//  FirebaseNotificationsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 04/04/2024.
//


import Combine
import Foundation
import FirebaseMessaging

class FirebaseNotificationsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    static let shared = FirebaseNotificationsVM()

    //    MARK: --- inputs ---


    //  MARK: -- validations --
    // Published properties for length validation
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?
//    
//    @Published var OtpM: OtpM?
//
//    @Published var isOtpReceived: Bool = false
//    @Published var isPasswordReset: Bool = false

    init()  {
//                monitorTextFields()
    }
}

extension FirebaseNotificationsVM{
    func SendFirebaseToken(){
        guard let fcmtoken = Messaging.messaging().fcmToken else {return}
        let parameters:[String:Any] = ["firebaseDeviceToken":fcmtoken]
        
        print("parameters",parameters)
//        guard let user = Helper.shared.getSelectedUserType() else {return}
        let target = Authintications.SendFirebaseToken( parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<ParentProfileM>.self)
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
                    print("firebase device token updated",model)
//                    OtpM = model
//                    isOtpReceived = true
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
//    func RemoveFirebaseToken(){
//        //        guard let genderid = selectedGender?.id, let cityid = city?.id else {return}
//        let parameters:[String:Any] = ["mobile":phone,"newPassword":newPassword]
//        
//        //        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
//        print("parameters",parameters)
//        guard let user = Helper.shared.getSelectedUserType() else {return}
//        let target = Authintications.ResetPassword(user: user, parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<ChangePasswordM>.self)
//            .receive(on: DispatchQueue.main)
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
//                if receivedData.success == true{
////                    teachermodel = model
//                    isPasswordReset = true
//                }else{
//                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }
}


