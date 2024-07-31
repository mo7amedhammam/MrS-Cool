//
//  ManageTeacherSubjectsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//

import Foundation
import Combine

class ManageTeacherSubjectsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    //    @Published var isUserChangagble = true // available unless teacher save personal data
    
    //    MARK: --- inputs ---
    
    @Published var isEditing = false
    @Published var educationType : DropDownOption?{
        didSet{
            if !isEditing{
                educationLevel = nil
                iseducationTypevalid = educationType == nil ? false:true
            }
        }
    }
    @Published var iseducationTypevalid:Bool?

    @Published var educationLevel : DropDownOption?{
        didSet{
            if !isEditing{
                academicYear = nil
                iseducationLevelvalid = educationLevel == nil ? false:true
            }
        }
    }
    @Published var iseducationLevelvalid:Bool?

    @Published var academicYear : DropDownOption?{
        didSet{
            if !isEditing{
                subject = nil
                isacademicYearvalid = academicYear == nil ? false:true
            }
        }
    }
    @Published var isacademicYearvalid:Bool?

    @Published var subject : DropDownOption?{
        didSet{
            issubjectvalid = subject == nil ? false:true
        }
    }
    @Published var issubjectvalid:Bool?
    
    // for update subject
    @Published var editId : Int = 0
    @Published var groupCost : String = ""{
        didSet{
            isgroupCostvalid = (Float(groupCost) == 0) ? false:true
        }
    }
    @Published var isgroupCostvalid:Bool?
//    @Published var recommendedgroupCostFrom : Float?
//    @Published var recommendedgroupCostTo : Float?

    @Published var individualCost : String = ""{
        didSet{
//            isindividualCostvalid = (individualCost.isEmpty || individualCost == "") ? false:true
        }
    }
    @Published var isindividualCostvalid:Bool?
//    @Published var recommendedindividualCostFrom : Float?
//    @Published var recommendedindividualCostTo : Float?

    @Published var minGroup : String = ""{
        didSet{
//            isminGroupvalid = (minGroup.isEmpty || minGroup == "") ? false:true
        }
    }
    @Published var isminGroupvalid:Bool?
    
    @Published var maxGroup : String = ""{
        didSet{
//            ismaxGroupvalid = (maxGroup.isEmpty || maxGroup == "") ? false:true
        }
    }
    @Published var ismaxGroupvalid:Bool?

    @Published var subjectBrief : String = ""
    @Published var subjectBriefEn : String = ""

//@Published var isSubjectBriefValid: Bool?

//private func validateSubjectBrief() {
// // Regular expression to match Arabic characters
// let arabicRegex = "^[\\p{Arabic} ]+$"
// let predicate = NSPredicate(format:"SELF MATCHES %@", arabicRegex)
// isSubjectBriefValid = predicate.evaluate(with: subjectBrief)
//}
    
    @Published var filterEducationType : DropDownOption?{
        didSet{
            filterEducationLevel = nil
        }
    }
    @Published var filterEducationLevel : DropDownOption?{
        didSet{
            filterAcademicYear = nil
        }
    }
    @Published var filterAcademicYear : DropDownOption?{
        didSet{
            filterSubject = nil
            filterSubjectStatus = nil
        }
    }
    @Published var filterSubject : DropDownOption?
    @Published var filterSubjectStatus : DropDownOption?
    
    //    @Published var editableTeacherSubject : TeacherSubjectM?{
    //        didSet{
    //            isTeacherHasSubjects = !(TeacherSubjects?.isEmpty ?? true)
    //        }
    //    }
    
    
    //    MARK: --- outpust ---
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

extension ManageTeacherSubjectsVM{
    
    func CreateTeacherSubject(){
        guard checkValidfields() else {return}
        
        guard let subjectAcademicYearId = subject?.id, let groupCost = Float(groupCost)
//                , let individualCost = Float(individualCost),let minGroup = Int(minGroup),let maxGroup = Int(maxGroup)
        else {return}
        var parameters:[String:Any] = ["subjectSemesterYearId":subjectAcademicYearId,"groupCost":groupCost,"individualCost":0
//                                       ,"minGroup":minGroup,"maxGroup":maxGroup
        ]
        
        if !subjectBrief.isEmpty || subjectBrief.count > 0 {
            parameters[ "teacherBrief" ] = subjectBrief
        }
        if !subjectBriefEn.isEmpty || subjectBriefEn.count > 0{
            parameters["teacherBriefEn"] = subjectBriefEn
        }

        print("parameters",parameters)
        let target = Authintications.TeacherRegisterSubjects(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
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
                if receivedData.success == true {
                    //                    TeacherSubjects?.append(model)
                    GetTeacherSubjects()
                    clearTeachersSubject()
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func UpdateTeacherSubject(){
        guard checkValidfields() else {return}
        guard let subjectAcademicYearId = subject?.id,let groupCost = Float(groupCost)
//                ,let  individualCost = Float(individualCost),let minGroup = Int(minGroup),let maxGroup = Int(maxGroup)
        else {return}
        var parameters:[String:Any] = ["id":editId,"subjectSemesterYearId":subjectAcademicYearId,"groupCost":groupCost
                                       ,"individualCost":0
//                                       ,"minGroup":minGroup,"maxGroup":maxGroup
        ]
        if !subjectBrief.isEmpty{
            parameters["teacherBrief"] = subjectBrief
        }
        if !subjectBriefEn.isEmpty{
            parameters["teacherBriefEn"] = subjectBriefEn
        }

        print("parameters",parameters)
        let target = teacherServices.UpdateTeacherSubject(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
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
                if receivedData.success == true {
                    //                    TeacherSubjects?.append(model)
                    GetTeacherSubjects()
                    clearTeachersSubject()
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetTeacherSubjects(){
        var parameters : [String:Any] = [:]
        if let educationTypeId = filterEducationType?.id{
            parameters["educationTypeId"] = educationTypeId
        }
        if let educationLevelId = filterEducationLevel?.id{
            parameters["educationLevelId"] = educationLevelId
        }
        if let academicYearId = filterAcademicYear?.id{
            parameters["academicYearId"] = academicYearId
        }
        if let subjectId = filterSubject?.id{
            parameters["subjectId"] = subjectId
        }
        if let statusId = filterSubjectStatus?.id{
            parameters["statusId"] = statusId
        }
        let target = Authintications.TeacherGetSubjects(parameters: parameters)
//        print(target)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[TeacherSubjectM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = .error( image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                    isError =  true
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    TeacherSubjects = model
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
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
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = .error( message: "\(error.localizedDescription)",buttonTitle:"Done")
                    isError =  true
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data{
                    //                    TeacherSubjects = model
                    TeacherSubjects?.removeAll(where: {$0.id == model.id})
                    isEditing = false
                    clearTeachersSubject()
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
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
        
        minGroup = ""
        maxGroup = ""
        groupCost = ""
        individualCost = ""
        subjectBrief =  ""
        subjectBriefEn = ""
        
        isminGroupvalid = true
        ismaxGroupvalid = true
        isgroupCostvalid = true
        isindividualCostvalid = true
        iseducationTypevalid = true
        iseducationLevelvalid = true
        isacademicYearvalid =  true
        issubjectvalid = true
        isEditing = false
    }
    func clearFilter(){
        filterEducationType = nil
        filterEducationLevel = nil
        filterAcademicYear = nil
        filterSubject = nil
        filterSubjectStatus = nil
    }
    func selectSubjectForEdit(item:TeacherSubjectM){
//        print(item)
        isEditing = false
        editId = item.id ?? 0
        educationType = .init(id: item.educationTypeID,Title: item.educationTypeName)
        educationLevel = .init(id: item.educationLevelID,Title: item.educationLevelName)
        academicYear = .init(id: item.academicYearID,Title: item.academicYearName)
        subject = .init(id: item.subjectSemesterYearID,Title: item.subjectSemesterYearName,subject: SubjectsByAcademicLevelM.init(individualCostFrom:item.individualCostFrom, individualCostTo:item.individualCostTo, groupCostFrom:item.groupCostFrom, groupCostTo: item.groupCostTo))
        if let min = item.minGroup{
            minGroup = String(min)
        }
        
        if let max = item.maxGroup{
            maxGroup = String(max)
        }
        
        if let gcost = item.groupCost{
            groupCost = String(gcost)
        }
        if let indcost = item.individualCost{
            individualCost = String(indcost)
        }
        subjectBrief = item.teacherBrief ?? ""
        subjectBriefEn = item.teacherBriefEn ?? ""
        isEditing = true
    }
    
    func cleanup() {
         // Cancel any ongoing Combine subscriptions
         cancellables.forEach { cancellable in
             cancellable.cancel()
         }
         cancellables.removeAll()
     }
    
    private func checkValidfields()->Bool{
        iseducationTypevalid = educationType != nil
        iseducationLevelvalid = educationLevel != nil
        isacademicYearvalid = academicYear != nil
        issubjectvalid = subject != nil

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
//        isminGroupvalid = !minGroup.isEmpty && Int(minGroup) != 0
//        ismaxGroupvalid = !maxGroup.isEmpty && Int(maxGroup) != 0
        isgroupCostvalid = !groupCost.isEmpty && Float(groupCost) != 0
//        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
        
        return iseducationTypevalid ?? true && iseducationLevelvalid ?? true && isacademicYearvalid ?? true && issubjectvalid ?? true && isminGroupvalid ?? true && ismaxGroupvalid ?? true && isgroupCostvalid ?? true && isindividualCostvalid ?? true
    }
}



extension String {
    // Only Arabic input validation
     func isArabicInput() -> Bool {
        let arabicCharacterSet = CharacterSet(charactersIn: "\u{0600}-\u{06FF}\u{0750}-\u{077F}\u{08A0}-\u{08FF}\u{FB50}-\u{FDFF}\u{FE70}-\u{FEFF}\u{10E60}-\u{10E7F}\u{1EC70}-\u{1ECBF}")
        return self.rangeOfCharacter(from: arabicCharacterSet.inverted) == nil
    }
}

