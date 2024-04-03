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
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var CalendarScheduals : [EventM] = []

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
                    if receivedData.success == true {
                        //                    TeacherSubjects?.append(model)
                        CalendarScheduals = receivedData.data?.convertToEvent() ?? []
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
                        GetCalendarCheduals()
                        //                    CalendarScheduals = receivedData.data ?? []
                        
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
                          cancelDate: studentEvent.cancelDate)
        }
    }
}
