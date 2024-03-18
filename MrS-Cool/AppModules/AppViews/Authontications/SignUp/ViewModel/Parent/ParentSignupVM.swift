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
    @Published var phone = ""
    @Published var email = ""
    @Published var selectedGender : DropDownOption?

    @Published var country : DropDownOption?
    @Published var governorte : DropDownOption?
    @Published var city : DropDownOption?

    @Published var birthDateStr : String?
    @Published var Password = ""
    @Published var confirmPassword = ""
    @Published var acceptTerms = false

    //Student data
    
    
//    @Published var educationType : DropDownOption?
//    @Published var educationLevel : DropDownOption?
//    @Published var academicYear : DropDownOption?
    
    //Teacher personal data
//    @Published var isTeacher : Bool?
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
    }
}

extension ParentSignupVM{
    func RegisterParent(){
        guard let genderid = selectedGender?.id,let cityid = city?.id ,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS") else {return}
        let parameters:[String:Any] = ["name":name,"mobile":phone,"email":email,"passwordHash":Password,"genderId":genderid,"cityId":cityid,"birthdate":birthdate]
        
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
        birthDateStr = ""
    }
    

}





