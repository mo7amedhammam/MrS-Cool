//
//  ManageTeacherSubjectsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//

import Foundation
import Combine

class ManageTeacherSubjectsVM: ObservableObject {
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
    
    @Published var isEditing = false
    @Published var educationType : DropDownOption?{
        didSet{
            if !isEditing{
                educationLevel = nil
            }
        }
    }
    @Published var educationLevel : DropDownOption?{
        didSet{
            if !isEditing{
                academicYear = nil
            }
        }
    }
    @Published var academicYear : DropDownOption?{
        didSet{
            if !isEditing{
                subject = nil
            }
        }
    }
    @Published var subject : DropDownOption?
    
    // for update subject
    @Published var editId : Int = 0
    @Published var groupCost : String = ""
    @Published var individualCost : String = ""
    @Published var minGroup : String = ""
    @Published var maxGroup : String = ""
    @Published var subjectBrief : String = ""
    
    @Published var filterEducationType : DropDownOption?{
        didSet{
            filterEducationLevel = nil
        }
    }
    @Published var filterEducationLevel : DropDownOption?{
        didSet{
            filterAcademicYear = nil
        }
    }
    @Published var filterAcademicYear : DropDownOption?{
        didSet{
            filterSubject = nil
            filterSubjectStatus = nil
        }
    }
    @Published var filterSubject : DropDownOption?
    @Published var filterSubjectStatus : DropDownOption?
    
    //    @Published var editableTeacherSubject : TeacherSubjectM?{
    //        didSet{
    //            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
    //        }
    //    }
    
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherSubjects : [TeacherSubjectM]?{
        didSet{
            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
        }
    }
    
    
    init()  {
        //        GetTeacherSubjects()
    }
}

extension ManageTeacherSubjectsVM{
    
    func CreateTeacherSubject(){
        guard let subjectAcademicYearId = subject?.id else {return}
        let parameters:[String:Any] = ["subjectSemesterYearId":subjectAcademicYearId]
        
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
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true {
                    //                    TeacherSubjects?.append(model)
                    GetTeacherSubjects()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func UpdateTeacherSubject(){
        guard let subjectAcademicYearId = subject?.id, let groupCost = Int(groupCost), let individualCost = Int(individualCost),let minGroup = Int(minGroup),let maxGroup = Int(maxGroup)  else {return}
        let parameters:[String:Any] = ["id":editId,"subjectSemesterYearId":subjectAcademicYearId,"groupCost":groupCost,"individualCost":individualCost,"minGroup":minGroup,"maxGroup":maxGroup,"teacherBrief":subjectBrief ]
        
        print("parameters",parameters)
        let target = teacherServices.UpdateTeacherSubject(parameters: parameters)
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
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true {
                    //                    TeacherSubjects?.append(model)
                    GetTeacherSubjects()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetTeacherSubjects(){
        var parameters : [String:Any] = [:]
        if let educationTypeId = filterEducationType?.id{
            parameters["educationTypeId"] = educationTypeId
        }
        if let educationLevelId = filterEducationLevel?.id{
            parameters["educationLevelId"] = educationLevelId
        }
        if let academicYearId = filterAcademicYear?.id{
            parameters["academicYearId"] = academicYearId
        }
        if let subjectId = filterSubject?.id{
            parameters["subjectId"] = subjectId
        }
        if let statusId = filterSubjectStatus?.id{
            parameters["statusId"] = statusId
        }
        let target = Authintications.TeacherGetSubjects(parameters: parameters)
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
                    self.error = .error( image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    TeacherSubjects = model
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteTeacherSubject(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
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
                    self.error = .error( message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    //                    TeacherSubjects = model
                    TeacherSubjects?.removeAll(where: {$0.id == model.id})
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    
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
        
        minGroup = ""
        maxGroup = ""
        groupCost = ""
        individualCost = ""
        subjectBrief =  ""
    }
    func clearFilter(){
        filterEducationType = nil
        filterEducationLevel = nil
        filterAcademicYear = nil
        filterSubject = nil
        filterSubjectStatus = nil
    }
    func selectSubjectForEdit(item:TeacherSubjectM){
        isEditing = false
        editId = item.id ?? 0
        educationType = .init(id: item.educationTypeID,Title: item.educationTypeName)
        educationLevel = .init(id: item.educationLevelID,Title: item.educationLevelName)
        academicYear = .init(id: item.subjectSemesterYearId,Title: item.academicYearName)
        subject = .init(id: item.subjectSemesterYearId,Title: item.subjectDisplayName)
        if let min = item.minGroup{
            minGroup = String(min)
        }
        if let max = item.maxGroup{
            maxGroup = String(max)
        }
        if let gcost = item.groupCost{
            groupCost = String(gcost)
        }
        if let indcost = item.individualCost{
            individualCost = String(indcost)
        }
        subjectBrief = item.teacherBrief ?? ""
        isEditing = true
    }
    
    func cleanup() {
         // Cancel any ongoing Combine subscriptions
         cancellables.forEach { cancellable in
             cancellable.cancel()
         }
         cancellables.removeAll()
     }
}




