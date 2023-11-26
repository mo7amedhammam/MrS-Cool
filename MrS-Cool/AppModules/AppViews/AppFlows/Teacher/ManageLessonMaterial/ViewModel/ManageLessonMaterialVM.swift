//
//  ManageLessonMaterialVM.swift
//  MrS-Cool
//
//  Created by wecancity on 25/11/2023.
//

import Foundation
import Combine
import SwiftUI

class ManageLessonMaterialVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var TeacherLessonId = 0
    @Published var isEditing = false
    @Published var showEdit = false
    @Published var showBrief = false
    
    
    @Published var materialType : DropDownOption?
    @Published var materialName = ""
    @Published var materialNameEn = ""
    //    @Published var materialOrder = ""
    @Published var materialUrl = ""
    
    @Published var materialImg : UIImage? = nil
    
    @Published var materialPdf : URL? = nil
    
    
    @Published var filtermaterialType : DropDownOption?
    @Published var filtermaterialName : String = ""
    //    @Published var filtermaterialOrder = ""
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    //    {
    //        didSet{
    //            Shared.shared.state.isLoading.wrappedValue = .constant(isLoading)
    //        }
    //    }
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasDocuments: Bool = false
    @Published var TeacherLessonMaterial : [TeacherLessonMaterialDto]?
    //    {
    //        didSet{
    //            isTeacherHasDocuments = !(TeacherDocuments?.isEmpty ?? true)
    //        }
    //    }
    
    init()  {
        //        GetTeacherDocument()
    }
}

extension ManageLessonMaterialVM{
    
    func CreateLessonMaterial(fileType:fileTypesList){
        guard let materialTypeId = materialType?.id else {return}
        
        
        var parameters:[String:Any] = ["MaterialTypeId":materialTypeId,"TeacherLessonId":TeacherLessonId,"Name":materialName,"NameEn":materialNameEn,"MaterialUrl":materialUrl]
        switch fileType {
        case .image:
            parameters["MaterialFile"] = materialImg
        case .pdf:
            parameters["MaterialFile"] = materialPdf
            
        }
        
        print("parameters",parameters)
        let target = teacherServices.CreateMyLessonMaterial(parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<CreateLessonMaterialM>.self,progressHandler: {progress in})
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
                    GetLessonMaterial()
                    clearTeachersMaterial()
                }else{
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    //                   error =  NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetLessonMaterial(){
        var parameters : [String:Any] = ["teacherLessonId":TeacherLessonId]
        if let filtermaterialType = filtermaterialType{
            parameters["materialTypeId"] = filtermaterialType.id
        }
        if filtermaterialName != ""{
            parameters["materialName"] = filtermaterialName
        }
        let target = teacherServices.GetMyLessonMaterial(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<GetLessonMaterialM>.self)
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
                if let model = receivedData.data?.teacherLessonMaterialDtos {
                    TeacherLessonMaterial = model
                }else{
                    isError =  true
                    error = .error( image:nil, message: receivedData.message ?? "",buttonTitle:"Done")
                    
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteLessonMaterial(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.DeleteLessonMaterial(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<GetLessonMaterialM>.self)
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
                if let model = receivedData.data?.teacherLessonMaterialDtos {
                    //                    TeacherSubjects = model
                    //                    TeacherLessonMaterial?.removeAll(where: {$0.id == model.id})
                    GetLessonMaterial()
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
    
    func clearTeachersMaterial(){
        materialType = nil
        materialName = ""
        materialNameEn = ""
        materialImg = nil
        materialPdf = nil
        materialUrl = ""
    }
}





