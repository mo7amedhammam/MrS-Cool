//
//  BookingCheckoutVM.swift
//  MrS-Cool
//
//  Created by wecancity on 03/02/2024.
//

import Foundation
import Combine
import UIKit

class BookingCheckoutVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var bookingcase : LessonCases? 
    @Published var selectedDataToBook :selectedDataToBook?
//    @Published var subjectId : Int?
//    @Published var lessonId : Int?
//    @Published var rate : Int = 0
//    @Published var priceFrom : Int?
//    @Published var priceTo : Int?
    
    //MARK: --  Bank Tranfer --
    @Published var documentImg : UIImage? = nil{
        didSet{
            isdocumentFilevalid = (documentImg == nil && documentPdf == nil) ? false : true
        }
    }

    @Published var documentPdf : URL? = nil{
        didSet{
            isdocumentFilevalid = (documentImg == nil && documentPdf == nil) ? false : true
        }
    }
    @Published var isdocumentFilevalid :Bool? = true
        @Published var Comment : String = ""

    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var Checkout:BookingCheckoutM? = BookingCheckoutM.init()
    @Published var CreatedBooking:BookingCreateM? = BookingCreateM.init()
    
//    @Published var selectedLessonGroup:Int? = 0
//    @Published var selectedsched:TeacherAvaliableSchedualDto?
    @Published var isCheckoutSuccess : Bool = false
    init()  {
    }
}

extension BookingCheckoutVM{
    func GetBookCheckout(Id:Int){
        guard let data = selectedDataToBook else{return}
        var parameters:[String:Any] = [:]
        switch bookingcase{
        case .Group:
            parameters["teacherLessonSessionId"] = data.selectedId
            
        case .Individual:
            parameters["teacherLessonId"] = data.selectedId
            parameters["date"] = data.Date
            parameters["toTime"] = data.ToTime
            parameters["fromTime"] = data.FromTime

        case .none:
            parameters["teacherLessonSessionId"] = data.selectedId
        }
        
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["studentId"] = Helper.shared.selectedchild?.id
        }
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

    func CreateBookCheckout(Id:Int){
        var parameters:[String:Any] = [:]
        switch bookingcase{
        case .Group:
            parameters["teacherLessonSessionId"] = Id
            
        case .Individual:
            parameters["teacherLessonId"] = Id
            parameters["date"] = Checkout?.startDate ?? ""
            parameters["fromTime"] = Checkout?.fromTime ?? ""
            parameters["toTime"] = Checkout?.toTime ?? ""

        case .none:
            parameters["teacherLessonSessionId"] = Id
        }
        if Helper.shared.getSelectedUserType() == .Parent {
            parameters["studentId"] = Helper.shared.selectedchild?.id
        }
        print("parameters",parameters)
        let target = StudentServices.CreateOutBookTeacherSession(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<BookingCreateM>.self)
            .receive(on: DispatchQueue.main) // Receive on the main thread if you want to update UI
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                    isError =  true

                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true ,let model = receivedData.data{
                    CreatedBooking = model
                    isCheckoutSuccess = true
                }else{
                    isCheckoutSuccess = false

//                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

    func cleanup() {
        isCheckoutSuccess = false
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
    
}


extension BookingCheckoutVM{
    func UploadTransferImage(){
        guard checkValidfields() else {return}
        
        var parameters:[String:Any] = [:]
        if Comment.count > 0{
            parameters["Comment"] = Comment
        }
        if let documentImg = documentImg {
            parameters["Document"] = documentImg

        }else if let documentpdf = documentPdf{
            parameters["Document"] = documentpdf

        }
        print("parameters",parameters)
        let target = Authintications.TeacherRegisterDocuments(parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<TeacherDocumentM>.self,progressHandler: {progress in})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = .error(image:nil,  message: "\(error.localizedDescription)",buttonTitle:"Done")
                    isError =  true
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true {
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
//                        guard let self = self else {return}
//                        GetTeacherDocument()
//                        clearTeachersDocument()
                    })
                    isError =  true
                    //                    TeacherDocuments?.append(model)
                    //                    GetTeacherDocument()

                }else{
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                   error =  NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func ClearTransfer(){
        documentImg = nil
        Comment.removeAll()
        //            documentPdf = nil
        
        //            isdocumentTypevalid = true
        //            isdocumentTitlevalid = true
        //        isdocumentOrdervalid =  true
        isdocumentFilevalid = true
    }
    private func checkValidfields()->Bool{
//        isdocumentTypevalid = documentType != nil
//        isdocumentTitlevalid = !documentTitle.isEmpty
//        isdocumentOrdervalid = !documentOrder.isEmpty
        isdocumentFilevalid = documentImg != nil || documentPdf != nil

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
        return isdocumentFilevalid ?? true
    }
}


