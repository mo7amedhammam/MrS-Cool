//
//  StudentHomeVM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/01/2024.
//

import Foundation
import Combine
enum studentLessonMostCases{
    case mostviewed, mostBooked
}
enum studentTeacherMostCases{
    case mostviewed, topRated
}


class StudentHomeVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    //    @Published var letsPreview : Bool = false
    
    @Published var StudentSubjects : [StudentSubjectsM]? = []
    //    [StudentSubjectsM.init(id: 0, name: "arabic", image: "tab1"),StudentSubjectsM.init(id: 1, name: "arabic1", image: "tab2"),StudentSubjectsM.init(id: 2, name: "arabic2", image: "tab2")]
    @Published var SelectedStudentSubjects : StudentSubjectsM = StudentSubjectsM()
    
    @Published var StudentMostViewedLessons : [StudentMostViewedLessonsM] = []
    //    [StudentMostViewedLessonsM.init(id: 0, lessonName: "grammer", subjectName: "arabic", lessonBrief: "brief 0", availableTeacher: 12, minPrice: 220, maxPrice: 550)]
    @Published var SelectedStudentMostViewedLesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM()
    
    @Published var StudentMostBookedLessons : [StudentMostViewedLessonsM] =  []
    //    [StudentMostViewedLessonsM.init(id: 0, lessonName: "grammer", subjectName: "arabic", lessonBrief: "brief 2", availableTeacher: 12, minPrice: 220, maxPrice: 550)]
    @Published var SelectedStudentMostBookedLesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM()
    
    @Published var StudentMostViewedSubjects : [StudentMostViewedSubjectsM] =  []
    //    [StudentMostViewedSubjectsM.init(id: 0, subjectName: "subjects name", image: "image", subjectBrief: "brief", lessonsCount: 3, teacherCount: 12) ]
    @Published var SelectedStudentMostViewedSubject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
    
    @Published var StudentMostBookedsubjects : [StudentMostViewedSubjectsM] = []
    //    [StudentMostViewedSubjectsM.init(id: 0, subjectName: "subjects name", image: "image", subjectBrief: "brief", lessonsCount: 3, teacherCount: 12)]
    @Published var SelectedStudentMostBookedSubject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
    
    @Published var StudentMostViewedTeachers : [StudentMostViewedTeachersM] = []
    //    [StudentMostViewedTeachersM.init(id: 0, teacherName: "teacher name", teacherImage: "image", teacherLessonId: 2, teacherSubjectId: 3, duration: 120, teacherReview: 5, price: 220, teacherRate: 3.5) ]
    @Published var SelectedStudentMostViewedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()
    
    @Published var StudentMostRatedTeachers : [StudentMostViewedTeachersM] = []
    //    [StudentMostViewedTeachersM.init(id: 0, teacherName: "teacher name", teacherImage: "image", teacherLessonId: 2, teacherSubjectId: 3, duration: 120, teacherReview: 8, price: 220, teacherRate: 3.5)]
    @Published var SelectedStudentMostRatedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()
    
    init()  {
        DispatchQueue.global(qos: .background).async {[weak self] in
            
            guard let self = self else{return}
            GetStudentSubjects()
            
            // Perform the background task here
            GetStudentLessons(mostType: .mostviewed)
            GetStudentLessons(mostType: .mostBooked)
            
            GetStudentMostSubjects(mostType: .mostviewed)
            GetStudentMostSubjects(mostType: .mostBooked)
            
            GetStudentTeachers(mostType: .mostviewed)
            GetStudentTeachers(mostType: .topRated)
        }
    }
}

extension StudentHomeVM{
    
    func GetStudentSubjects(){
        var parameters:[String:Any] = [:]
        print("parameters",parameters)
        let target = StudentServices.GetStudentSubjects(parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentSubjectsM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                //                isLoading = false
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
                    StudentSubjects = receivedData.data
                }else{
                    //                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                //                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetStudentMostSubjects(mostType:studentLessonMostCases){
        var parameters:[String:Any] = [:]
        print("parameters",parameters)
        let target = StudentServices.GetMostSubjects(mostType: mostType, parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedSubjectsM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                //                isLoading = false
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
                    switch mostType {
                    case .mostviewed:
                        StudentMostViewedSubjects = receivedData.data ?? []
                    case .mostBooked:
                        StudentMostBookedsubjects = receivedData.data ?? []
                    }
                    
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                //                isLoading = false
            })
            .store(in: &cancellables)
    }
    func GetStudentLessons(mostType:studentLessonMostCases){
        var parameters:[String:Any] = [:]
        print("parameters",parameters)
        let target = StudentServices.GetMostLessons(mostType: mostType, parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedLessonsM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                //                isLoading = false
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
                    switch mostType {
                    case .mostviewed:
                        StudentMostViewedLessons = receivedData.data ?? []
                    case .mostBooked:
                        StudentMostBookedLessons = receivedData.data ?? []
                    }
                    
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                //                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func GetStudentTeachers(mostType:studentTeacherMostCases){
        var parameters:[String:Any] = [:]
        print("parameters",parameters)
        let target = StudentServices.GetMostTeachers(mostType: mostType, parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedTeachersM]>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                //                isLoading = false
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
                    switch mostType {
                    case .mostviewed:
                        StudentMostViewedTeachers = receivedData.data ?? []
                    case .topRated:
                        StudentMostRatedTeachers = receivedData.data ?? []
                    }
                    
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                //                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func clearselections(){
        SelectedStudentSubjects = StudentSubjectsM()
        SelectedStudentMostViewedLesson = StudentMostViewedLessonsM()
        SelectedStudentMostBookedLesson = StudentMostViewedLessonsM()
        SelectedStudentMostViewedSubject = StudentMostViewedSubjectsM()
        SelectedStudentMostBookedSubject = StudentMostViewedSubjectsM()
        SelectedStudentMostViewedTeachers = StudentMostViewedTeachersM()
        SelectedStudentMostRatedTeachers = StudentMostViewedTeachersM()
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}



