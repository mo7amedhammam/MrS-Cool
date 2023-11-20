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
    @Published var editId : Int = 0
    @Published var groupCost : String = ""
    @Published var individualCost : String = ""
//    @Published var minGroup : String = ""
//    @Published var maxGroup : String = ""
    @Published var subjectBrief : String = ""
    @Published var groupTime = "0"
    @Published var individualTime = "0"

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
    
//    func UpdateTeacherSubjectLesson(id:Int){
//        guard let subjectAcademicYearId = subject?.id, let groupCost = Int(groupCost), let individualCost = Int(individualCost),let minGroup = Int(minGroup),let maxGroup = Int(maxGroup)  else {return}
//        let parameters:[String:Any] = ["id":editId,"subjectAcademicYearId":subjectAcademicYearId,"groupCost":groupCost,"individualCost":individualCost,"minGroup":minGroup,"maxGroup":maxGroup,"teacherBrief":subjectBrief ]
//        
//        print("parameters",parameters)
//        let target = teacherServices.UpdateTeacherSubject(parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<CreatedTeacherSubjectM>.self)
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    isError =  true
//                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if receivedData.success == true {
//                    //                    TeacherSubjects?.append(model)
////                    GetTeacherSubjects()
//                }else{
//                    isError =  true
//                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }

    
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
    func selectSubjectForEdit(item:TeacherUnitLesson){
        isEditing = false
        editId = item.id ?? 0
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
}




