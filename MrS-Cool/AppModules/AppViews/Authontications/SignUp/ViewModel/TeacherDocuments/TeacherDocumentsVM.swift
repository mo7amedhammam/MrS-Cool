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
    @Published var documentType : DropDownOption?
    @Published var documentTitle = ""
    @Published var documentOrder = ""

    @Published var documentImg : UIImage? = nil

    @Published var documentPdf : URL? = nil


    @Published var filterdocumentType : DropDownOption?

//    MARK: --- outpust ---
    @Published var isLoading : Bool?
//    {
//        didSet{
//            Shared.shared.state.isLoading.wrappedValue = .constant(isLoading)
//        }
//    }
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var isTeacherHasDocuments: Bool = false
    @Published var TeacherDocuments : [TeacherDocumentM]?{
        didSet{
            isTeacherHasDocuments = !(TeacherDocuments?.isEmpty ?? true)
        }
    }
    
    init()  {
//        GetTeacherDocument()
    }
}

extension TeacherDocumentsVM{
    
    func CreateTeacherDocument(fileType:fileTypesList){
        guard let DocumentTypeId = documentType?.id else {return}
        
        
        var parameters:[String:Any] = ["DocumentTypeId":DocumentTypeId,"Title":documentTitle,"Order":Int(documentOrder) ?? 0]
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
                if let model = receivedData.data{
                    TeacherDocuments?.append(model)
//                    GetTeacherDocument()
                    clearTeachersDocument()
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
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = Authintications.TeacherDeleteDocuments(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherDocumentM>.self)
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
//                    TeacherSubjects = model
                    TeacherDocuments?.removeAll(where: {$0.id == model.id})
                    isError = false
                }else{
                    isError =  true
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

//                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    
    func clearTeachersDocument(){
        documentType = nil
        documentTitle = ""
        documentOrder = ""
        documentImg = nil
        documentPdf = nil
    }


}





