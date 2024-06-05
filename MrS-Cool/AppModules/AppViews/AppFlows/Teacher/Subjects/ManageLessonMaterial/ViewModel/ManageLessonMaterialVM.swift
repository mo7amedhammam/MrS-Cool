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
    
    @Published var editingId = 0
    @Published var TeacherLessonId = 0
    @Published var showEdit = false
    @Published var showBrief = false
    
    @Published var materialType : DropDownOption?{
        didSet{
            ismaterialTypevalid = materialType == nil ? false : true
        }
    }
    @Published var ismaterialTypevalid :Bool?
    
    @Published var materialName = ""{
        didSet{
            ismaterialNamevalid = materialName.isEmpty ? false : true
        }
    }
    @Published var ismaterialNamevalid :Bool?
    
    @Published var materialNameEn = ""{
        didSet{
            ismaterialNameEnvalid = materialNameEn.isEmpty ? false : true
        }
    }
    @Published var ismaterialNameEnvalid :Bool?
    
    //    @Published var materialOrder = ""
    @Published var materialUrl = ""{
        didSet{
//            if !materialUrl.isEmpty{
                ismaterialUrlvalid = materialUrl.isEmpty ? false:true
            
//            }
        }
    }
    @Published var ismaterialUrlvalid :Bool?
    
    @Published var materialImg : UIImage? = nil{
        didSet{
            isdocumentFilevalid = (materialImg == nil && materialPdf == nil ) ? false : true
        }
    }
    
    @Published var materialPdf : URL? = nil{
        didSet{
            isdocumentFilevalid = (materialImg == nil && materialPdf == nil ) ? false : true
        }
    }
    @Published var isdocumentFilevalid :Bool?
        
    @Published var filtermaterialType : DropDownOption?
    @Published var filtermaterialName : String = ""
    //    @Published var filtermaterialOrder = ""
    
    @Published var isEditing = false
    @Published var editingMaterial : TeacherLessonMaterialDto?{
        didSet{
            if editingMaterial == nil{
                materialType = nil
                materialName = ""
                materialNameEn = ""
                materialUrl = ""
                materialImg = nil
                materialPdf = nil
            }else{
                editingId = editingMaterial?.id ?? 0
                materialType = .init(id: editingMaterial?.materialTypeID,Title: editingMaterial?.materialTypeName)
                materialName = editingMaterial?.name ?? ""
                materialNameEn = editingMaterial?.nameEn ?? ""
                materialUrl = editingMaterial?.materialURL ?? ""
                materialImg = nil
                materialPdf = nil
            }
        }
    }
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
 
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasDocuments: Bool = false
    @Published var TeacherLessonMaterialM :GetLessonMaterialM?{
        didSet{
            TeacherLessonMaterialList = TeacherLessonMaterialM?.teacherLessonMaterialDtos 
        }
    }
    
    @Published var TeacherLessonMaterialList : [TeacherLessonMaterialDto]?
  
    
    init()  {
        //        GetTeacherDocument()
    }
}

extension ManageLessonMaterialVM{
    
    func CreateLessonMaterial(fileType:fileTypesList){
        guard checkValidfields() else {return}
        guard let materialTypeId = materialType?.id else {return}
        
        var parameters:[String:Any] = ["MaterialTypeId":materialTypeId,"TeacherLessonId":TeacherLessonId,"Name":materialName,"NameEn":materialNameEn]

        if !materialUrl.isEmpty{
            parameters["MaterialUrl"] = materialUrl
        }else{
            switch fileType {
            case .image:
                parameters["MaterialFile"] = materialImg
            case .pdf:
                parameters["MaterialFile"] = materialPdf
            }
        }
        
        print("parameters",parameters)
        let target = teacherServices.CreateMyLessonMaterial(parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<CreateLessonMaterialM>.self,progressHandler: {progress in})
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
                if receivedData.success == true{
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

    func UpdateLessonMaterial(fileType:fileTypesList){
        guard checkValidfields() else {return}

        guard let materialTypeId = materialType?.id else { return }
        var parameters:[String:Any] = ["id":editingId,"MaterialTypeId":materialTypeId,"TeacherLessonId":TeacherLessonId,"Name":materialName,"NameEn":materialNameEn,"MaterialUrl":materialUrl]
        switch fileType {
        case .image:
            parameters["MaterialFile"] = materialImg
        case .pdf:
            parameters["MaterialFile"] = materialPdf
            
        }
        
        print("parameters",parameters)
        let target = teacherServices.UpdateMyLessonMaterial(parameters: parameters)
        isLoading = true
        BaseNetwork.uploadApi(target, BaseResponse<CreateLessonMaterialM>.self,progressHandler: {progress in})
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
                if receivedData.success == true{
                    GetLessonMaterial()
                    clearTeachersMaterial()
                    isEditing = false
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
                if let model = receivedData.data {
                    TeacherLessonMaterialM = model
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
                if receivedData.success == true{
//                if let model = receivedData.data?.teacherLessonMaterialDtos {
                    
                    //                    TeacherSubjects = model
                                        TeacherLessonMaterialList?.removeAll(where: {$0.id == id})
//                    GetLessonMaterial()
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
        
        isEditing = false
    }
    func clearFilter(){
        filtermaterialType = nil
        filtermaterialName.removeAll()
    }
    private func checkValidfields()->Bool{
        ismaterialTypevalid = materialType != nil
        ismaterialNamevalid = !materialName.isEmpty
        ismaterialNameEnvalid = !materialNameEn.isEmpty
        ismaterialUrlvalid = !materialUrl.isEmpty
        isdocumentFilevalid = materialImg != nil || materialPdf != nil

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
        return ismaterialTypevalid ?? true && ismaterialNamevalid ?? true && ismaterialNameEnvalid ?? true && (ismaterialUrlvalid ?? true || isdocumentFilevalid ?? true )
    }
}





