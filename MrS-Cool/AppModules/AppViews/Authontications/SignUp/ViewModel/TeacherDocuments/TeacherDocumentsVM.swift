//
//  TeacherDocumentsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 30/10/2023.
//

import Foundation
import Combine
import SwiftUI

class TeacherDocumentsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var documentType : DropDownOption?{
        didSet{
            isdocumentTypevalid = documentType == nil ? false : true
        }
    }
    @Published var isdocumentTypevalid :Bool? = true

    @Published var documentTitle = ""{
        didSet{
            isdocumentTitlevalid = documentTitle.isEmpty ? false : true
        }
    }
    @Published var isdocumentTitlevalid :Bool? = true

//    @Published var documentOrder = ""{
//        didSet{
//            isdocumentOrdervalid = documentOrder.isEmpty ? false : true
//        }
//    }
//    @Published var isdocumentOrdervalid :Bool? = true

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

    @Published var documentsNote :String?

//    @Published var isFormValid : Bool = true

    @Published var filterdocumentType : DropDownOption?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
//    {
//        didSet{
//            Shared.shared.state.isLoading.wrappedValue = .constant(isLoading)
//        }
//    }
    @Published var showConfirmDelete : Bool = false

    @Published var isError : Bool = false
    @Published var error: AlertType? = nil
//    = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var isshowingConfirmation : Bool = false
    @Published var confirmation: AlertType? = nil

    @Published var isTeacherHasDocuments: Bool = false
    @Published var TeacherDocuments : [TeacherDocumentM]?{
        didSet{
            isTeacherHasDocuments = !(TeacherDocuments?.isEmpty ?? true)
        }
    }
    
    init()  {
//        monitorTextFields()
    }
}

extension TeacherDocumentsVM{
    
    func CreateTeacherDocument(fileType:fileTypesList){
        guard checkValidfields() else {return}
        guard let DocumentTypeId = documentType?.id else {return}
        
        var parameters:[String:Any] = ["DocumentTypeId":DocumentTypeId,"Title":documentTitle,"Order":(TeacherDocuments?.count ?? 0) + 1]
        switch fileType {
        case .image:
            parameters["Document"] = documentImg
        case .pdf:
            parameters["Document"] = documentPdf
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
                        guard let self = self else {return}
                        GetTeacherDocument()
                        clearTeachersDocument()
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
    
    func GetTeacherDocument(){
        var parameters : [String:Any] = [:]
        if let filterdocumentType = filterdocumentType{
            parameters["documentTypeId"] = filterdocumentType.id
        }
        let target = Authintications.TeacherGetDocuments(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherDocumentM]>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
//                    self.error = error
                    self.error = .error(image:nil,  message: "\(error.localizedDescription)",buttonTitle:"Done")

                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    documentsNote =  model.first?.profileStatus != 3 ? receivedData.message:nil
                    TeacherDocuments = model
                }else{
                    isError =  true
                    error = .error( image:nil, message: receivedData.message ?? "",buttonTitle:"Done")

//                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

    func DeleteTeacherDocument(id:Int?){
        error = nil
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = Authintications.TeacherDeleteDocuments(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherDocumentM>.self)
//            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
//                    self.error = error
                    self.error = .error(image:nil,  message: "\(error.localizedDescription)",buttonTitle:"Done")
                    isError =  true

                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true{
//                    TeacherSubjects = model
//                    TeacherDocuments?.removeAll(where: {$0.id == receivedData.data?.id})
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        GetTeacherDocument()
                    })
                    isError =  true

                }else{
                        self.error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                        self.isError =  true
//                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearTeachersDocument(){
        documentType = nil
        documentTitle = ""
//        documentOrder = ""
        documentImg = nil
        documentPdf = nil
        
        isdocumentTypevalid = true
        isdocumentTitlevalid = true
//        isdocumentOrdervalid =  true
        isdocumentFilevalid = true

    }
    func clearFilter(){
        filterdocumentType = nil
    }
  
    

//    func monitorTextFields() {
//        // Publisher for checking if the password & its confirmation is valid
//        var isFileValid : AnyPublisher<Bool,Never>{
//            Publishers.CombineLatest3($documentImg,$documentPdf,$documentType)
//                .map{valid1,valid2, valid3 in
//                    guard valid1 != nil && (valid2 != nil || valid3 != nil) else{return false}
//                    return true
//                }
//                .eraseToAnyPublisher()
//        }
//        // Combine publishers for form validation
//              Publishers.CombineLatest3( $documentTitle,$documentOrder,isFileValid)
//                  .map { [weak self] valid1, valid2, valid3 in
//                      // Perform the validation checks
//                      let type = !valid1.isEmpty
//                      let title = !valid2.isEmpty
//
//                      // Return the overall form validity
//                      return type && title && valid3
//                  }
//                  .assign(to: &$isFormValid)
//    }

    
    private func checkValidfields()->Bool{
        isdocumentTypevalid = documentType != nil
        isdocumentTitlevalid = !documentTitle.isEmpty
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
        return isdocumentTypevalid ?? true && isdocumentTitlevalid ?? true && isdocumentFilevalid ?? true
    }
}





