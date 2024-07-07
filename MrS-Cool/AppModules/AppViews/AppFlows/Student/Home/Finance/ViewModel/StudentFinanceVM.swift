//
//  StudentFinanceVM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/07/2024.
//

import Combine

class StudentFinanceVM: ObservableObject {
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
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    @Published var Finance : FinanceM?
    @Published var PurchasedLessons : FinanceSubjectsAndLessonsM?
    @Published var PurchasedSubjects : FinanceSubjectsAndLessonsM?

    init()  {
    }
}

extension StudentFinanceVM{
    
    func GetFinance(){
        var parameters:[String:Any] = [:]

        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["studentId"] = Helper.shared.selectedchild?.id
        }
        
        print("parameters",parameters)
        let target = StudentServices.GetStudentFinance(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<FinanceM>.self)
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
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["studentId"] = Helper.shared.selectedchild?.id
        }
        switch financese {
        case .Subjects:
            parameters["skipCount"] = subjectsSkipCount
        case .Lessons:
            parameters["skipCount"] = lessonsSkipCount
        }
        
        print("parameters",parameters)
        let target = StudentServices.GetStudentFinanceSubjects(FinanceFor: financese, parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<FinanceSubjectsAndLessonsM>.self)
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
                        }else{
                            PurchasedSubjects?.items?.append(contentsOf: receivedData.data?.items ?? [])
                        }
                    case .Lessons:
                        if lessonsSkipCount == 0{
                            PurchasedLessons = receivedData.data
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




