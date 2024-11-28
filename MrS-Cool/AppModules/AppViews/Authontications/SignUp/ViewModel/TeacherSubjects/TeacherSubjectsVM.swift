//
//  TeacherSubjectsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/10/2023.
//

import Foundation
import Combine

class TeacherSubjectsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
//    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    
    @Published var educationType : DropDownOption?{
        didSet{
            educationLevel = nil
            
            iseducationTypevalid = educationType == nil ? false:true
        }
    }
    @Published var iseducationTypevalid:Bool? 

    @Published var educationLevel : DropDownOption?{
        didSet{
                academicYear = nil
            iseducationLevelvalid = educationLevel == nil ? false:true
        }
    }
    @Published var iseducationLevelvalid:Bool?

    @Published var academicYear : DropDownOption?{
        didSet{
                subject = nil
//            subjectsArr.removeAll()
            isacademicYearvalid = academicYear == nil ? false:true
        }
    }
    @Published var isacademicYearvalid:Bool?

    @Published var subject : DropDownOption?{
        didSet{
            issubjectvalid = subject == nil ? false:true
        }
    }
    @Published var issubjectvalid:Bool?

//    @Published var subjectsArr : [DropDownOption] = []{
//        didSet{
//            issubjectsArrvalid = subjectsArr.isEmpty ? false:true
//        }
//    }
//    @Published var issubjectsArrvalid:Bool?
    
    @Published var SessionPrice : String = ""{
        didSet{
            guard let price = Float(SessionPrice) else {return}
            if price > 0{
                isSessionPricevalid = true
            }else{
                isSessionPricevalid = false
            }
        }

    }
    @Published var isSessionPricevalid:Bool?
    
//    MARK: --- outpust ---
    @Published var showConfirmDelete : Bool = false

    @Published var isLoading : Bool?
    @Published var isError : Bool = false
//    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")

    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherSubjects : [TeacherSubjectM]?{
        didSet{
            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
        }
    }

    
    init()  {
//        GetTeacherSubjects()
    }
}

extension TeacherSubjectsVM{
    
    func CreateTeacherSubject(){
        guard checkValidfields() else {return}
        guard let subjectAcademicYearId = subject?.id , let sessioncost = Float(SessionPrice) else {return}
//        let subjectAcademicYearIds: [Int] = subjectsArr.map { $0.id ?? 0 }
        let parameters:[String:Any] = [
            "subjectSemesterYearId":subjectAcademicYearId,
//            "subjectSemesterYearIds":subjectAcademicYearIds,
            "groupSessionCost" : sessioncost
        ]
        
        print("parameters",parameters)
        let target = Authintications.TeacherRegisterSubjects(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[CreatedTeacherSubjectM]>.self)
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
//                    TeacherSubjects?.append(model)
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        GetTeacherSubjects()
                        clearTeachersSubject()
                    })
                    isError =  true

                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    

    func GetTeacherSubjects(){
        let target = Authintications.TeacherGetSubjects(parameters: [:])
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherSubjectM]>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = .error( image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    TeacherSubjects = model
                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

    func DeleteTeacherSubject(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = Authintications.TeacherDeleteSubjects(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = .error( message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
//                    TeacherSubjects = model
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        TeacherSubjects?.removeAll(where: {$0.id == model.id})
                    })
                    isError =  true

                }else{
                    isError =  true
//                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")

                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    
    func clearTeachersSubject(){
        educationType = nil
        educationLevel = nil
        academicYear = nil
        subject = nil
//        subjectsArr.removeAll()
        SessionPrice = ""
        
        iseducationTypevalid = true
        iseducationLevelvalid = true
        isacademicYearvalid =  true
        issubjectvalid = true
//        issubjectsArrvalid = true

    }

    private func checkValidfields()->Bool{
        iseducationTypevalid = educationType != nil
        iseducationLevelvalid = educationLevel != nil
        isacademicYearvalid = academicYear != nil
        issubjectvalid = subject != nil
        isSessionPricevalid = SessionPrice.count > 0 && Float(SessionPrice) ?? 0 > 0
//        issubjectsArrvalid = !subjectsArr.isEmpty

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
        return iseducationTypevalid ?? true && iseducationLevelvalid ?? true && isacademicYearvalid ?? true && issubjectvalid ?? true && isSessionPricevalid ?? true
    }
}




