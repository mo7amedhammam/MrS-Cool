//
//  TeacherDocumentsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 30/10/2023.
//

import Foundation
import Combine

class TeacherDocumentsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var documentType : DropDownOption?
    @Published var documentTitle = ""
    @Published var documentOrder = ""

    @Published var document:Data? = nil

    
//    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: Error?

    @Published var isTeacherHasDocuments: Bool = false
    @Published var TeacherDocuments : [TeacherDocumentM]?{
        didSet{
            isTeacherHasDocuments = !(TeacherDocuments?.isEmpty ?? true)
        }
    }
    
    init()  {
        GetTeacherDocument()
    }
}

extension TeacherDocumentsVM{
    
    func CreateTeacherDocument(){
        guard let DocumentTypeId = documentType?.id else {return}
        let parameters:[String:Any] = ["Document":document ?? Data(),"DocumentTypeId":DocumentTypeId,"Title":documentTitle,"Order":Int(documentOrder) ?? 0]
        
        print("parameters",parameters)
        let target = Authintications.TeacherRegisterDocuments(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherDocumentM>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = error
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    TeacherDocuments?.append(model)
//                    GetTeacherDocument()
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    

    func GetTeacherDocument(){
        let target = Authintications.TeacherGetDocuments(parameters: [:])
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherDocumentM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = error
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    TeacherDocuments = model
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
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
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = error
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
//                    TeacherSubjects = model
                    TeacherDocuments?.removeAll(where: {$0.id == model.id})
                }else{
                    isError =  true
                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    
    func clearTeachersDocument(){
        documentType = nil
        documentTitle = ""
        documentOrder = ""
        document = nil
    }


}





