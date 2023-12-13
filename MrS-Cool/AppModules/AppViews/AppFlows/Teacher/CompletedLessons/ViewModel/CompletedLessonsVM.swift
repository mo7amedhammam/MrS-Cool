//
//  CompletedLessonsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 13/12/2023.
//

import Foundation
import Combine

class CompletedLessonsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var skipCount = 0
    
    @Published var selectedLessonid : Int?

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
    @Published var completedLessonsList : CompletedLessonsM?
    @Published var completedLessonDetails : CompletedLessonDetailsM?

    init()  {
    }
}

extension CompletedLessonsVM{
    
    func GetCompletedLessons(){
        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
            
        if let filtersubjectid = filtersubject?.id{
            parameters["teacherSubjectId"] = filtersubjectid
        }
         if let filterlessonid = filterlesson?.id{
            parameters["teacherLessonId"] = filterlessonid
        }
        if filtergroupName.count > 0{
            parameters["groupName"] = filtergroupName
        }
        if let filterdate = filterdate{
            parameters["lessonDate"] = filterdate
        }
        
        print("parameters",parameters)
        let target = teacherServices.GetMyCompletedLessons(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CompletedLessonsM>.self)
            .receive(on: DispatchQueue.main)
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
                    if skipCount == 0{
                        completedLessonsList = receivedData.data
                    }else{
                        completedLessonsList?.items?.append(contentsOf: receivedData.data?.items ?? [])
                    }
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    func GetCompletedLessonDetails(){
        var parameters:[String:Any] = [:]
        if let subjectid = selectedLessonid{
            parameters["teacherLessonSessionSchedualSlotId"] = subjectid
        }
        print("parameters",parameters)
        let target = teacherServices.GetMyCompletedLessonDetails(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CompletedLessonDetailsM>.self)
            .receive(on: DispatchQueue.main)
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
                    completedLessonDetails = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

    
//    func clearTeacherGroup(){
//        subject = nil
//        lesson = nil
//        date = nil
//        groupName = ""
//    }
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




