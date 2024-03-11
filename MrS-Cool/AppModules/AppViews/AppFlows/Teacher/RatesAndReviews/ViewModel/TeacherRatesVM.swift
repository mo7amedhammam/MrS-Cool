//
//  TeacherRatesVM.swift
//  MrS-Cool
//
//  Created by wecancity on 09/03/2024.
//

import Foundation
import Combine

class TeacherRatesVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var skipCount = 0
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var Rates : TeacherRateM? = TeacherRateM.init(items: [RateItem.init(teacherRate: 3.5, teacherLessonName: "The best LMS Design", teacherLessonRate: 4, teacherLessonComment: "This course is a very applicable. Professor Ng explains precisely each algorithm and even tries to give an intuition for mathematical and statistic concepts behind each algorithm. Thank you very much.", creationDate: "2024-03-11T10:53:14.468Z")],totalCount: 35)
    
    init()  {
    }
}

extension TeacherRatesVM{
    
    func GetRates(){
        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
        
        print("parameters",parameters)
        let target = teacherServices.GetTeacherRates(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherRateM>.self)
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
                    if skipCount == 0{
                        Rates = receivedData.data
                    }else{
                        Rates?.items?.append(contentsOf: receivedData.data?.items ?? [])
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
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}
