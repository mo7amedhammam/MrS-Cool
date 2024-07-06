//
//  OTPVerificationVM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/10/2023.
//

import Foundation
import Combine

enum VerifyCases{
    case creatinguser,ressetingpassword,addexistingstudent,addnewstudent
}
class OTPVerificationVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []

    var mobile: String?
    var verifycase: VerifyCases = .creatinguser
    
    @Published var CurrentOtp: String?

    @Published var remainingSeconds: Int = 0
    var countdownTimer: AnyCancellable?

    @Published var EnteredOtp: String?{
        didSet{
            if EnteredOtp?.count == 6 {
                VerifyOtp(verifycase: verifycase)
            }
        }
    }
 
    //    MARK: --- outputs ---
    @Published var newOTPM : OtpM?
    @Published var isOTPVerified : Bool = false

    @Published var isResetOTPVerified : Bool = false

    //    MARK: --- States ---
        @Published var isLoading : Bool?
        @Published var isError : Bool = false
        @Published var error: Error?

     init() {
         // Initialize the timer when the view model is created
     }
    
    func SendOtp() {
        EnteredOtp = nil

//        EnteredOtp?.removeAll()
        guard let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["mobile" : mobile ]
        isLoading = true
        // Create your API request with the username and password
//        let target = Authintications.SendOtp(user: Helper.shared.getSelectedUserType() ?? .Teacher,parameters: parametersarr)
        
            let target = switch verifycase {
            case .creatinguser,.ressetingpassword:
                Authintications.SendOtp(user: Helper.shared.getSelectedUserType() ?? .Teacher,parameters: parametersarr)

            case .addexistingstudent,.addnewstudent: // for case if parent adding student
                Authintications.SendOtp(user: .Student,parameters: parametersarr)
            }

        // Make the API call using your APIManager or networking code
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
            }, receiveValue: {[weak self] receivedData in
                    guard let self = self else{return}
                    print("receivedData",receivedData)
                if receivedData.success == true{
                    CurrentOtp = String(receivedData.data?.otp ?? 0)
                    remainingSeconds = receivedData.data?.secondsCount ?? 0
                    startCountdownTimer(seconds: remainingSeconds)
                    }else{
                        isError =  true
                        error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                    }
                    isLoading = false
            }).store(in: &cancellables)
     }
    
    
    func VerifyOtp(verifycase:VerifyCases) {
        guard let otp = EnteredOtp ,let mobile = mobile else {
            // Handle missing username or password
            return
        }
        let parametersarr : [String : Any] =  ["otp" : otp,"mobile" : mobile ]
        isLoading = true
        // Create your API request with the username and password
        let target = switch verifycase {
        case .creatinguser:
             Authintications.VerifyOtpUser(user: Helper.shared.getSelectedUserType() ?? .Teacher,parameters: parametersarr)
            
        case .ressetingpassword:
            Authintications.VerifyOtpReset(user:Helper.shared.getSelectedUserType() ?? .Teacher,parameters: parametersarr)
            
        case .addexistingstudent:// for case if parent adding existing student
            Authintications.VerifyOtpReset(user:.Student,parameters: parametersarr)
            
        case .addnewstudent: // for case if parent adding new student
            Authintications.VerifyOtpUser(user: .Student,parameters: parametersarr)
            
        }
        
        // Make the API call using your APIManager or networking code
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
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true{
                    
                    switch verifycase {
                    case .creatinguser:
                        guard let model = receivedData.data else{return}
                        isOTPVerified = true
                        Helper.shared.saveUser(user: model)
                        if Helper.shared.getSelectedUserType() != .Teacher{
                            FirebaseNotificationsVM.shared.SendFirebaseToken()
                        }else{ // teacher
                            Helper.shared.IsLoggedIn(value: false)
                        }
                    case .ressetingpassword:
                        isResetOTPVerified = true
                        
                    case .addexistingstudent,.addnewstudent:
                        isOTPVerified = true
                        
//                    case .addnewstudent:
//                        guard let model = receivedData.data else{return}
//                        Helper.shared.saveUser(user: model)
//                            isOTPVerified = true

                    }
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                }
                isLoading = false
            }).store(in: &cancellables)
    }
    
}

extension OTPVerificationVM{
    func startCountdownTimer(seconds: Int) {
           // Initialize the countdown with the provided seconds
           remainingSeconds = seconds

           countdownTimer = Timer.publish(every: 1, on: .main, in: .default)
               .autoconnect()
               .sink { [weak self] _ in
                   guard let self = self else { return }
                   if self.remainingSeconds > 0 {
                       self.remainingSeconds -= 1
                   } else {
                       // Timer has reached 0, stop the countdown
                       self.countdownTimer?.cancel()
                   }
               }
       }
}
