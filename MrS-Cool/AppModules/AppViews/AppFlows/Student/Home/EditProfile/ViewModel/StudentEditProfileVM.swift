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
    static let shared = StudentEditProfileVM()
    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    @Published var image : UIImage?
    @Published var imageStr : String?
    @Published var name = ""{
        didSet{
            if name.count >= 2{
                isnamevalid = true
            }
        }
    }
    @Published var isnamevalid : Bool?
    @Published var code = ""

    @Published var phone = ""
    @Published var selectedGender : DropDownOption?

    //Student data
//    @Published var birthDate : Date?
    // next 4  common with teacher subjects
    @Published var birthDateStr : String?
//    {
//        didSet{
//            isbirthDateStrvalid = birthDateStr == nil ? false:true
//        }
//    }
//    @Published var isbirthDateStrvalid : Bool?
//    
    @Published var educationType : DropDownOption?{
        didSet{
            educationLevel = nil
        }
    }
    @Published var educationLevel : DropDownOption?{
        didSet{
            academicYear = nil
            dummyAcademicYear = nil
            iseducationLevelvalid = educationLevel == nil ? false:true
        }
    }
    @Published var iseducationLevelvalid : Bool?

    @Published var dummyAcademicYear : DropDownOption?{
        didSet{
            isdummyacademicYearvalid = dummyAcademicYear == nil ? false:true
        }
    }
    @Published var isdummyacademicYearvalid : Bool?

    @Published var academicYear : DropDownOption?{
        didSet{
            isacademicYearvalid = academicYear == nil ? false:true
        }
    }
    @Published var isacademicYearvalid : Bool?


    @Published var email = ""{
        didSet{
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            if !email.isEmpty{
                if  emailPredicate.evaluate(with: email){
                    isemailvalid = true
                }else{
                    isemailvalid = false
                    }
                }
            }
    }
    @Published var isemailvalid : Bool?
    
    @Published var SchoolName = ""{
        didSet{
            if SchoolName.count >= 2{
                isSchoolNamevalid = true
            }
        }
    }
    
    @Published var isSchoolNamevalid : Bool?

    @Published var country : DropDownOption?{
        didSet{
            governorte = nil
            iscountryvalid = country == nil ? false:true
        }
    }
    @Published var iscountryvalid : Bool?
    
    @Published var governorte : DropDownOption?{
        didSet{
            city = nil
            isgovernortevalid = governorte == nil ? false:true
        }
    }
    @Published var isgovernortevalid : Bool?
    
    @Published var city : DropDownOption?{
        didSet{
            iscityvalid = city == nil ? false:true
        }
    }
    @Published var iscityvalid : Bool?


//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
//    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")


    @Published var isDataUpdated: Bool = false
    @Published var isFillingData : Bool = true

//    @Published var OtpM: OtpM?
    
//    @Published var isTeacherHasSubjects: Bool = false
//    @Published var isTeacherHasDocuments: Bool = false
    init()  {
//        GetStudentProfile()
    }
}

extension StudentEditProfileVM{
    
    func GetStudentProfile(){
        var parameters:[String:Any] = [:]
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["id"] = Helper.shared.selectedchild?.id
        }
        print(parameters)
        let target = StudentServices.GetStudentProfile(parameters: parameters)
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
                    DispatchQueue.main.async { [self] in
                        self.fillTeacherData(model: model)
                    }
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
        academicYear = dummyAcademicYear
        guard checkValidfields() else {return}
        guard let genderid = selectedGender?.id,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")), let academicYearId = academicYear?.id,let cityid = city?.id else {return}
        var parameters:[String:Any] = ["Name":name,"mobile":phone,"GenderId":genderid,"Birthdate":birthdate, "AcademicYearEducationLevelId":academicYearId,"CityId":cityid,"Email":email,"SchoolName":SchoolName]

        if let image = image {
            parameters["StudentImage"] = image
        }
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["StudentId"] = Helper.shared.selectedchild?.id
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
//                    let student = receivedData.data
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        isDataUpdated = true
                    })
                    isError = true
//                    var student =  Helper.shared.getUser()
//                    student?.academicYearId = receivedData.data?.academicYearEducationLevelID
//                    Helper.shared.saveUser(user: student)
     
                    Helper.shared.selectedchild = ChildrenM.init(id:  receivedData.data?.id ?? 0, code: receivedData.data?.code, image: receivedData.data?.image ?? "", academicYearEducationLevelName: receivedData.data?.academicYearName, academicYearEducationLevelID: receivedData.data?.academicYearEducationLevelID, name: receivedData.data?.name ?? "")
                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: 5, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    private func fillTeacherData(model:StudentProfileM){
        isFillingData = true
        name = model.name ?? ""
        imageStr =  model.image ?? ""
        code = model.code ?? ""
        phone = model.mobile ?? ""
        selectedGender = .init(id:model.genderID,Title:model.genderName )
        if let countryID = model.countryID, let countryName = model.countryName{
            country = .init(id:countryID,Title: countryName)
        }else{
            country = nil
            iscountryvalid = true
        }
        if let governorateID = model.governorateID, let governorateName = model.governorateName{
            governorte = .init(id: governorateID,Title: governorateName)
        }else{
            governorte = nil
            isgovernortevalid = true
        }
        if let cityID = model.cityID, let cityName = model.cityName{
            city = .init(id: cityID,Title: cityName)
        }else{
            city = nil
            iscityvalid = true
        }
        
        educationType = .init(id:model.educationTypeID ,Title:model.educationTypeName)
        educationLevel = .init(id:model.educationLevelID,Title:model.educationLevelName)
        dummyAcademicYear = .init(id:model.academicYearEducationLevelID,Title:model.academicYearName)
        academicYear = .init(id:model.academicYearEducationLevelID,Title:model.academicYearName)
        birthDateStr = model.birthdate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd  MMM  yyyy")
        email =  model.email ?? ""
        SchoolName = model.schoolName ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: { [self] in
            isFillingData = false
            isDataUpdated = false
        })
        
        Helper.shared.selectedchild = ChildrenM.init(id:  model.id , code: model.code, image: model.image ?? "", academicYearEducationLevelName: model.academicYearName, academicYearEducationLevelID: model.academicYearEducationLevelID, name: model.name ?? "")
        
//        if var student = Helper.shared.getUser(),student.academicYearId != model.academicYearEducationLevelID {
//            student.academicYearId = model.academicYearEducationLevelID
//            Helper.shared.saveUser(user: student)
//        }
//        DispatchQueue.main.async{
//            var student =  Helper.shared.getUser()
//            student?.academicYearId = model.academicYearEducationLevelID
//            Helper.shared.saveUser(user: student)
//        }
        
    }
    
    private func checkValidfields()->Bool{
        isnamevalid = !name.isEmpty
        isemailvalid = !email.isEmpty
        iseducationLevelvalid = educationLevel != nil
        isacademicYearvalid = academicYear != nil
        iscountryvalid = country != nil
        isgovernortevalid = governorte != nil
        iscityvalid = city != nil
        isSchoolNamevalid = !SchoolName.isEmpty
        
        return isnamevalid ?? true &&
        isemailvalid ?? true &&
        iseducationLevelvalid ?? true &&
        isacademicYearvalid ?? true &&
        iscountryvalid ?? true &&
        isgovernortevalid ?? true &&
        iscityvalid ?? true &&
        isSchoolNamevalid ?? true

    }
    
}




