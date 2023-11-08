//
//  ManageTeacherProfileVM.swift
//  MrS-Cool
//
//  Created by wecancity on 08/11/2023.
//

import Combine
import SwiftUI

class ManageTeacherProfileVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    @Published var image : UIImage? 
    @Published var imageStr : String?
    @Published var name = ""
    @Published var id = ""
    @Published var phone = ""
    @Published var selectedGender : DropDownOption?

    
    //Teacher personal data
    @Published var isTeacher : Bool?
    @Published var country : DropDownOption?
    @Published var governorte : DropDownOption?
    @Published var city : DropDownOption?
    @Published var birthDateStr : String?
    @Published var email = ""
    @Published var bio = ""

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
    
    init()  {
//        getGendersArr()
    }
}

extension ManageTeacherProfileVM{
    func GetTeacherProfile(){
        
    }
    
    func UpdateTeacherProfile(){
        guard let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
        let parameters:[String:Any] = ["Name":name,"Mobile":phone,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
        
        print("parameters",parameters)
        let target = Authintications.Register(user: .Teacher, parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<OtpM>.self, progressHandler: {progress in})
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
    
}




