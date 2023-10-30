//
//  TeacherSubjectsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/10/2023.
//

import Foundation
import Combine

class TeacherSubjectsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
//    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
//    @Published var selecteduser = UserType()
//    @Published var name = ""
//    @Published var phone = ""
//    @Published var Password = ""
//    @Published var selectedGender : DropDownOption?
//    @Published var confirmPassword = ""
//    @Published var acceptTerms = false

    //Student data
//    @Published var birthDate : Date?
//    // next 4  common with teacher subjects
//    @Published var birthDateStr = ""
    
    @Published var educationType : DropDownOption?{
        didSet{
            educationLevel = nil
        }
    }
    @Published var educationLevel : DropDownOption?{
        didSet{
                academicYear = nil
        }
    }
    @Published var academicYear : DropDownOption?{
        didSet{
                subject = nil
        }
    }
    @Published var subject : DropDownOption?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?

    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherSubjects : [TeacherSubjectM]?{
        didSet{
            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
        }
    }

    
    init()  {
        GetTeacherSubjects()
    }
}

extension TeacherSubjectsVM{
    
    func CreateTeacherSubject(){
        guard let subjectAcademicYearId = subject?.id else {return}
        let parameters:[String:Any] = ["subjectAcademicYearId":subjectAcademicYearId]
        
        print("parameters",parameters)
        let target = Authintications.TeacherRegisterSubjects(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
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
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
//                    TeacherSubjects?.append(model)
                    GetTeacherSubjects()
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    

    func GetTeacherSubjects(){
//        guard let educationTypeId = educationType?.id ,let educationLevelId = educationLevel?.id, let academicYearId = academicYear?.id , let subjectId = subject?.id else {return}
//        let parameters:[String:Any] = ["educationTypeId":educationTypeId,"educationLevelId":educationLevelId,"academicYearId":academicYearId,"subjectId":subjectId, "statusId":0]
        
//        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
//        print("parameters",parameters)
        let target = Authintications.TeacherGetSubjects(parameters: [:])
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherSubjectM]>.self)
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
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    TeacherSubjects = model
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

    func DeleteTeacherSubject(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
//        let parameters:[String:Any] = ["Mobile": "00000000001", "PasswordHash": "123456", "TeacherBio": "Bio", "Name": "nnnnnn", "GenderId": 1, "CityId": 1, "IsTeacher": true]
        print("parameters",parameters)
        let target = Authintications.TeacherDeleteSubjects(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
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
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
//                    TeacherSubjects = model
                    TeacherSubjects?.removeAll(where: {$0.id == model.id})
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    
    func clearTeachersSubject(){
        educationType = nil
        educationLevel = nil
        academicYear = nil
        subject = nil
    }


}




