//
//  StudentTabBarVM.swift
//  MrS-Cool
//
//  Created by wecancity on 14/01/2024.
//

import Combine
import SwiftUI

class StudentTabBarVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published  var selectedIndex = Helper.shared.selectedchild == nil ? 2:0
    @Published var ispush : Bool = false
    @Published var destination = AnyView(EmptyView())
    
    @Published var isAccountDeleted : Bool = false

    @Published var showSignOutConfirm : Bool = false
    @Published var showDeleteConfirm : Bool = false

    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    init()  {
    }
    
    func deleteAccount(){
        guard let roleid = Helper.shared.getUser()?.roleID else {return}
        let parameters:[String:Any] = ["role":roleid]
            print("parameters",parameters)
        let target = Authintications.DeleteAccount(parameters: parameters)
            isLoading = true
            BaseNetwork.CallApi(target, BaseResponse<ManageTeacherProfileM>.self)
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
                    if receivedData.success == true{
                        error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Ok",mainBtnAction: { [weak self] in
                            guard let self = self else {return}
                            isAccountDeleted = true
                            Helper.shared.changeRoot(toView: AnonymousHomeView())
                            Helper.shared.logout()
                        })
                        isError =  true
                    }else{
                        isError =  true
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
    }
}





