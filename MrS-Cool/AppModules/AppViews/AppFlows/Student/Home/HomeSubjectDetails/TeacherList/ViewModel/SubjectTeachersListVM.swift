//
//  SubjectTeachersListVM.swift
//  MrS-Cool
//
//  Created by wecancity on 24/01/2024.
//

import Foundation
import Combine
enum teachersSortCases:String{
    case MostBooked = "Most Booked"
    case TopRated = "Top Rated"
    case PriceLowToHigh = "HL"
    case PriceHighToLow = "LH"
}

class SubjectTeachersListVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 0
    @Published var skipCount = 0

    @Published var subjectId : Int?
    @Published var lessonId : Int?
    @Published var rate : Int?
    @Published var priceFrom : Int?
    @Published var priceTo : Int?
    @Published var genderId : Int?
    @Published var teacherName : String?
    @Published var sortCase : teachersSortCases?{
        didSet{
            switch sortCase {
            case .MostBooked:
                sortColumn = "Booked"
            case .TopRated:
                sortColumn = "Rate"
            case .PriceLowToHigh:
                sortColumn = "PriceL"
            case .PriceHighToLow:
                sortColumn = "PriceH"
            case nil:
                sortColumn = nil
            }
        }
    }

    @Published var sortColumn : String?
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var TeachersModel:StudentHomeSubjectTeachersListM? = StudentHomeSubjectTeachersListM()
//    @Published var SelectedStudentLesson : UnitLessonDtoList = UnitLessonDtoList.init()
  
    init()  {

    }
}

extension SubjectTeachersListVM{
    
    func GetStudentSubjectTeachers(){
        
        var parameters:[String:Any] = ["maxResultCount":maxResultCount,"skipCount":skipCount]
            
        if let subjectId = subjectId{
            parameters["subjectId"] = subjectId
        }
         if let lessonId = lessonId{
            parameters["lessonId"] = lessonId
        }
        if let rate = rate{
            parameters["rate"] = rate
        }
        if let priceFrom = priceFrom{
            parameters["priceFrom"] = priceFrom
        }
        if let priceTo = priceTo{
            parameters["priceTo"] = priceTo
        }
        if let genderId = genderId{
            parameters["genderId"] = genderId
        }
        if let teacherName = teacherName{
            parameters["teacherName"] = teacherName
        }
        if let sortColumn = sortColumn{
            parameters["sortColumn"] = sortColumn
        }
        
        print("parameters",parameters)
        let target = StudentServices.GetSubjectOrLessonTeachers(parameters: parameters)
                isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<StudentHomeSubjectTeachersListM>.self)
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
                    TeachersModel = receivedData.data
                }else{
                                        isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                                isLoading = false
            })
            .store(in: &cancellables)
    }
  
    func clearselections(){
//        SelectedStudentSubjects = StudentSubjectsM()
//        SelectedStudentMostViewedLesson = StudentMostViewedLessonsM()
//        SelectedStudentMostBookedLesson = StudentMostViewedLessonsM()
//        SelectedStudentMostViewedSubject = StudentMostViewedSubjectsM()
//        SelectedStudentMostBookedSubject = StudentMostViewedSubjectsM()
//        SelectedStudentMostViewedTeachers = StudentMostViewedTeachersM()
//        SelectedStudentMostRatedTeachers = StudentMostViewedTeachersM()
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}




