//
//  ManageTeacherSchedualsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 28/11/2023.
//

import Foundation
import Combine

class ManageTeacherSchedualsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var day : DropDownOption?
    @Published var startDate : String? 
    @Published var endDate : String?
    @Published var startTime : String?
    @Published var endTime : String?
    
    @Published var filterDay : DropDownOption?
    @Published var filterStartDate : String?
    @Published var filterEndDate : String?

    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherScheduals : [TeacherSchedualM]?
//    {
//        didSet{
//            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
//        }
//    }
    
    
    init()  {
        //        GetTeacherSubjects()
    }
}

extension ManageTeacherSchedualsVM{
    
    func CreateTeacherSchedual(){
        guard let dayId = day?.id,let startDate = startDate,let endDate = endDate,let startTime = startTime ,let endTime = endTime else {return}
        let parameters:[String:Any] = ["dayId":dayId,
                                       "fromStartDate":startDate.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss"),
                                       "toEndDate":endDate.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss"),
                                       "fromTime":startTime.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm"),
                                       "toTime":endTime.ChangeDateFormat(FormatFrom: "hh:mm aa", FormatTo:"HH:mm")]
        
        print("parameters",parameters)
        let target = teacherServices.CreateMyNewSchedual(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherSchedualM>.self)
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
//                    TeacherScheduals?.append(model)
                    GetTeacherScheduals()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetTeacherScheduals(){
//        guard let dayId = day?.id,let startDate = startDate,let endDate = endDate else {return}
        var parameters:[String:Any] = [:]
        if let filterDay = filterDay{
            parameters["dayId"] = filterDay.id
        }
        if let filterStartDate = filterStartDate{
            parameters["fromStartDate"] = filterStartDate
        }
        if let filterEndDate = filterEndDate{
            parameters["toEndDate"] = filterEndDate
        }
        print("parameters",parameters)
        let target = teacherServices.GetMyScheduals(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherSchedualM]>.self)
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
                    TeacherScheduals = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteTeacherSchedual(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.DeleteMySchedual(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherSchedualM>.self)
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
                    TeacherScheduals?.removeAll(where: {$0.id == model.id})
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearTeacherSchedual(){
//        educationType = nil
//        educationLevel = nil
//        academicYear = nil
//        subject = nil
//        
//        minGroup = ""
//        maxGroup = ""
//        groupCost = ""
//        individualCost = ""
//        subjectBrief =  ""
    }
    func clearFilter(){
        filterDay = nil
        filterStartDate = nil
        filterEndDate = nil
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




