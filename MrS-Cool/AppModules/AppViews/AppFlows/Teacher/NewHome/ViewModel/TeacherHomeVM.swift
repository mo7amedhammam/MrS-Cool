//
//  TeacherHomeVM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

import Foundation
import Combine

@MainActor
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
    @Published var extraLesson : DropDownOption?{
        didSet{
            if extraLesson != nil{
                isextraLessonvalid = true
            }
        }
    }
    @Published var isextraLessonvalid:Bool?

    @Published var extraDate : String?{
        didSet{
            if extraDate != nil {
                isextraDatevalid = true
            }
        }
    }
    @Published var isextraDatevalid:Bool?
    
    @Published var extraTime : String?{
        didSet{
            if extraTime != nil{
                isextraTimevalid = true
            }
        }
    }
    @Published var isextraTimevalid:Bool?
    
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
    
    
//    func GetScheduals(){
//        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
//        if let filterstartdate = filterstartdate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
//            parameters["dateFrom"] = filterstartdate
//        }
//        if let filterenddate = filterenddate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
//            parameters["dateTo"] = filterenddate
//        }
//        isLoading = true
//        if Helper.shared.getSelectedUserType() == .Teacher{
//            let target = teacherServices.GetHomeScheduals(parameters: parameters)
//            BaseNetwork.CallApi(target, BaseResponse<TeacherHomeM>.self)
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: {[weak self] completion in
//                    guard let self = self else{return}
//                    isLoading = false
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        isError =  true
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                    }
//                },receiveValue: {[weak self] receivedData in
//                    guard let self = self else{return}
//                    print("receivedData",receivedData)
//                    if receivedData.success == true {
//                        DispatchQueue.main.async{[weak self] in
//                            guard let self = self else{return}
//                            if skipCount == 0{
//                                TeacherScheduals = receivedData.data
//                            }else{
//                                TeacherScheduals?.items?.append(contentsOf: receivedData.data?.items ?? [])
//                            }
//                        }
//                    }else{
//                        isError =  true
//                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                    }
//                    isLoading = false
//                })
//                .store(in: &cancellables)
//        }else {
//            if Helper.shared.getSelectedUserType() == .Parent {
//                parameters["StudentId"] = Helper.shared.selectedchild?.id
//            }
//            let target = StudentServices.GetHomeScheduals(parameters: parameters)
//
//            BaseNetwork.CallApi(target, BaseResponse<StudentHomeM>.self)
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: {[weak self] completion in
//                    guard let self = self else{return}
//                    isLoading = false
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        isError =  true
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                    }
//                },receiveValue: {[weak self] receivedData in
//                    guard let self = self else{return}
//                    print("receivedData",receivedData)
//                    if receivedData.success == true {
//                        if skipCount == 0{
//                            StudentScheduals = receivedData.data
//                        }else{
//                            StudentScheduals?.items?.append(contentsOf: receivedData.data?.items ?? [])
//                        }
//                        
//                    }else{
//                        isError =  true
//                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                    }
//                    isLoading = false
//                })
//                .store(in: &cancellables)
//        }
//    }
    
    func GetScheduals1() async{
        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
        if let filterstartdate = filterstartdate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["dateFrom"] = filterstartdate
        }
        if let filterenddate = filterenddate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["dateTo"] = filterenddate
        }

//        let target = teacherServices.GetAllComentsList(parameters: parameters)

        if Helper.shared.getSelectedUserType() == .Teacher{
            let target = teacherServices.GetHomeScheduals(parameters: parameters)

//                isLoadingComments = true
                do{
                    let response = try await BaseNetwork.shared.request(target, BaseResponse<TeacherHomeM>.self)
                    print(response)
    
                    if response.success == true {
                        
                        if skipCount == 0{
                            TeacherScheduals = response.data
                        }else{
                            TeacherScheduals?.items?.append(contentsOf: response.data?.items ?? [])
                        }
                        
                    } else {
                        self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                        self.isError = true
                    }
//                        self.isLoadingComments = false

//                    } catch let error as NetworkError {
//                        self.isLoadingComments = false
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        self.isError = true
//        //                print("Network error: \(error.errorDescription)")
                } catch {
//                        self.isLoadingComments = false
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                    self.isError = true
    //                print("Unexpected error: \(error.localizedDescription)")
                }
            
            }else{

                if Helper.shared.getSelectedUserType() == .Parent {
                    parameters["StudentId"] = Helper.shared.selectedchild?.id
                }
                let target = StudentServices.GetHomeScheduals(parameters: parameters)

//                    isLoadingComments = true
                //            error = nil
                do{
                    let response = try await BaseNetwork.shared.request(target, BaseResponse<StudentHomeM>.self)
                    print("response in VM : ",response)
    
                    if response.success == true {
//                        ChatsList = response.data?.convertToChatList()
                        
                        if skipCount == 0{
                            StudentScheduals = response.data
                        }else{
                            StudentScheduals?.items?.append(contentsOf: response.data?.items ?? [])
                        }
                    } else {
                        self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                        self.isError = true
                    }
//                        self.isLoadingComments = false

//                    } catch let error as NetworkError {
//                        self.isLoading = false
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        self.isError = true
//        //                print("Network error: \(error.errorDescription)")
                } catch {
//                        self.isLoadingComments = false
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                    self.isError = true
                }
            }
        }
    
    func CancelCalendarCheduals(id:Int){
        var Parameters = ["TeacherLessonSessionSchedualSlotId":id]
        if Helper.shared.getSelectedUserType() == .Parent {
            Parameters["StudentId"] = Helper.shared.selectedchild?.id
        }
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
//                        skipCount = 0
//                        TeacherScheduals?.items?.removeAll()
//                        GetScheduals()
                        //                        CalendarScheduals = receivedData.data
                        
                        TeacherScheduals?.items = TeacherScheduals?.items?.map { item in
                            var updatedItem = item
                            if item.teacherLessonSessionSchedualSlotID == id {
                                updatedItem.isCancel = true
                            }
                            return updatedItem
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
//                        skipCount = 0
//                        StudentScheduals?.items?.removeAll()
//                        GetScheduals()
                        
                        StudentScheduals?.items = StudentScheduals?.items?.map { item in
                            var updatedItem = item
                            if item.teacherLessonSessionSchedualSlotID == id {
                                updatedItem.isCancel = true
                            }
                            return updatedItem
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
        guard checkValidExtraSessionfields() else {return}

        guard let teachersubjectAcademicSemesterYearSlotId = teacherLessonSessionSchedualSlotID,let teacherlessonsessionId = teacherlessonsessionid ,let lessonlessonid = extraLesson?.LessonItem?.id,let duration = extraLesson?.LessonItem?.groupDuration,let extradate = extraDate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")),let extratime = extraTime?.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: .current) else {return}
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
                    ShowAddExtraSession = false
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: {[weak self] in
                        guard let self = self else {return}
//                        clearExtraSession()
//                        GetScheduals()
                        Task{ [weak self] in
                            guard let self = self else {return}
                            self.TeacherScheduals?.items?.removeAll()
                            self.StudentScheduals?.items?.removeAll()
                            self.skipCount = 0
                            self.isLoading = true
                            await self.GetScheduals1()
                            self.isLoading = false
                        }
//                        TeacherScheduals?.items = TeacherScheduals?.items?.map { item in
//                            var updatedItem = item
//                            if item.teacherLessonSessionSchedualSlotID == teachersubjectAcademicSemesterYearSlotId {
//                                updatedItem.isCancel = true
//                            }
//                            return updatedItem
//                        }
                    })
                    isError =  true

                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    ShowAddExtraSession = false
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    
    @MainActor
    func clearFilter(){
        skipCount = 0
        TeacherScheduals?.items?.removeAll()
        StudentScheduals?.items?.removeAll()

        filterstartdate = nil
        filterenddate = nil
    }
    
    private func checkValidExtraSessionfields()->Bool{
        isextraLessonvalid = extraLesson != nil
        isextraDatevalid = extraDate != nil
        isextraTimevalid = extraTime != nil

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
//        isminGroupvalid = !minGroup.isEmpty && Int(minGroup) != 0
//        ismaxGroupvalid = !maxGroup.isEmpty && Int(maxGroup) != 0
//        isgroupCostvalid = !groupCost.isEmpty && Int(groupCost) != 0
//        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
        
        return isextraLessonvalid ?? true && isextraDatevalid ?? true && isextraTimevalid ?? true
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
