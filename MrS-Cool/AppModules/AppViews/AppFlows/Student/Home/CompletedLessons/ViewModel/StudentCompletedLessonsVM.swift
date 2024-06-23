//
//  StudentCompletedLessonsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 20/02/2024.
//

import Foundation
import Combine

class StudentCompletedLessonsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var skipCount = 0
    
//    @Published var selectedLessonid : Int?

    @Published var filtersubject : DropDownOption?
    @Published var filterlesson : DropDownOption?
    @Published var filtergroupName : String = ""
    @Published var filterdate : String?
    @Published var isFiltering : Bool = false
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    @Published var completedLessonsList : StudentCompletedLessonM?
    @Published var completedLessonDetails : StudentCompletedLessonDetailsM?

    init()  {
    }
}

extension StudentCompletedLessonsVM{
    
    func GetCompletedLessons(){
        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
            
        if let filtersubjectid = filtersubject?.id, isFiltering{
            parameters["subjectId"] = filtersubjectid
        }
        if let filterlessonid = filterlesson?.id, isFiltering{
           parameters["lessonId"] = filterlessonid
        }
        if filtergroupName.count > 0, isFiltering{
            parameters["groupName"] = filtergroupName
        }
        if let filterdate = filterdate?.ChangeDateFormat(FormatFrom: "dd  MMM  yyyy", FormatTo: "yyyy-MM-dd'T'HH:mm:ss.SSS"), isFiltering{
            parameters["lessonDate"] = filterdate
        }
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["studentId"] = Helper.shared.selectedchild?.id
        }
        
        print("parameters",parameters)
        let target = StudentServices.GetStudentCompletedLessons(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<StudentCompletedLessonM>.self)
//            .receive(on: DispatchQueue.main)
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
                    isFiltering = false

                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetCompletedLessonDetails(teacherlessonid:Int){
        let parameters:[String:Any] = ["teacherlessonid":teacherlessonid]
        print("parameters",parameters)
        let target = StudentServices.GetStudentCompletedLessonDetails(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<StudentCompletedLessonDetailsM>.self)
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
    
//    func cleanup() {
//        // Cancel any ongoing Combine subscriptions
//        cancellables.forEach { cancellable in
//            cancellable.cancel()
//        }
//        cancellables.removeAll()
//    }
}




