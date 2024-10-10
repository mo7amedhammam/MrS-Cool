//
//  TeacherCalendarSvhedualsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 19/12/2023.
//

import Foundation

import Combine

class TeacherCalendarSvhedualsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---

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
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var CalendarScheduals : [EventM]?
    //    @Published var StudentCalendarScheduals : [StudentEventM]?
    
    init()  {
        GetCalendarCheduals()
    }
}

extension TeacherCalendarSvhedualsVM{
    
    func GetCalendarCheduals(){
        var parameters:[String:Any] = [:]
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["StudentId"] = Helper.shared.selectedchild?.id
        }
        print("parameters",parameters)
        let target = teacherServices.GetMyCalenderSchedual(parameters: parameters)
        isLoading = true
        if Helper.shared.getSelectedUserType() == .Teacher{
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
                        //                    TeacherSubjects?.append(model)
                        CalendarScheduals = receivedData.data ?? []
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
                    if receivedData.success == true,let model = receivedData.data {
                        //                    TeacherSubjects?.append(model)
                        CalendarScheduals = model.convertToEvent()
                        //                        DispatchQueue.main.async(execute: {
                        //                        StudentCalendarScheduals = model
                        //                        })
                        
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
        if Helper.shared.getSelectedUserType() == .Parent {
            Parameters["StudentId"] = Helper.shared.selectedchild?.id
        }
        print(Parameters)
        
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
                        //                        GetCalendarCheduals()
                        CalendarScheduals = receivedData.data
                        
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
                        GetCalendarCheduals()
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
        ShowAddExtraSession = false
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
//                    ShowAddExtraSession = false
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: {[weak self] in
                        guard let self = self else {return}
//                        clearExtraSession()
                        if let index = CalendarScheduals?.firstIndex(where: { $0.id == self.teacherLessonSessionSchedualSlotID}) {
                            CalendarScheduals?[index].isCancel = true
                        }
//                        DispatchQueue.main.async(execute: { [weak self] in
                            self.GetCalendarCheduals()
//                        })
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
    
    func clearExtraSession(){
        extraLesson = nil
        extraDate = nil
        extraTime = nil
//        selectedGroup = nil
        teacherlessonsessionid  = nil
        teacherLessonSessionSchedualSlotID = nil
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
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}

extension Array where Element == StudentEventM {
    func convertToEvent() -> [EventM] {
        return self.map { studentEvent in
            return EventM(id: studentEvent.id,
                          groupName: studentEvent.groupName,
                          date: studentEvent.date,
                          timeFrom: studentEvent.timeFrom,
                          timeTo: studentEvent.timeTo,
                          isCancel: studentEvent.isCancel,
                          cancelDate: studentEvent.cancelDate,
                          teamMeetingLink: studentEvent.teamMeetingLink,
                          bookTeacherlessonsessionDetailId: studentEvent.bookTeacherlessonsessionDetailId)
        }
    }
}
