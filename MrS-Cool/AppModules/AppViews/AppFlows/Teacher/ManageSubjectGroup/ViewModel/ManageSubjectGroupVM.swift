//
//  ManageSubjectGroupVM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/12/2023.
//

import Foundation
import Combine

class ManageSubjectGroupVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var subject : DropDownOption?
    @Published var groupName : String = ""
    @Published var startDate : String?
    //    @Published var endDate : String?
    
    @Published var filtersubject : DropDownOption?
    @Published var filtergroupName : String = ""
    @Published var filterstartdate : String?
    @Published var filterenddate : String?
    
    @Published var day : DropDownOption?
    @Published var startTime : String?
    //    @Published var endTime : String?
    
    @Published var DisplaySchedualSlotsArr:[NewScheduleSlotsM] = []
    
    @Published var CreateSchedualSlotsArr:[CreateScheduleSlotsM] = []
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    
    @Published var TeacherSubjectGroups : [SubjectGroupM]?
    @Published var TeacherSubjectGroupsDetails : SubjectGroupDetailsM?
    
    init()  {
    }
}

extension ManageSubjectGroupVM{
    func GetTeacherSubjectGroups(){
        var parameters:[String:Any] = [:]
        if let filtersubjectid = filtersubject?.id{
            parameters["teacherSubjectAcademicSemesterYearId"] = filtersubjectid
        }
        if filtergroupName.count > 0{
            parameters["groupName"] = filtergroupName
        }
        
        if let filterstartdate = filterstartdate{
            parameters["startDate"] = filterstartdate
        }
        if let filterenddate = filterenddate{
            parameters["endDate"] = filterenddate
        }
        
        print("parameters",parameters)
        let target = teacherServices.GetMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[SubjectGroupM]>.self)
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
                    TeacherSubjectGroups = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func ReviewTeacherGroup(){
        guard let subjectid = subject?.id ,let subjectname = subject?.Title ,let startdate = startDate else {return}
        
        let parameters:[String:Any] = [ "teacherSubjectAcademicSemesterYearId":subjectid,
                                        "teacherSubjectAcademicSemesterYearName":subjectname,
                                        "groupName":groupName,
                                        "startDate":startdate.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm"),
                                        "scheduleSlots":[CreateSchedualSlotsArr]]
        print("parameters",parameters)
        let target = teacherServices.ReviewMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDetailsM>.self)
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
                    TeacherSubjectGroupsDetails = receivedData.data
                    //                    clearTeacherGroup()
                    //                    clearFilter()
                    //                    GetTeacherSubjectGroups()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func CreateTeacherGroup(){
        guard let TeacherSubjectGroupsDetailsParameters = TeacherSubjectGroupsDetails?.toDictionary() else {return}
        let parameters:[String:Any] = TeacherSubjectGroupsDetailsParameters
        print("parameters",parameters)
        let target = teacherServices.ReviewMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDetailsM>.self)
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
                    TeacherSubjectGroupsDetails = receivedData.data
                    //                    clearTeacherGroup()
                    //                    clearFilter()
                    //                    GetTeacherSubjectGroups()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetTeacherGroupDetails(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.GetMySubjectGroupDetails(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDetailsM>.self)
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
                if receivedData.success == true{
                    TeacherSubjectGroupsDetails = receivedData.data
                    
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteTeacherGroup(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.DeleteMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDeleteM>.self)
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
                if receivedData.success == true{
                    TeacherSubjectGroups?.removeAll(where: {$0.id == id})
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    // Map DisplaySchedualSlotsArr to CreateSchedualSlotsArr
    func prepareSlotsArrays() {
        CreateSchedualSlotsArr = DisplaySchedualSlotsArr.map { newSlot in
            return CreateScheduleSlotsM(dayId: newSlot.day?.id, fromTime: newSlot.fromTime)
        }
    }
    
    func clearCurrentSlot(){
        day = nil
        startTime = nil
        //        endTime = nil
    }
    func deleteFromDisplaySchedualSlot(at index: Int) {
           guard index >= 0 && index < DisplaySchedualSlotsArr.count else {
               // Handle invalid index
               return
           }
           DisplaySchedualSlotsArr.remove(at: index)
       }
    
    func clearTeacherGroup(){
        subject = nil
        groupName = ""
        startDate = nil
        CreateSchedualSlotsArr.removeAll()
    }
    func clearFilter(){
        filtersubject = nil
        filtergroupName = ""
        filterstartdate = nil
        filterenddate = nil
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}




