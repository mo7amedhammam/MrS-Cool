//
//  GroupForLessonVM.swift
//  MrS-Cool
//
//  Created by wecancity on 02/12/2023.
//

import Foundation
import Combine

class GroupForLessonVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var subject : DropDownOption?
    @Published var lesson : DropDownOption?
    @Published var groupName : String = ""
    @Published var date : String?
    @Published var time : String?
    
    @Published var filtersubject : DropDownOption?
    @Published var filterlesson : DropDownOption?
    @Published var filtergroupName : String = ""
    @Published var filterdate : String?
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherGroups : [GroupForLessonM]?
    
    init()  {
    }
}

extension GroupForLessonVM{
    func CreateTeacherGroup(){
        guard let lessonid = lesson?.id,let date = date,let time = time else {return}
        
        let Dto:[String:Any] = ["date":date.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss"),
                                "timeFrom":time.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm"),
                                "timeTo":time.toDate(withFormat: "hh:mm aa")?.adding(minutes: lesson?.subTitle ?? 0).formatDate(format: "HH:mm") ?? ""]
        let parameters:[String:Any] = [ "groupName":groupName,
                                        "teacherLessonId":lessonid,
                                        "teacherLessonSessionScheduleSlotsDto":[Dto]]
        print("parameters",parameters)
        let target = teacherServices.CreateMyLessonScheduleGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<GroupForLessonM>.self)
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
                    clearTeacherGroup()
                    clearFilter()
                    GetTeacherGroups()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetTeacherGroups(){
        var parameters:[String:Any] = [:]
        if let subjectid = subject?.id{
            parameters["teacherSubjectAcademicSemesterYearId"] = subjectid
        }else if let filtersubjectid = filtersubject?.id{
            parameters["teacherSubjectAcademicSemesterYearId"] = filtersubjectid
        }
        if let lessonid = lesson?.id{
            parameters["teacherLessonId"] = lessonid
            
        } else if let filterlessonid = filterlesson?.id{
            parameters["teacherLessonId"] = filterlessonid
        }
        if groupName.count > 0{
            parameters["groupName"] = groupName
        }else if filtergroupName.count > 0{
            parameters["groupName"] = filtergroupName
        }
        
        if let date = date{
            parameters["startDate"] = date
        }else if let filterdate = filterdate{
            parameters["startDate"] = filterdate
        }
        if let time = time{
            parameters["toEndDate"] = time
        }
        
        print("parameters",parameters)
        let target = teacherServices.GetMyLessonSchedualGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[GroupForLessonM]>.self)
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
                    TeacherGroups = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteTeacherGroup(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.DeleteMyLessonScheduleGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<GroupForLessonM>.self)
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
                    TeacherGroups?.removeAll(where: {$0.id == id})
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearTeacherGroup(){
        subject = nil
        lesson = nil
        date = nil
        time = nil
        groupName = ""
    }
    func clearFilter(){
        filtersubject = nil
        filterlesson = nil
        filterdate = nil
        filtergroupName = ""
    }
    //    func selectSubjectForEdit(item:TeacherSubjectM){
    //        isEditing = false
    //        editId = item.id ?? 0
    //        educationType = .init(id: item.educationTypeID,Title: item.educationTypeName)
    //        educationLevel = .init(id: item.educationLevelID,Title: item.educationLevelName)
    //        academicYear = .init(id: item.subjectAcademicYearID,Title: item.academicYearName)
    //        subject = .init(id: item.subjectAcademicYearID,Title: item.subjectDisplayName)
    //        if let min = item.minGroup{
    //            minGroup = String(min)
    //        }
    //        if let max = item.maxGroup{
    //            maxGroup = String(max)
    //        }
    //        if let gcost = item.groupCost{
    //            groupCost = String(gcost)
    //        }
    //        if let indcost = item.individualCost{
    //            individualCost = String(indcost)
    //        }
    //        subjectBrief = item.teacherBrief ?? ""
    //        isEditing = true
    //    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}




