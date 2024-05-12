//
//  ManageTeacherSubjectLessonsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import Foundation
import Combine

class ManageTeacherSubjectLessonsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    //    @Published var isUserChangagble = true // available unless teacher save personal data
    
    //    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    @Published var subjectSemesterYearId = 0
    @Published var lessonName = ""
    //    @Published var phone = ""
    //    @Published var Password = ""
    //    @Published var selectedGender : DropDownOption?
    //    @Published var confirmPassword = ""
    //    @Published var acceptTerms = false
    
    //Student data
    //    @Published var birthDate : Date?
    //    // next 4  common with teacher subjects
    //    @Published var birthDateStr = ""
    
    @Published var isEditing = false
    @Published var showEdit = false
    @Published var showBrief = false
//    @Published var educationType : DropDownOption?{
//        didSet{
//            if !isEditing{
//                educationLevel = nil
//            }
//        }
//    }
//    @Published var educationLevel : DropDownOption?{
//        didSet{
//            if !isEditing{
//                academicYear = nil
//            }
//        }
//    }
//    @Published var academicYear : DropDownOption?{
//        didSet{
//            if !isEditing{
//                subject = nil
//            }
//        }
//    }
//    @Published var subject : DropDownOption?
    
    // for update subject
    @Published var editLessonId : Int = 0
    @Published var editRowId : Int = 0
    @Published var editSubjectSemesterYearId : Int = 0

    @Published var groupCost : String = ""{
        didSet{
            isgroupCostvalid = (groupCost.isEmpty || Float(groupCost) == 0) ? false:true
        }
    }
    @Published var isgroupCostvalid:Bool?
    
    @Published var individualCost : String = ""{
        didSet{
            isindividualCostvalid = (individualCost.isEmpty || Float(individualCost) == 0) ? false:true
        }
    }
    @Published var isindividualCostvalid:Bool?
    
    @Published var recommendedgroupCost : String = ""
    @Published var recommendedindividualCost: String = ""

    @Published var minGroup : String = ""{
        didSet{
            isminGroupvalid = (minGroup.isEmpty || Int(minGroup) == 0) ? false:true
        }
    }
    @Published var isminGroupvalid:Bool?
    
    @Published var maxGroup : String = ""{
        didSet{
            ismaxGroupvalid = (maxGroup.isEmpty || Int(maxGroup) == 0) ? false:true
        }
    }
    @Published var ismaxGroupvalid:Bool?
    
    @Published var groupTime = ""{
        didSet{
            isgroupTimevalid = (groupTime.isEmpty || Int(groupTime) == 0) ? false:true
        }
    }
    @Published var isgroupTimevalid:Bool?
    
    @Published var individualTime = ""{
        didSet{
            isindividualTimevalid = (individualTime.isEmpty || Int(individualTime) == 0) ? false:true
        }
    }
    @Published var isindividualTimevalid:Bool?
    
    @Published var subjectBrief : String = ""
    @Published var subjectBriefEn : String = ""

//    @Published var filterEducationType : DropDownOption?{
//        didSet{
//            filterEducationLevel = nil
//        }
//    }
//    @Published var filterEducationLevel : DropDownOption?{
//        didSet{
//            filterAcademicYear = nil
//        }
//    }
//    @Published var filterAcademicYear : DropDownOption?{
//        didSet{
//            filterSubject = nil
//            filterSubjectStatus = nil
//        }
//    }
//    @Published var filterSubject : DropDownOption?
//    @Published var filterSubjectStatus : DropDownOption?
    
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
    
    @Published var TeacherSubjectLessons : [ManageTeacherSubjectLessonsM]?
//    @Published var isTeacherLessonUpdated: Bool = false

    init()  {
        //        GetTeacherSubjects()
    }
}

extension ManageTeacherSubjectLessonsVM{
    
    func GetTeacherSubjectLessons(){
//        guard let subjectAcademicYearId = m?.id else {return}
        var parameters:[String:Any] = ["subjectSemesterYearId":subjectSemesterYearId]
        if lessonName.count > 0{
            parameters["lessonName"] = lessonName
        }
        
        print("parameters",parameters)
        let target = teacherServices.GetTeacherSubjectLessons(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[ManageTeacherSubjectLessonsM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    isError =  true
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data {
                    TeacherSubjectLessons = model
                    //                    GetTeacherSubjects()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func UpdateTeacherSubjectLesson(){
        guard checkValidfields() else {return }
        guard let groupCost = Float(groupCost), let individualCost = Float(individualCost),let groupTime = Int(groupTime),let individualTime = Int(individualTime),let mingroup = Int(minGroup),let maxgroup = Int(maxGroup)  else {return}
        let parameters:[String:Any] = ["lessonId":editLessonId,"groupCost":groupCost,"groupDuration":groupTime,"individualCost":individualCost,"individualDuration":individualTime,"minGroup":mingroup,"maxGroup":maxgroup,"id":editRowId,"teacherSubjectAcademicSemesterYearId":editSubjectSemesterYearId ]
        
        print("parameters",parameters)
        let target = teacherServices.UpdateTeacherSubjectLessons(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<UpdatedTeacherSubjectLessonsM>.self)
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
                    showEdit = false
                    GetTeacherSubjectLessons()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetSubjectLessonBrief(){
        let parameters:[String:Any] = ["Id":editRowId]
        
        print("parameters",parameters)
        let target = teacherServices.GetSubjectLessonsBrief(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjecLessonBriefM>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    isError =  true
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if let model = receivedData.data {
                    subjectBrief = model.teacherBrief ?? ""
                    subjectBriefEn = model.teacherBriefEn ?? ""
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func UpdateSubjectLessonBrief(){
        let parameters:[String:Any] = ["id":editRowId,"teacherBrief":subjectBrief,"teacherBriefEn":subjectBriefEn]
        
        print("parameters",parameters)
        let target = teacherServices.UpdateSubjectLessonsBrief(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjecLessonBriefM>.self)
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
                    showBrief = false
//                    UpdateLessonBriefField(receivedData)
                    GetTeacherSubjectLessons()
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearTeachersLesson(){
//        educationType = nil
//        educationLevel = nil
//        academicYear = nil
//        subject = nil
//        
        minGroup = ""
        maxGroup = ""
        groupCost = ""
        individualCost = ""
        groupTime = ""
        individualTime = ""
        subjectBrief =  ""
    }
    func clearFilter(){
        lessonName = ""
    }
    func selectSubjectForEdit(subjectSemeterYearId:Int?,item:TeacherUnitLesson){
        isEditing = false
        editLessonId = item.lessonID ?? 0
        editRowId = item.id ?? 0
        editSubjectSemesterYearId =  subjectSemeterYearId ?? 0
//        educationType = .init(id: item.educationTypeID,Title: item.educationTypeName)
//        educationLevel = .init(id: item.educationLevelID,Title: item.educationLevelName)
//        academicYear = .init(id: item.subjectAcademicYearID,Title: item.academicYearName)
//        subject = .init(id: item.subjectAcademicYearID,Title: item.subjectDisplayName)
        
        if let min = item.minGroup{
            minGroup = String(min)
        }
        if let max = item.maxGroup{
            maxGroup = String(max)
        }
        if let gcost = item.groupCost, let rgcost = item.defaultGroupCost{
            groupCost = String(gcost)
            recommendedgroupCost = String(rgcost)
        }
        if let indcost = item.individualCost, let rindcost = item.defaultIndividualCost{
            individualCost = String(indcost)
            recommendedindividualCost = String(rindcost)
        }

        if let groupDuration = item.groupDuration{
//            groupTime = groupDuration.formattedTime()
            groupTime = String(groupDuration)
        }

        if let individualDuration = item.individualDuration{
//            individualTime = individualDuration.formattedTime()
            individualTime = String(individualDuration)
        }
        //        subjectBrief = item.teacherBrief ?? ""
        isEditing = true
    }
    
    func cleanup() {
         // Cancel any ongoing Combine subscriptions
         cancellables.forEach { cancellable in
             cancellable.cancel()
         }
         cancellables.removeAll()
     }
    
    
    fileprivate func UpdateLessonBriefField(_ receivedData: BaseResponse<SubjecLessonBriefM>) {
        let yourLessonID = receivedData.data?.id  // Replace with the specific lesson ID you're looking for
        
        if let lessonIndex = TeacherSubjectLessons?.firstIndex(where: { $0.teacherUnitLessons?.contains(where: { $0.lessonID == yourLessonID }) ?? false }),
           let lesson = TeacherSubjectLessons?[lessonIndex].teacherUnitLessons?.firstIndex(where: { $0.lessonID == yourLessonID }) {
            // You found the lesson with the specified ID
            print("Lesson found at index: \(lessonIndex)")
            
            // Update the teacherBrief value
            TeacherSubjectLessons?[lessonIndex].teacherUnitLessons?[lesson].teacherBrief = receivedData.data?.teacherBrief
        } else {
            // Lesson not found
            print("Lesson not found")
        }
    }
    
    private func checkValidfields()->Bool{
//        iseducationTypevalid = educationType != nil
//        iseducationLevelvalid = educationLevel != nil
//        isacademicYearvalid = academicYear != nil
//        issubjectvalid = subject != nil

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
        isminGroupvalid = !minGroup.isEmpty && Int(minGroup) != 0
        ismaxGroupvalid = !maxGroup.isEmpty && Int(maxGroup) != 0
        isgroupCostvalid = !groupCost.isEmpty && Int(groupCost) != 0
        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
        isgroupTimevalid = !groupTime.isEmpty && Int(groupTime) != 0
        isindividualTimevalid = !individualTime.isEmpty && Int(individualTime) != 0

        return isgroupTimevalid ?? true && isindividualTimevalid ?? true && isminGroupvalid ?? true && ismaxGroupvalid ?? true && isgroupCostvalid ?? true && isindividualCostvalid ?? true
    }

}




