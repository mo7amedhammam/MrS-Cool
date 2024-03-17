//
//  ListChildrenVM.swift
//  MrS-Cool
//
//  Created by wecancity on 17/03/2024.
//

import Foundation
import Combine

class ListChildrenVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
//    @Published var maxResultCount = 10
//    @Published var skipCount = 0
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var Children : [ChildrenM]? = [ChildrenM.init(id: 1, code: "dddddd", image: "", academicYearEducationLevelName: "egyption education", academicYearEducationLevelID: 2, name: "name"),ChildrenM.init(id: 2, code: "ssss", image: "", academicYearEducationLevelName: "egyption education", academicYearEducationLevelID: 3, name: "name 2")]
    init()  {
    }
}

extension ListChildrenVM{
    
    func GetMyChildren(){
        //        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
        //        print("parameters",parameters)
        
        let target = ParentServices.GetMyChildern
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[ChildrenM]>.self)
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
                    Children = receivedData.data

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
