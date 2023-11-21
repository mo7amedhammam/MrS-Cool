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

    @Published var groupCost : String = ""
    @Published var individualCost : String = ""
//    @Published var minGroup : String = ""
//    @Published var maxGroup : String = ""
    @Published var groupTime = "0"
    @Published var individualTime = "0"
    
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
    
//    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherSubjectLessons : [ManageTeacherSubjectLessonsM]?
    
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
        guard let groupCost = Int(groupCost), let individualCost = Int(individualCost),let groupTime = groupTime.convertTimeToMinutes(),let individualTime = individualTime.convertTimeToMinutes()  else {return}
        let parameters:[String:Any] = ["lessonId":editLessonId,"groupCost":groupCost,"groupDuration":groupTime,"individualCost":individualCost,"individualDuration":individualTime,"id":editRowId,"teacherSubjectAcademicSemesterYearId":editSubjectSemesterYearId ]
        
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
                    UpdateLessonBriefField(receivedData)
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
//        educationType = nil
//        educationLevel = nil
//        academicYear = nil
//        subject = nil
//        
//        minGroup = ""
//        maxGroup = ""
//        groupCost = ""
//        individualCost = ""
//        subjectBrief =  ""
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
//        if let min = item.minGroup{
//            minGroup = String(min)
//        }
//        if let max = item.maxGroup{
//            maxGroup = String(max)
//        }
        if let gcost = item.groupCost{
            groupCost = String(gcost)
        }
        if let indcost = item.individualCost{
            individualCost = String(indcost)
        }

        if let groupDuration = item.groupDuration{
            groupTime = groupDuration.formattedTime()
        }

        if let individualDuration = item.individualDuration{
            individualTime = individualDuration.formattedTime()
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
}




