//
//  TeacherHomeVM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

import Foundation
import Combine

class TeacherHomeVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var skipCount = 0
 
    
    @Published var filterstartdate : String?
    @Published var filterenddate : String?

    @Published var ShowAddExtraSession = false
//     var selectedGroup : SubjectGroupM?
    var teacherlessonsessionid : Int?
    var teacherLessonSessionSchedualSlotID: Int?
    @Published var extraLesson : DropDownOption?
    @Published var extraDate : String?
    @Published var extraTime : String?

    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var isConfirmError : Bool = false

    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var TeacherScheduals : TeacherHomeM?
    @Published var StudentScheduals : StudentHomeM?

    //    @Published var StudentCalendarScheduals : [StudentEventM]?
    
    init()  {
//        GetScheduals()
    }
}

extension TeacherHomeVM{
    
    func GetScheduals(){
        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
        if let filterstartdate = filterstartdate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["dateFrom"] = filterstartdate
        }
        if let filterenddate = filterenddate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["dateTo"] = filterenddate
        }
        isLoading = true
        if Helper.shared.getSelectedUserType() == .Teacher{
            let target = teacherServices.GetHomeScheduals(parameters: parameters)
            BaseNetwork.CallApi(target, BaseResponse<TeacherHomeM>.self)
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
                        if skipCount == 0{
                            TeacherScheduals = receivedData.data
                        }else{
                            TeacherScheduals?.items?.append(contentsOf: receivedData.data?.items ?? [])
                        }
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
        }else {
            if Helper.shared.getSelectedUserType() == .Parent {
                parameters["StudentId"] = Helper.shared.selectedchild?.id
            }
            let target = StudentServices.GetHomeScheduals(parameters: parameters)

            BaseNetwork.CallApi(target, BaseResponse<StudentHomeM>.self)
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
                        if skipCount == 0{
                            StudentScheduals = receivedData.data
                        }else{
                            StudentScheduals?.items?.append(contentsOf: receivedData.data?.items ?? [])
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
    }
    
    func CancelCalendarCheduals(id:Int){
        var Parameters = ["TeacherLessonSessionSchedualSlotId":id]
        let target = teacherServices.cancelMyCalenderSchedual(parameters: Parameters)
        isLoading = true
        if Helper.shared.getSelectedUserType() == .Teacher {
            BaseNetwork.CallApi(target, BaseResponse<[EventM]>.self)
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
                        GetScheduals()
                        //                        CalendarScheduals = receivedData.data
                        
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
            
        }else {
            if Helper.shared.getSelectedUserType() == .Parent {
                Parameters["StudentId"] = Helper.shared.selectedchild?.id
            }
            BaseNetwork.CallApi(target, BaseResponse<[StudentEventM]>.self)
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
                        GetScheduals()
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
        }
    }
    
    func StudentAttendanceCalendarSchedual(id:Int){
        var parameters:[String:Any] = [:]
        //            if Helper.shared.getSelectedUserType() == .Parent {
        //                parameters["StudentId"] = Helper.shared.selectedchild?.id
        //            }
        print("parameters",parameters)
        
        if Helper.shared.getSelectedUserType() == .Teacher{
            parameters["teacherlessonsessionScheduleSlotId"] = id
        }else {
            parameters["BookteacherlessonsessiondetailId"] = id
        }
        let target = teacherServices.AttendanceStudentCalenderSchedual(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentEventM]>.self)
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
                    //                            CalendarScheduals = receivedData.data?.convertToEvent() ?? []
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func CreateExtraSession(){
        guard let teachersubjectAcademicSemesterYearSlotId = teacherLessonSessionSchedualSlotID,let teacherlessonsessionId = teacherlessonsessionid ,let lessonlessonid = extraLesson?.LessonItem?.id,let duration = extraLesson?.LessonItem?.groupDuration,let extradate = extraDate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")),let extratime = extraTime?.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: .current) else {return}
        let parameters:[String:Any] = [
            "teacherLessonSessionScheduleSlotId": teachersubjectAcademicSemesterYearSlotId,
            "teacherlessonsessionId": teacherlessonsessionId,
            "teacherLessonId": lessonlessonid,
            "duration":duration ,
            "date": extradate,
            "timeFrom":extratime ,
            "isCancel":true
        ]

        print("parameters",parameters)
        let target = teacherServices.CreateExtraSession(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDeleteM>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = .error( message: "\(error.localizedDescription)",buttonTitle:"Done")
                    isError =  true
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true{
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: {[weak self] in
                        guard let self = self else {return}
//                        clearExtraSession()
//                        ShowAddExtraSession = false
                        GetScheduals()
                    })
                    isError =  true

                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearFilter(){
        skipCount = 0
        TeacherScheduals?.items?.removeAll()
        StudentScheduals?.items?.removeAll()

        filterstartdate = nil
        filterenddate = nil
    }
    func clearExtraSession(){
        extraLesson = nil
        extraDate = nil
        extraTime = nil
//        selectedGroup = nil
        teacherlessonsessionid  = nil
        teacherLessonSessionSchedualSlotID = nil
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}

//extension Array where Element == StudentEventM {
//    func convertToEvent() -> [EventM] {
//        return self.map { studentEvent in
//            return EventM(id: studentEvent.id,
//                          groupName: studentEvent.groupName,
//                          date: studentEvent.date,
//                          timeFrom: studentEvent.timeFrom,
//                          timeTo: studentEvent.timeTo,
//                          isCancel: studentEvent.isCancel,
//                          cancelDate: studentEvent.cancelDate,
//                          teamMeetingLink: studentEvent.teamMeetingLink,
//                          bookTeacherlessonsessionDetailId: studentEvent.bookTeacherlessonsessionDetailId)
//        }
//    }
//}
