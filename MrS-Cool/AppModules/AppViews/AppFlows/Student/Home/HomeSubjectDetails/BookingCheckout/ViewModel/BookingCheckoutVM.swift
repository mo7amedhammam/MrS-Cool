//
//  BookingCheckoutVM.swift
//  MrS-Cool
//
//  Created by wecancity on 03/02/2024.
//

import Foundation
import Combine

class BookingCheckoutVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var bookingcase : LessonCases = .Group
//    @Published var subjectId : Int?
//    @Published var lessonId : Int?
//    @Published var rate : Int = 0
//    @Published var priceFrom : Int?
//    @Published var priceTo : Int?
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var Checkout:BookingCheckoutM? = BookingCheckoutM.init()
//    @Published var selectedLessonGroup:Int? = 0
//    @Published var selectedsched:TeacherAvaliableSchedualDto?

    init()  {
    }
}

extension BookingCheckoutVM{
    func GetBookCheckout(lessonId:Int){
        let parameters:[String:Any] = ["teacherLessonId":lessonId]
        print("parameters",parameters)
        let target = StudentServices.GetCheckOutBookTeacherSession(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<BookingCheckoutM>.self)
            .receive(on: DispatchQueue.main) // Receive on the main thread if you want to update UI
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
                        Checkout = receivedData.data
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




