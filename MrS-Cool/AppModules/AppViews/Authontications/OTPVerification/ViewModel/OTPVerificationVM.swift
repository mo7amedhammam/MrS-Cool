//
//  OTPVerificationVM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/10/2023.
//

import Foundation
import Combine

class OTPVerificationVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    var mobile: String?
    @Published var CurrentOtp: String?
    @Published var remainingSeconds: String?

    @Published var EnteredOtp: String?{
        didSet{
            if EnteredOtp?.count == 6 {
                VerifyOtp()
            }
        }
    }
 
    //    MARK: --- outputs ---
    @Published var newOTPM : OtpM?
    @Published var isOTPVerified : Bool = false


    //    MARK: --- States ---
        @Published var isLoading : Bool?
        @Published var isError : Bool = false
        @Published var error: Error?

//    private var countdownTimer: AnyCancellable?
     init() {
         // Initialize the timer when the view model is created
//         self.countdownTimer = setupCountdownTimer()
     }
    
    func SendOtp() {
        guard let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["mobile" : mobile ]
        isLoading = true
        // Create your API request with the username and password
        let target = Authintications.SendOtpTeacher(parameters: parametersarr)

        // Make the API call using your APIManager or networking code
        BaseNetwork.CallApi(target, BaseResponse<OtpM>.self)
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
            }, receiveValue: {[weak self] receivedData in
                    guard let self = self else{return}
                    print("receivedData",receivedData)
                if let model = receivedData.data{
//                        newOTPM = model
                    CurrentOtp = String(newOTPM?.otp ?? 0)
                    remainingSeconds = String(newOTPM?.secondsCount ?? 0)

                    }else{
                        isError =  true
                        error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                    }
                    isLoading = false
            }).store(in: &cancellables)
     }
    
    
    func VerifyOtp() {
        guard let otp = EnteredOtp ,let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["otp" : otp,"mobile" : mobile ]
        isLoading = true
        // Create your API request with the username and password
        let target = Authintications.VerifyOtpTeacher(parameters: parametersarr)
        
        // Make the API call using your APIManager or networking code
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
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if  receivedData.success == true{
                    guard let model = receivedData.data else{return}
                    Helper.saveUser(user: model  )
                        isOTPVerified = true
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            }).store(in: &cancellables)
    }
    
    

    
}
