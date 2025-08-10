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
    @Published var day : DropDownOption?{
        didSet{
            isdayvalid = (day == nil) ? false:true
        }
    }
    @Published var isdayvalid:Bool?
    
    @Published var startDate : String?{
        didSet{
            isstartDatevalid = (startDate == nil) ? false:true
        }
    }
    @Published var isstartDatevalid:Bool?
    
    @Published var endDate : String?{
        didSet{
            isendDatevalid = (endDate == nil) ? false:true
        }
    }
    @Published var isendDatevalid:Bool?
    
    @Published var startTime : String?{
        didSet{
            isstartTimevalid = (startTime == nil) ? false:true
        }
    }
    @Published var isstartTimevalid:Bool?
    
    @Published var endTime : String?{
        didSet{
            isendTimevalid = (endTime == nil) ? false:true
        }
    }
    @Published var isendTimevalid:Bool?
    
    @Published var filterDay : DropDownOption?
    @Published var filterStartDate : String?
    @Published var filterEndDate : String?
    @Published var isFiltering : Bool = false

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
        guard checkValidfields() else {return}
        guard let dayId = day?.id,let startDate = startDate,let endDate = endDate,let startTime = startTime ,let endTime = endTime else {return}
        let parameters:[String:Any] = ["dayId":dayId,
                                       "fromStartDate":startDate.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current),
                                       "toEndDate":endDate.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current),
                                       "fromTime":startTime.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current),
                                       "toTime":endTime.ChangeDateFormat(FormatFrom: "hh:mm aa", FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current)]
        
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
                if receivedData.success == true{
//                    TeacherScheduals?.append(model)
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        clearTeacherSchedual()
                        GetTeacherScheduals()
                        clearFilter()
                    })
                    isError =  true

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
        if let filterDay = filterDay,isFiltering{
            parameters["dayId"] = filterDay.id
        }
        
        if let filterStartDate = filterStartDate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current),isFiltering{
            parameters["fromStartDate"] = filterStartDate
        }
        if let filterEndDate = filterEndDate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: appTimeZone ?? TimeZone.current),isFiltering{
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
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        TeacherScheduals?.removeAll(where: {$0.id == model.id})
                        GetTeacherScheduals()
                        clearFilter()
                    })
                    isError =  true

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
        day = nil
        startDate = nil
        endDate = nil
        startTime = nil
        endTime = nil
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
    
    
    private func checkValidfields()->Bool{
        isdayvalid = day != nil
        isstartDatevalid = startDate != nil
        isendDatevalid = endDate != nil
        isstartTimevalid = startTime != nil
        isendTimevalid = endTime != nil

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
//        isstartDatevalid = ((startDate?.isEmpty) == nil)
//        isendDatevalid = !endDate.isEmpty
//        isgroupCostvalid = !groupCost.isEmpty && Int(groupCost) != 0
//        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
//        isgroupTimevalid = !groupTime.isEmpty && Int(groupTime) != 0
//        isindividualTimevalid = !individualTime.isEmpty && Int(individualTime) != 0

        return isdayvalid ?? true && isstartDatevalid ?? true && isendDatevalid ?? true && isstartTimevalid ?? true && isendTimevalid ?? true
    }
}




