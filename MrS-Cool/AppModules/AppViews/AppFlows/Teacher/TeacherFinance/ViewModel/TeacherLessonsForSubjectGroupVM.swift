//
//  TeacherLessonsForSubjectGroupVM.swift
//  MrS-Cool
//
//  Created by wecancity on 02/01/2025.
//
import Combine
import Foundation

class TeacherLessonsForSubjectGroupVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var Finance : TeacherFinanceM?
    @Published var PurchasedLessons : TeacherFinanceSubjectsAndLessonsM?
    @Published var PurchasedSubjects : TeacherFinanceSubjectsAndLessonsM?
    
    //    @Published var showSubjectLessonsSheet = false
    @Published var TeacherLessonsForSubjectGroup : [TeacherFinanceItem]?
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
    func GetTeacherLessonsForSubjectGroup(TeacherLessonSessionId:Int){
        //        showSubjectLessonsSheet = true
        let parameters:[String:Any] = ["TeacherLessonSessionId":TeacherLessonSessionId]
        
        print("parameters",parameters)
        let target = teacherServices.GetTeacherLessonsForSubjectGroup(parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherFinanceItem]>.self)
        //            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                //                isLoading = false
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
                    TeacherLessonsForSubjectGroup = receivedData.data
                    //                            print("PurchasedSubjects---------\n",PurchasedSubjects)
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                //                isLoading = false
            })
            .store(in: &cancellables)
    }
}
