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
    @Published var name = ""{
        didSet{
            if name.count >= 2{
                isnamevalid = true
            }
        }
    }
    @Published var isnamevalid : Bool? = true

//    @Published var code = ""

    @Published var phone = ""{
        didSet{
            if phone.count == 11{
                isphonevalid = true
            }
        }
    }
    @Published var isphonevalid : Bool? = true

    @Published var selectedGender : DropDownOption?{
        didSet{
            isselectedGendervalid = selectedGender == nil ? false:true
        }
    }
    @Published var isselectedGendervalid : Bool?

    //Student data
//    @Published var birthDate : Date?
    // next 4  common with teacher subjects
    @Published var birthDateStr : String?{
        didSet{
            isbirthDateStrvalid = birthDateStr == nil ? false:true
        }
    }
    @Published var isbirthDateStrvalid : Bool?
    
    @Published var educationType : DropDownOption?{
        didSet{
                educationLevel = nil
                iseducationTypevalid = educationType == nil ? false:true
        }
    }
    @Published var iseducationTypevalid:Bool?
    @Published var educationLevel : DropDownOption?{
        didSet{
                academicYear = nil
                iseducationLevelvalid = educationLevel == nil ? false:true
        }
    }
    @Published var iseducationLevelvalid:Bool?
    
    @Published var academicYear : DropDownOption?{
        didSet{
                isacademicYearvalid = academicYear == nil ? false:true
        }
    }
    @Published var isacademicYearvalid:Bool?
    
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

    @Published var SchoolName = ""
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
    
    @Published var Password = ""{
        didSet{
            if Password.count >= 6{
                isPasswordvalid = true
            }
        }
    }
  
    @Published var isPasswordvalid : Bool? = true
    @Published var confirmPassword = ""{
        didSet{
            if !confirmPassword.isEmpty{
                if confirmPassword == Password {
                    isconfirmPasswordvalid = true
                }else{
                    isconfirmPasswordvalid = false
                }
            }
        }
    }
    @Published var isconfirmPasswordvalid : Bool? = true

    @Published var isFormValid : Bool = false


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
    
    func AddNewStudent(){
        guard checkValidfields() else {return}
        guard let genderid = selectedGender?.id,let birthdate = birthDateStr?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")), let academicYearId = academicYear?.id,let cityid = city?.id else {return}
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


extension AddNewStudentVM{
        
    private func checkValidfields()->Bool{
        isnamevalid = name.count > 0
        isphonevalid = phone.count == 11
        isemailvalid = email.count > 0
        isbirthDateStrvalid = birthDateStr != nil
        iseducationTypevalid = educationType != nil
        iseducationLevelvalid = educationLevel != nil
        isacademicYearvalid = academicYear != nil
        iscountryvalid = country != nil
        isgovernortevalid = governorte != nil
        iscityvalid = city != nil
        isselectedGendervalid = selectedGender != nil
        isSchoolNamevalid = SchoolName.count > 0
        isPasswordvalid = Password.count >= 6
        isconfirmPasswordvalid = confirmPassword.count > 0 && Password == confirmPassword

        return isnamevalid ?? true &&
        isphonevalid ?? true &&
        isemailvalid ?? true &&
        isbirthDateStrvalid ?? true &&
        iseducationTypevalid ?? true &&
        iseducationLevelvalid ?? true &&
        isacademicYearvalid ?? true &&
        iscountryvalid ?? true &&
        isgovernortevalid ?? true &&
        iscityvalid ?? true &&
        isselectedGendervalid ?? true &&
        isSchoolNamevalid ?? true &&
        isPasswordvalid ?? true &&
        isconfirmPasswordvalid ?? true
    }
        
}

