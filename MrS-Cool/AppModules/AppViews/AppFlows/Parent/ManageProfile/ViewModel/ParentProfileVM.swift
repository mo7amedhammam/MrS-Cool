//
//  ParentProfileVM.swift
//  MrS-Cool
//
//  Created by wecancity on 02/04/2024.
//

import Combine
import SwiftUI

class ParentProfileVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
//    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    @Published var image : UIImage?
    @Published var imageStr : String?
    @Published var name = ""
    @Published var code = ""
    @Published var accountStatus : ProfileStatus?

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
//    @Published var OtpM: OtpM?{
//        didSet{
//            isDataUploaded = true
//        }
//    }
    
    init()  {
//        getGendersArr()
        GetParentProfile()
    }
}

extension ParentProfileVM{
    
    func GetParentProfile(){
//        guard let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
//        let parameters:[String:Any] = ["Name":name,"Mobile":phone,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
        
//        print("parameters",parameters)
        let target = ParentServices.GetParentProfile
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
//                    self.error = error
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")

                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
//                    OtpM = model
                    fillParentData(model: model)
                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func UpdateParentProfile(){
        guard let birthDateStr = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS"),let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
        var parameters:[String:Any] = ["Name":name,"Email":email,"Birthdate":birthDateStr,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
        if let image = image {
            parameters["TeacherImage"] = image
        }
        print("parameters",parameters)
        let target = ParentServices.UpdateParentProfile(parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<ParentProfileM>.self, progressHandler: {progress in})
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
//                    OtpM = model
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

extension ParentProfileVM{
    private func fillParentData(model:ParentProfileM){
//        guard let model = model else { return }
        name = model.name ?? ""
        imageStr =  model.image ?? ""
        code = model.code ?? ""
//        accountStatus = .init(ProfileStatus(statusId: model.statusID,statusName: model.statusName))
        phone = model.mobile ?? ""
        selectedGender = .init(id:model.genderID,Title:model.genderID == 1 ? "Male":"Female" )
//        isTeacher = model.isTeacher ?? true
        country = .init(id:model.countryID,Title: model.countryName)
        governorte = .init(id:model.governoratedID,Title: model.governorateName)
        city = .init(id:model.cityID,Title: model.cityName)
        birthDateStr = model.birthdate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd  MMM  yyyy")
        email =  model.email ?? ""
//        bio = model.teacherBio ?? ""
    }
}


