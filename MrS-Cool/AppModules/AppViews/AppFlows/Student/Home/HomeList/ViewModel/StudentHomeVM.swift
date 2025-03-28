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
    @Published var educationType : DropDownOption?{
        didSet{
            educationLevel = nil
        }
    }
    @Published var educationLevel : DropDownOption?{
        didSet{
            academicYear = nil
        }
    }
    @Published var academicYear : DropDownOption?{
        didSet{
            isacademicYearvalid = academicYear != nil
        }
    }
    @Published var isacademicYearvalid : Bool = true
    
//    @Published var term : DropDownOption?{
//        didSet{
//            isacademicYearvalid = term != nil && academicYear != nil
//        }
//    }
    
    
    //    MARK: -  for student -
    @Published var academicLevelId:Int?
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    //    @Published var letsPreview : Bool = false
    
    @Published var StudentSubjectsM: StudentSubjectsM?{
        didSet{
            StudentSubjects = StudentSubjectsM?.subjects
        }
    }
    
    @Published var StudentSubjects : [HomeSubject]? = []
    @Published var SelectedStudentSubjects : HomeSubject = HomeSubject()
    @Published var newStudentSubjects : [StudentMostViewedSubjectsM] =  []
    @Published var newSSelectedStudentSubjects : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
    
    
    @Published var StudentMostViewedLessons : [StudentMostViewedLessonsM] = []
    @Published var SelectedStudentMostViewedLesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM()
    
    @Published var StudentMostBookedLessons : [StudentMostViewedLessonsM] =  []
    @Published var SelectedStudentMostBookedLesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM()
    
    @Published var StudentMostViewedSubjects : [StudentMostViewedSubjectsM] =  []
    @Published var SelectedStudentMostViewedSubject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
    
    @Published var StudentMostBookedsubjects : [StudentMostViewedSubjectsM] = []
    @Published var SelectedStudentMostBookedSubject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
    
    @Published var StudentMostViewedTeachers : [StudentMostViewedTeachersM] = []
    @Published var SelectedStudentMostViewedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()
    
    @Published var StudentMostRatedTeachers : [StudentMostViewedTeachersM] = []
    @Published var SelectedStudentMostRatedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()
    
    @Published var StudentMostBookedTeachers : [StudentMostViewedTeachersM] = []
    @Published var SelectedStudentMostBookedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()
    
    init()  {
    }
}

extension StudentHomeVM{
    
    func GetStudentSubjects(){
        var parameters:[String:Any] = [:]
        print("parameters",parameters) // id
        if Helper.shared.CheckIfLoggedIn() == true && !(Helper.shared.getSelectedUserType() == .Teacher){
            if Helper.shared.getSelectedUserType() == .Parent{
                parameters["id"] = Helper.shared.selectedchild?.id ?? 0
            }
            let target = StudentServices.GetStudentSubjects(parameters: parameters)
            //        isLoading = true
            BaseNetwork.CallApi(target, BaseResponse<StudentSubjectsM>.self)
            //                .receive(on: DispatchQueue.main)
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
                        StudentSubjectsM = receivedData.data
                    }else{
                        //                    isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    //                isLoading = false
                })
                .store(in: &cancellables)
            
        }else{
            // MARK: -- anonymous --
            parameters["maxResultCount"] = 25
            parameters["skipCount"] = 0
            if let educationLevelid = academicYear?.id {
                parameters["academicEducationLevelId"] = educationLevelid
            }
//            if let termid = term?.id{
//                parameters["semesterId"] = termid
//            }
            
            let target = StudentServices.GetStudentSubjects(parameters: parameters)
            //        isLoading = true
            BaseNetwork.CallApi(target, BaseResponse<AnonymousallSubjectM>.self)
            //                .receive(on: DispatchQueue.main)
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
                    if receivedData.success == true,let data = receivedData.data {
                        //                    TeacherSubjects?.append(model)
                        //                        newStudentSubjects = data.getAllSubjects?.newconvertToStudentSubjects()
                        
                        guard let subjects = data.getAllSubjects else {return}
                        //                        StudentSubjects = subjects.convertToStudentSubjects()
                        
                        newStudentSubjects = subjects.newconvertToStudentSubjects()
                    }else{
                        //                    isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    //                isLoading = false
                })
                .store(in: &cancellables)
        }
        
    }
    
    func GetStudentMostSubjects(mostType:studentLessonMostCases){
        var parameters:[String:Any] = [:]
        if let academicLevelId = academicLevelId{
            parameters["academicLevelId"] = academicLevelId
        }else if let educationLevelid = academicYear?.id{
            parameters["academicLevelId"] = educationLevelid
        }
        print("parameters",parameters)
        
        let target = StudentServices.GetMostSubjects(mostType: mostType, parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedSubjectsM]>.self)
        //            .receive(on: DispatchQueue.main)
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
        if let academicLevelId = academicLevelId{
            parameters["academicleveid"] = academicLevelId
        }else if let educationLevelid = academicYear?.id{
            parameters["academicleveid"] = educationLevelid
        }
        print("parameters",parameters)
        
        let target = StudentServices.GetMostLessons(mostType: mostType, parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedLessonsM]>.self)
        //            .receive(on: DispatchQueue.main)
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
        if let academicLevelId = academicLevelId{
            parameters["academicLevelId"] = academicLevelId
        }else if let educationLevelid = academicYear?.id{
            parameters["academicLevelId"] = educationLevelid
        }
        print("parameters",parameters)
        let target = StudentServices.GetMostTeachers(mostType: mostType, parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedTeachersM]>.self)
        //            .receive(on: DispatchQueue.main)
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
    
    func GetStudentMostBookedTeachers(){
        var parameters:[String:Any] = [:]
        if let academicLevelId = academicLevelId{
            parameters["academicLevelId"] = academicLevelId
        }else if let educationLevelid = academicYear?.id {
            parameters["academicLevelId"] = educationLevelid
        }
        print("parameters",parameters)
        let target = StudentServices.GetMostBookedTeachers(parameters: parameters)
        //        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[StudentMostViewedTeachersM]>.self)
        //            .receive(on: DispatchQueue.main)
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
                    StudentMostBookedTeachers = receivedData.data ?? []
                    
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                //                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func getHomeData(){
        //    DispatchQueue.global(qos: .background).async {[weak self] in
        
        //        guard let self = self else{return}
        let DispatchGroup = DispatchGroup()
        DispatchGroup.enter()
        
        GetStudentSubjects()
        
        DispatchGroup.enter()
        // Perform the background task here
        GetStudentLessons(mostType: .mostviewed)
        GetStudentLessons(mostType: .mostBooked)
        
        DispatchGroup.enter()
        GetStudentMostSubjects(mostType: .mostviewed)
        GetStudentMostSubjects(mostType: .mostBooked)
        
        DispatchGroup.enter()
        GetStudentTeachers(mostType: .mostviewed)
        GetStudentTeachers(mostType: .topRated)
        GetStudentMostBookedTeachers()
        DispatchGroup.leave()
        
        //    }
    }
    
    func clearselections(){
        SelectedStudentSubjects = HomeSubject()
        newSSelectedStudentSubjects = StudentMostViewedSubjectsM()
        SelectedStudentMostViewedLesson = StudentMostViewedLessonsM()
        SelectedStudentMostBookedLesson = StudentMostViewedLessonsM()
        SelectedStudentMostViewedSubject = StudentMostViewedSubjectsM()
        SelectedStudentMostBookedSubject = StudentMostViewedSubjectsM()
        SelectedStudentMostViewedTeachers = StudentMostViewedTeachersM()
        SelectedStudentMostRatedTeachers = StudentMostViewedTeachersM()
        SelectedStudentMostBookedTeachers = StudentMostViewedTeachersM()
    }
    func clearsearch(){
        educationType = nil
//        term = nil
        isacademicYearvalid = true
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}


extension Array where Element == GetAllSubject {
    func convertToStudentSubjects() -> [HomeSubject] {
        return self.map { getAllSubject in
            return HomeSubject(
                id: getAllSubject.id,
                name: getAllSubject.name,
                image: getAllSubject.image
            )
        }
    }
}

extension Array where Element == GetAllSubject {
    func newconvertToStudentSubjects() -> [StudentMostViewedSubjectsM] {
        return self.map { getAllSubject in
            return StudentMostViewedSubjectsM(
                id: getAllSubject.id,
                subjectName: getAllSubject.name,
                image: getAllSubject.image
                //                ,
                ,lessonsCount:getAllSubject.lessonsCount
                ,teacherCount:getAllSubject.availableTeacherCount
            )
        }
    }
}


// ----- Async Await api calls -----
//extension StudentHomeVM{
//
//    func GetStudentSubjects1() async {
//        var parameters:[String:Any] = [:]
//        print("parameters",parameters) // id
//        if Helper.shared.CheckIfLoggedIn() == true && !(Helper.shared.getSelectedUserType() == .Teacher){
//            if Helper.shared.getSelectedUserType() == .Parent{
//                parameters["id"] = Helper.shared.selectedchild?.id ?? 0
//            }
//            let target = StudentServices.GetStudentSubjects(parameters: parameters)
//            print(parameters)
//            
//            isLoading = true
//            //            error = nil
//            do{
//                let response = try await BaseNetwork.shared.request(target, BaseResponse<StudentSubjectsM>.self)
//                print(response)
//                
//                self.isLoading = false
//                if response.success == true {
//                    StudentSubjectsM = response.data
//                    
//                    //                                     self.loginSuccess = true
//                } else {
//                    self.error = .error(image:nil, message: "\(response.message)",buttonTitle:"Done")
//                    self.isError = true
//                }
//                
//            } catch let error as NetworkError {
//                self.isLoading = false
//                self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                self.isError = true
////                print("Network error: \(error.errorDescription)")
//            } catch {
//                self.isLoading = false
//                self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                self.isError = true
////                print("Unexpected error: \(error.localizedDescription)")
//            }
//        }else{
//            
//            parameters["maxResultCount"] = 25
//            parameters["skipCount"] = 0
//            if let educationLevelid = academicYear?.id {
//                parameters["academicEducationLevelId"] = educationLevelid
//            }
//            if let termid = term?.id{
//                parameters["semesterId"] = termid
//            }
//            
//            let target = StudentServices.GetStudentSubjects(parameters: parameters)
//            print(parameters)
//            
//            isLoading = true
//            //            error = nil
//            do{
//                let response = try await BaseNetwork.shared.request(target, BaseResponse<AnonymousallSubjectM>.self)
//                print(response)
//                
//                self.isLoading = false
//                if response.success == true {
//                    guard let subjects = response.data?.getAllSubjects else {return}
//                    //                        StudentSubjects = subjects.convertToStudentSubjects()
//                    
//                    newStudentSubjects = subjects.newconvertToStudentSubjects()
//
//                    //                                     self.loginSuccess = true
//                } else {
//                    self.error = .error(image:nil, message: "\(response.message)",buttonTitle:"Done")
//                    self.isError = true
//                }
//                
//            } catch let error as NetworkError {
//                self.isLoading = false
//                self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                self.isError = true
////                print("Network error: \(error.errorDescription)")
//            } catch {
//                self.isLoading = false
//                self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                self.isError = true
////                print("Unexpected error: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func GetStudentMostSubjects1(mostType:studentLessonMostCases) async {
//        var parameters:[String:Any] = [:]
//        if let academicLevelId = academicLevelId{
//            parameters["academicLevelId"] = academicLevelId
//        }else if let educationLevelid = academicYear?.id{
//            parameters["academicLevelId"] = educationLevelid
//        }
//        print("parameters",parameters)
//        
//        let target = StudentServices.GetMostSubjects(mostType: mostType, parameters: parameters)
//            print(parameters)
//            
//            isLoading = true
//            //            error = nil
//            do{
//                let response = try await BaseNetwork.shared.request(target, BaseResponse<[StudentMostViewedSubjectsM]>.self)
//                print(response)
//                
//                self.isLoading = false
//                if response.success == true {
//                    switch mostType {
//                    case .mostviewed:
//                        StudentMostViewedSubjects = response.data ?? []
//                    case .mostBooked:
//                        StudentMostBookedsubjects = response.data ?? []
//                    }
//                    
//                    //                                     self.loginSuccess = true
//                } else {
//                    self.error = .error(image:nil, message: "\(response.message)",buttonTitle:"Done")
//                    self.isError = true
//                }
//                
//            } catch let error as NetworkError {
//                self.isLoading = false
//                self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                self.isError = true
////                print("Network error: \(error.errorDescription)")
//            } catch {
//                self.isLoading = false
//                self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                self.isError = true
////                print("Unexpected error: \(error.localizedDescription)")
//            }
//        
//    }
//}
