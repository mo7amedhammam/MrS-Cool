//
//  TeacherInfoVM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/03/2024.
//

import Foundation
import Combine

class TeacherInfoVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
//    @Published var bookingcase : LessonCases?
//    @Published var subjectId : Int?
//    @Published var lessonId : Int?
//    @Published var rate : Int = 0
//    @Published var priceFrom : Int?
    
    @Published var SelectedStudentSubjects : HomeSubject = HomeSubject(id: nil, name: nil, image: nil)
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var Teacher:TeacherInfoM? = TeacherInfoM.init()
//    @Published var selectedLessonGroup:Int? = 0
//    @Published var selectedsched:TeacherAvaliableSchedualDto?
//    @Published var isCheckoutSuccess : Bool?

    init()  {
    }
}

extension TeacherInfoVM{
    func GetTeacherInfo(TeacherId:Int){
        var parameters:[String:Any] = ["TeacherProfileId" : TeacherId]
        if let AppCountryId = Helper.shared.getAppCountry()?.id{
            parameters["AppCountryId"] = AppCountryId
        }
        print("parameters",parameters)
        let target = StudentServices.GetTeacherProfileView(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherInfoM>.self)
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
                        Teacher = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

//    func CreateBookCheckout(Id:Int){
//        var parameters:[String:Any] = [:]
//        switch bookingcase{
//        case .Group:
//            parameters["teacherLessonSessionId"] = Id
//            
//        case .Individual:
//            parameters["teacherLessonId"] = Id
//            parameters["startDate"] = Teacher?.startDate ?? ""
//            parameters["timeFrom"] = Teacher?.fromTime ?? ""
//            parameters["timeTo"] = Teacher?.timeTo ?? ""
//
//        case .none:
//            parameters["teacherLessonSessionId"] = Id
//        }
//        print("parameters",parameters)
//        let target = StudentServices.CreateOutBookTeacherSession(parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<BookingCheckoutM>.self)
//            .receive(on: DispatchQueue.main) // Receive on the main thread if you want to update UI
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
//                    isCheckoutSuccess = true
//                }else{
//                    isCheckoutSuccess = false
//
////                    isError =  true
////                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
////                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }

//    func cleanup() {
//        isCheckoutSuccess = nil
//        // Cancel any ongoing Combine subscriptions
//        cancellables.forEach { cancellable in
//            cancellable.cancel()
//        }
//        cancellables.removeAll()
//    }
}




