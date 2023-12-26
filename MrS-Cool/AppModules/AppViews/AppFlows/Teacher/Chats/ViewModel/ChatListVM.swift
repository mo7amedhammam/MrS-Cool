//
//  ChatListVM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//

import Foundation
import Combine

class ChatListVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---    
    @Published var selectedChatId : Int?

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
    @Published var ChatsList : [ChatListM]?
    @Published var ChatComments : CompletedLessonDetailsM?

    init(){
    }
}

extension ChatListVM{
    
    func GetChatsList(){
//        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
//            
//        if let filtersubjectid = filtersubject?.id{
//            parameters["teacherSubjectId"] = filtersubjectid
//        }
//         if let filterlessonid = filterlesson?.id{
//            parameters["teacherLessonId"] = filterlessonid
//        }
//        if filtergroupName.count > 0{
//            parameters["groupName"] = filtergroupName
//        }
//        if let filterdate = filterdate{
//            parameters["lessonDate"] = filterdate
//        }
        
//        print("parameters",parameters)
        let target = teacherServices.GetAllComentsList
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[ChatListM]>.self)
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
                        ChatsList = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    func GetChatComments(){
        var parameters:[String:Any] = [:]
        if let subjectid = selectedChatId{
            parameters["bookTeacherLessonSessionDetailId"] = subjectid
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
                    ChatComments = receivedData.data
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




