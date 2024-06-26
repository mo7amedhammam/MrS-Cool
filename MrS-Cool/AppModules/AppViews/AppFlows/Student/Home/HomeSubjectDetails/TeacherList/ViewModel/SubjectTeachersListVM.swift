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
    case PriceLowToHigh = "Price Low To High"
    case PriceHighToLow = "Price High To Low"
}
enum teachersGenders:String{
    case Male, Female
}

class SubjectTeachersListVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var skipCount = 0

    @Published var subjectId : Int?
    @Published var lessonId : Int?
    @Published var rate : Int = 0
    @Published var priceFrom : String = ""
    @Published var priceTo : String = ""
    
    @Published var genderCase : teachersGenders?{
        didSet{
            switch genderCase {
            case .Male:
                genderId = 1
            case .Female:
                genderId = 2
            case nil:
                genderId = nil
            }
        }
    }
    @Published var genderId : Int?
    @Published var teacherName : String = ""

    @Published var sortCase : teachersSortCases? = .MostBooked{
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
    
    @Published var SubjectOrLessonDto : GetSubjectOrLessonDto?
    @Published var TeachersModel:StudentHomeSubjectTeachersListM?{
        didSet{
            guard !(TeachersModel?.items?.isEmpty ?? false) else{return}
            SubjectOrLessonDto = TeachersModel?.items?.first?.getSubjectOrLessonDto
        }
    }
//    = StudentHomeSubjectTeachersListM()
//    @Published var SelectedStudentLesson : UnitLessonDtoList = UnitLessonDtoList.init()
  
    init()  {
        sortCase = .MostBooked
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
        if rate > 0 {
            parameters["rate"] = rate
        }
        if priceFrom.count > 0 {
            parameters["priceFrom"] = Float(priceFrom)
        }
        if priceTo.count > 0 {
            parameters["priceTo"] = Float(priceTo)
        }
        if let genderId = genderId{
            parameters["genderId"] = genderId
        }
        if teacherName.count > 0 {
            parameters["teacherName"] = teacherName
        }
        if let sortColumn = sortColumn {
            parameters["sortColumn"] = sortColumn
        }
        
        print("parameters",parameters)
        let target = StudentServices.GetSubjectOrLessonTeachers(parameters: parameters)
                isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<StudentHomeSubjectTeachersListM>.self)
            .receive(on: DispatchQueue.main) // Receive on the main thread if you want to update UI
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
                    if skipCount == 0{
                        TeachersModel = receivedData.data
                    }else{
                        TeachersModel?.items?.append(contentsOf: receivedData.data?.items ?? [])
                    }
//                    isFiltering = false
//                    isSorting = false
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                                isLoading = false
            })
            .store(in: &cancellables)
    }
  
    func clearFilter(){
        rate = 0
        priceFrom = ""
        priceTo = ""
        genderId = nil
        genderCase = nil
        teacherName = ""
    }
    func clearSort(){
        sortCase = .MostBooked
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}




