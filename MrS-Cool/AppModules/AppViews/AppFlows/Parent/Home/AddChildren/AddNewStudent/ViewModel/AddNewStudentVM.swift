//
//  AddNewStudentVM.swift
//  MrS-Cool
//
//  Created by wecancity on 30/03/2024.
//

import Foundation
import Combine
import UIKit

class AddNewStudentVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    @Published var image : UIImage?
    @Published var imageStr : String?
    @Published var name = ""
    @Published var code = ""

    @Published var phone = ""
    @Published var selectedGender : DropDownOption?

    //Student data
//    @Published var birthDate : Date?
    // next 4  common with teacher subjects
    @Published var birthDateStr : String?
    
    @Published var educationType : DropDownOption?{
        didSet{
            educationLevel = nil
            academicYear = nil
        }
    }
    @Published var educationLevel : DropDownOption?{
        didSet{
            academicYear = nil
        }
    }
    @Published var academicYear : DropDownOption?
    @Published var email = ""
    @Published var SchoolName = ""

    @Published var country : DropDownOption?{
        didSet{
            governorte = nil
            city = nil
        }
    }
    @Published var governorte : DropDownOption?{
        didSet{
            city = nil
        }
    }
    @Published var city : DropDownOption?
    
    @Published var Password = ""
    @Published var confirmPassword = ""


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
//        GetStudentProfile()
    }
}

extension AddNewStudentVM{

//    private func fillTeacherData(model:StudentProfileM){
//        name = model.name ?? ""
//        imageStr =  model.image ?? ""
//        code = model.code ?? ""
//        phone = model.mobile ?? ""
//        selectedGender = .init(id:model.genderID,Title:model.genderID == 1 ? "Male":"Female" )
//        country = .init(id:model.countryID,Title: model.countryName)
//        governorte = .init(id:model.governorateID,Title: model.governorateName)
//        city = .init(id:model.cityID,Title: model.cityName)
//        educationType = .init(id:model.educationTypeID ,Title:model.educationTypeName)
//        educationLevel = .init(id:model.educationLevelID,Title:model.educationLevelName)
//        academicYear = .init(id:model.academicYearEducationLevelID,Title:model.academicYearName)
//        birthDateStr = model.birthdate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd  MMM  yyyy")
//        email =  model.email ?? ""
//        SchoolName = model.schoolName ?? ""
//    }
    
//    func GetStudentProfile(){
//        let target = StudentServices.GetStudentProfile
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<StudentProfileM>.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
////                    self.error = error
//                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if let model = receivedData.data{
////                    OtpM = model
//                    fillTeacherData(model: model)
//                }else{
//                    isError =  true
////                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
//                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }
    
    func AddNewStudent(){
        guard let genderid = selectedGender?.id,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS"), let academicYearId = academicYear?.id,let cityid = city?.id else {return}
        var parameters:[String:Any] = ["Name":name,"Mobile":phone,"GenderId":genderid,"Birthdate":birthdate, "AcademicYearEducationLevelId":academicYearId,"CityId":cityid,"Email":email,"SchoolName":SchoolName,"PasswordHash": Password]

        if let image = image {
            parameters["StudentImage"] = image
        }
        print("parameters",parameters)
        let target = ParentServices.AddNewChild(parameters: parameters)
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
                if receivedData.success == true{
                    OtpM = receivedData.data
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
    
}




