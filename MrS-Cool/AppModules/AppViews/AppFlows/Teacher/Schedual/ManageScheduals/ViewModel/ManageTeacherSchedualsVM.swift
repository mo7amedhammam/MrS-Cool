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
    @Published var TeacherSubjects : [TeacherSubjectM]?{
        didSet{
            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
        }
    }
    
    
    init()  {
        //        GetTeacherSubjects()
    }
}

extension ManageTeacherSchedualsVM{
    
    func CreateTeacherSchedual(){
//        guard let subjectAcademicYearId = subject?.id else {return}
//        let parameters:[String:Any] = ["subjectAcademicYearId":subjectAcademicYearId]
//        
//        print("parameters",parameters)
//        let target = Authintications.TeacherRegisterSubjects(parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
//                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if receivedData.success == true {
//                    //                    TeacherSubjects?.append(model)
//                    GetTeacherSubjects()
//                }else{
//                    isError =  true
//                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
    }
    
    func GetTeacherScheduals(){
        var parameters : [String:Any] = [:]
        if let day = filterDay?.id{
            parameters["educationTypeId"] = day
        }
        if let startDate = filterStartDate{
            parameters["educationLevelId"] = startDate
        }
        if let endDate = filterEndDate{
            parameters["academicYearId"] = endDate
        }
//        let target = Authintications.TeacherGetSubjects(parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<[TeacherSubjectM]>.self)
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
//                    self.error = .error( image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if let model = receivedData.data{
//                    TeacherSubjects = model
//                }else{
//                    isError =  true
//                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                    
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
    }
    
    func DeleteTeacherSubject(id:Int?){
//        guard let id = id else {return}
//        let parameters:[String:Any] = ["id":id]
//        
//        print("parameters",parameters)
//        let target = Authintications.TeacherDeleteSubjects(parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
//                    self.error = .error( message: "\(error.localizedDescription)",buttonTitle:"Done")
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if let model = receivedData.data{
//                    //                    TeacherSubjects = model
//                    TeacherSubjects?.removeAll(where: {$0.id == model.id})
//                }else{
//                    isError =  true
//                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                    
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
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




