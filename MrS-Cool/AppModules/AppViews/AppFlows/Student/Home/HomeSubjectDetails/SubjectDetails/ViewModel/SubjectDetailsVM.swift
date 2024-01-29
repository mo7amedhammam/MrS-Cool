//
//  SubjectDetailsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 27/01/2024.
//

import Foundation
import Combine

class SubjectDetailsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var maxResultCount = 10
    @Published var skipCount = 0
    
//    @Published var subjectId : Int?
//    @Published var lessonId : Int?
//    @Published var rate : Int = 0
//    @Published var priceFrom : Int?
//    @Published var priceTo : Int?
    
//    @Published var genderCase : teachersGenders?{
//        didSet{
//            switch genderCase {
//            case .Male:
//                genderId = 1
//            case .Female:
//                genderId = 2
//            case nil:
//                genderId = nil
//            }
//        }
//    }
//    @Published var genderId : Int?
//    @Published var teacherName : String = ""
//    @Published var sortCase : teachersSortCases?{
//        didSet{
//            switch sortCase {
//            case .MostBooked:
//                sortColumn = "Booked"
//            case .TopRated:
//                sortColumn = "Rate"
//            case .PriceLowToHigh:
//                sortColumn = "PriceL"
//            case .PriceHighToLow:
//                sortColumn = "PriceH"
//            case nil:
//                sortColumn = nil
//            }
//        }
//    }
    
//    @Published var sortColumn : String?
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    @Published var subjectDetails:TeacherSubjectDetailsM? 
//    = TeacherSubjectDetailsM.init()
    @Published var selectedSubjectGroup:Int? = 0

    //    @Published var SelectedStudentLesson : UnitLessonDtoList = UnitLessonDtoList.init()
    
    init()  {
        
    }
}

extension SubjectDetailsVM{
    func GetSubjectDetails(subjectId:Int){
        let parameters:[String:Any] = ["teacherSubjectId":subjectId]
        print("parameters",parameters)
        let target = StudentServices.GetSubjectGroupDetails(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<TeacherSubjectDetailsM>.self)
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
                        subjectDetails = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
//    func clearFilter(){
//        rate = 0
//        priceFrom = nil
//        priceTo = nil
//        genderId = nil
//        teacherName = ""
//    }
//    func clearSort(){
//        sortCase = nil
//    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
}




