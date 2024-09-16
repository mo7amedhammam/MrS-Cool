//
//  TeacherFinanceVM.swift
//  MrS-Cool
//
//  Created by wecancity on 12/09/2024.
//

import Combine
import Foundation

class TeacherFinanceVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var subjectsSkipCount = 0
    @Published var lessonsSkipCount = 0

//    @Published var selectedLessonid : Int?

//    @Published var filtersubject : DropDownOption?
//    @Published var filterlesson : DropDownOption?
//    @Published var filtergroupName : String = ""
//    @Published var filterdate : String?
//    @Published var isFiltering : Bool = false
    
    @Published var filtersubjectsdatefrom : String?
    @Published var filtersubjectsdateto : String?

    @Published var filterlessonsdatefrom : String?
    @Published var filterlessonsdateto : String?

    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var Finance : TeacherFinanceM?
    @Published var PurchasedLessons : TeacherFinanceSubjectsAndLessonsM?
    @Published var PurchasedSubjects : TeacherFinanceSubjectsAndLessonsM?

    init()  {
//        GetFinance()
//        GetPurchasedSubjects()
//        GetPurchasedLessons()
    }
    func cleanup(){
        cancellables.forEach{ cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}

extension TeacherFinanceVM{
    
    func GetFinance(){
//        var parameters:[String:Any] = [:]
//        
//        print("parameters",parameters)
        let target = teacherServices.GetTeacherFinance
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherFinanceM>.self)
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
                    Finance = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetPurchasedFor(financese:StudentFinanceCases){
        var parameters:[String:Any] = ["maxResultCount":maxResultCount]
//        if Helper.shared.getSelectedUserType() == .Parent {
//            parameters["studentId"] = Helper.shared.selectedchild?.id
//        }
        switch financese {
        case .Subjects:
            parameters["skipCount"] = subjectsSkipCount
            if let filtersubjectdatefrom = filtersubjectsdatefrom?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
                parameters["dateFrom"] = filtersubjectdatefrom
            }
            if let filtersubjectsdateto = filtersubjectsdateto?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
                parameters["dateTo"] = filtersubjectsdateto
            }
            
        case .Lessons:
            parameters["skipCount"] = lessonsSkipCount
            if let filterlessonstdatefrom = filterlessonsdatefrom?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
                parameters["dateFrom"] = filterlessonstdatefrom
            }
            if let filterlessonstdateto = filterlessonsdateto?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
                parameters["dateTo"] = filterlessonstdateto
            }
        }
        
        print("parameters",parameters)
        let target = teacherServices.GetTeacherFinanceSubjects(FinanceFor: financese, parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherFinanceSubjectsAndLessonsM>.self)
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
                    switch financese {
                    case .Subjects:
                        if subjectsSkipCount == 0{
                            PurchasedSubjects = receivedData.data
//                            print("PurchasedSubjects---------\n",PurchasedSubjects)
                        }else{
                            PurchasedSubjects?.items?.append(contentsOf: receivedData.data?.items ?? [])
                        }
                    case .Lessons:
                        if lessonsSkipCount == 0{
                            PurchasedLessons = receivedData.data
//                            print("PurchasedLessons---------\n",PurchasedLessons)
                        }else{
                            PurchasedLessons?.items?.append(contentsOf: receivedData.data?.items ?? [])
                        }
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




