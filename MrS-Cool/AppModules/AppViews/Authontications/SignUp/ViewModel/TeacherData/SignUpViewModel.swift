//
//  SignUpViewModel.swift
//  MrS-Cool
//
//  Created by wecancity on 23/10/2023.
//

import Combine
import Foundation

//struct CustomState{
//    var isLoading:Bool?
//    var isError:Bool?
//    var error: Error?
//}
class SignUpViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
//    @Published var selecteduser = UserType()
    @Published var name = ""
    @Published var phone = ""
    @Published var Password = ""
    @Published var selectedGender : DropDownOption?
    @Published var confirmPassword = ""
    @Published var acceptTerms = false

    //Student data
    @Published var birthDate : Date?
    // next 4  common with teacher subjects
    @Published var birthDateStr = ""
    @Published var educationType : DropDownOption?
    @Published var educationLevel : DropDownOption?
    @Published var academicYear : DropDownOption?
    
    //Teacher personal data
    @Published var isTeacher : Bool?
    @Published var country : DropDownOption?
    @Published var governorte : DropDownOption?
    @Published var city : DropDownOption?
    @Published var bio = ""

    //Teacher subjects data (have 4 common with student)
    @Published var subject : DropDownOption?

    //Teacher documents data
    @Published var documentType : DropDownOption?
    @Published var documentTitle : DropDownOption?
    @Published var documentOrder : String?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
//    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var isDataUploaded: Bool = false
    @Published var OtpM: OtpM?{
        didSet{
            isDataUploaded = true
        }
    }
    
    @Published var isTeacherHasSubjects: Bool = false
    @Published var isTeacherHasDocuments: Bool = false
    init()  {
//        getGendersArr()
    }
}

extension SignUpViewModel{
    func RegisterTeacherData(){
        guard let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
        let parameters:[String:Any] = ["Name":name,"Mobile":phone,"PasswordHash":Password,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
        
//        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        let target = Authintications.Register(user: .Teacher, parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<OtpM>.self, progressHandler: {progress in})
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
        selectedGender = nil
        Password = ""
        confirmPassword = ""
        acceptTerms = false
        
        birthDate = nil
        birthDateStr = ""
    }
    
    func clearTeachersSubject(){
        educationType = nil
        educationLevel = nil
        academicYear = nil
        subject = nil
    }

    func clearTeachersDocument(){
        documentType = nil
        documentTitle = nil
        documentOrder = nil
    }

}




