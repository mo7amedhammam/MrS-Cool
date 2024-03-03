//
//  StudentEditProfileVM.swift
//  MrS-Cool
//
//  Created by wecancity on 03/03/2024.
//
import Foundation
import Combine
import UIKit

class StudentEditProfileVM: ObservableObject {
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


//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
//    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")


    @Published var isDataUpdated: Bool = false
//    @Published var OtpM: OtpM?
    
//    @Published var isTeacherHasSubjects: Bool = false
//    @Published var isTeacherHasDocuments: Bool = false
    init()  {
        GetStudentProfile()
    }
}

extension StudentEditProfileVM{
//    func RegisterStudent(){
//        guard let genderid = selectedGender?.id,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS"), let academicYearId = academicYear?.id else {return}
//        let parameters:[String:Any] = ["name":name,"mobile":phone,"genderId":genderid,"birthdate":birthdate, "academicYearEducationLevelId":academicYearId]
//        
////        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
//        print("parameters",parameters)
//        let target = Authintications.Register(user: .Student, parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<OtpM>.self)
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
//                    OtpM = model
//                    isDataUploaded = true
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
    
//    func clearSelections(){
//        name = ""
//        phone = ""
//        selectedGender = nil
//        educationType = nil
//        educationLevel = nil
//        academicYear = nil
//
////        Password = ""
////        confirmPassword = ""
////        acceptTerms = false
//        
////        birthDate = nil
//        birthDateStr = ""
//    }
    private func fillTeacherData(model:StudentProfileM){
//        guard let model = model else { return }
        name = model.name ?? ""
        imageStr =  model.image ?? ""
        code = model.code ?? ""
//        accountStatus = .init(ProfileStatus(statusId: model.statusID,statusName: model.statusName))
        phone = model.mobile ?? ""
        selectedGender = .init(id:model.genderID,Title:model.genderID == 1 ? "Male":"Female" )
//        isTeacher = model.isTeacher ?? true
        country = .init(id:model.countryID,Title: model.countryName)
        governorte = .init(id:model.governorateID,Title: model.governorateName)
        city = .init(id:model.cityID,Title: model.cityName)
        educationType = .init(id:model.educationTypeID ,Title:model.educationTypeName)
        educationLevel = .init(id:model.educationLevelID,Title:model.educationLevelName)
        academicYear = .init(id:model.academicYearEducationLevelID,Title:model.academicYearName)
        birthDateStr = model.birthdate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd  MMM  yyyy")
        email =  model.email ?? ""
        SchoolName = model.schoolName ?? ""
    }
    
    func GetStudentProfile(){
//        guard let IsTeacher = isTeacher,let genderid = selectedGender?.id, let cityid = city?.id else {return}
//        let parameters:[String:Any] = ["Name":name,"Mobile":phone,"GenderId":genderid, "CityId":cityid,"IsTeacher":IsTeacher,"TeacherBio":bio]
        
//        print("parameters",parameters)
        let target = StudentServices.GetStudentProfile
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<StudentProfileM>.self)
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
                    fillTeacherData(model: model)
                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func UpdateStudentProfile(){
        guard let genderid = selectedGender?.id,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS"), let academicYearId = academicYear?.id,let cityid = city?.id else {return}
        var parameters:[String:Any] = ["Name":name,"mobile":phone,"GenderId":genderid,"Birthdate":birthdate, "AcademicYearEducationLevelId":academicYearId,"CityId":cityid,"Email":email,"SchoolName":SchoolName]

//        guard let birthDateStr = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS"),let genderid = selectedGender?.id, let cityid = city?.id else {return}
//        var parameters:[String:Any] = ["Name":name,"Email":email,"Birthdate":birthDateStr,"GenderId":genderid, "CityId":cityid]
        if let image = image {
            parameters["StudentImage"] = image
        }
        print("parameters",parameters)
        let target = StudentServices.UpdateStudentProfile(parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<StudentProfileM>.self, progressHandler: {progress in})
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
                    isDataUpdated = true
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




