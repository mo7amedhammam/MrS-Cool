//
//  ManageSubjectGroupVM.swift
//  MrS-Cool
//
//  Created by wecancity on 07/12/2023.
//

import Foundation
import Combine

class ManageSubjectGroupVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    static let shared = ManageSubjectGroupVM()
    
    //    MARK: --- inputs ---
    @Published var subject : DropDownOption?{
        didSet{
            if subject != nil{
                issubjectvalid = true
                guard let SessionCost = subject?.subject?.groupSessionCost else {return}
                SessionPrice = String(SessionCost)
            }
        }
    }
    @Published var issubjectvalid:Bool?

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
    
    @Published var groupName : String = ""{
        didSet{
            isgroupNamevalid = groupName.isEmpty ? false:true
        }
    }
    @Published var isgroupNamevalid:Bool?
    
    @Published var startDate : String?{
        didSet{
            isstartDatevalid = startDate == nil ? false:true
        }
    }
    @Published var isstartDatevalid:Bool?

    //    @Published var endDate : String?
    
    @Published var filtersubject : DropDownOption?
    @Published var filtergroupName : String = ""
    @Published var filterstartdate : String?
    @Published var filterenddate : String?
    
    @Published var day : DropDownOption?
    @Published var startTime : String?
    //    @Published var endTime : String?
    
    //Extra session
    @Published var ShowAddExtraSession = false
     var selectedGroup : SubjectGroupM?
    var teachersubjectAcademicSemesterYearID: Int?
    @Published var extraLesson : DropDownOption?{
        didSet{
            if extraLesson != nil{
                isextraLessonvalid = true
            }
        }
    }
    @Published var isextraLessonvalid:Bool?

    @Published var extraDate : String?{
        didSet{
            if extraDate != nil {
                isextraDatevalid = true
            }
        }
    }
    @Published var isextraDatevalid:Bool?
    
    @Published var extraTime : String?{
        didSet{
            if extraTime != nil{
                isextraTimevalid = true
            }
        }
    }
    @Published var isextraTimevalid:Bool?
    
    @Published var DisplaySchedualSlotsArr:[NewScheduleSlotsM] = []
    
    @Published var CreateSchedualSlotsArr = []
    
    @Published var AllLessonsForList: [DropDownOption] = []
    @Published var teacherLessonList : [LessonForListM] = []
    @Published var CreateTeacherLessonList = []

    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    @Published var showConfirmDelete : Bool = false

    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    @Published var letsPreview : Bool = false

    @Published var TeacherSubjectGroups : [SubjectGroupM]?
    @Published var TeacherSubjectGroupsDetails : SubjectGroupDetailsM? = nil{
        didSet{
            if TeacherSubjectGroupsDetails != nil{
                letsPreview = true
//                TeacherSubjectGroupsDetails?.startDate =  TeacherSubjectGroupsDetails?.startDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy")
//                TeacherSubjectGroupsDetails?.endDate =  TeacherSubjectGroupsDetails?.endDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy")
            }
        }
    }
    @Published var TeacherSubjectGroupCreated : Bool = false
    
    init()  {
//        GetTeacherSubjectGroups()
    }
}

extension ManageSubjectGroupVM{
//    func GetTeacherSubjectGroups(){
//        var parameters:[String:Any] = [:]
//        if let filtersubjectid = filtersubject?.id{
//            parameters["teacherSubjectAcademicSemesterYearId"] = filtersubjectid
//        }
//        if filtergroupName.count > 0{
//            parameters["groupName"] = filtergroupName
//        }
//        
//        if let filterstartdate = filterstartdate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
//            parameters["startDate"] = filterstartdate
//        }
//        if let filterenddate = filterenddate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
//            parameters["endDate"] = filterenddate
//        }
//        
//        print("parameters",parameters)
//        let target = teacherServices.GetMySubjectGroup(parameters: parameters)
//        isLoading = true
//        BaseNetwork.CallApi(target, BaseResponse<[SubjectGroupM]>.self)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: {[weak self] completion in
//                guard let self = self else{return}
//                isLoading = false
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                    isError =  true
//                }
//            },receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                if receivedData.success == true {
//                    //                    TeacherSubjects?.append(model)
//                    TeacherSubjectGroups = receivedData.data
//                }else{
//                    isError =  true
//                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                }
//                isLoading = false
//            })
//            .store(in: &cancellables)
//    }
    
    @MainActor
    func fetchSubjectGroups() async {
           isLoading = true // Start the loading animation
           await GetTeacherSubjectGroups1()
           isLoading = false // Stop the loading animation
       }
    
    
    @MainActor
    func GetTeacherSubjectGroups1() async{
        var parameters:[String:Any] = [:]
        if let filtersubjectid = filtersubject?.id{
            parameters["teacherSubjectAcademicSemesterYearId"] = filtersubjectid
        }
        if filtergroupName.count > 0{
            parameters["groupName"] = filtergroupName
        }
        
        if let filterstartdate = filterstartdate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["startDate"] = filterstartdate
        }
        if let filterenddate = filterenddate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["endDate"] = filterenddate
        }
        
        let target = teacherServices.GetMySubjectGroup(parameters: parameters)

//                isLoadingComments = true
                do{
                    let response = try await BaseNetwork.shared.request(target, BaseResponse<[SubjectGroupM]>.self)
                    print(response)
    
                    if response.success == true {
                        TeacherSubjectGroups = response.data
                    } else {
                        self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                        self.isError = true
                    }
    } catch {
//                        self.isLoadingComments = false
                    self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                    self.isError = true
    //                print("Unexpected error: \(error.localizedDescription)")
                }
           
        }
    
    func ReviewTeacherGroup(){
        // Calculate the sum of counts for selected lessons
           let totalCount = teacherLessonList.reduce(0) { partialResult, lessonItem in
               partialResult + (lessonItem.count ?? 0) // Use optional chaining in case count is nil
           }
        let totalCost = Float(totalCount)*(Float(SessionPrice) ?? 0)
        print("totalCount",totalCount)
        print("totalprice",Float(totalCount)*(Float(SessionPrice) ?? 0))

        guard checkValidfields() else {return}
        guard let subjectid = subject?.id ,let subjectname = subject?.Title ,let startdate = startDate else {return}
        prepareSlotsArrays()
        prepareLessonsForList()
        let parameters:[String:Any] = [ "teacherSubjectAcademicSemesterYearId":subjectid,
                                        "teacherSubjectAcademicSemesterYearName":subjectname,
                                        "groupName":groupName,
                                        "groupCost":totalCost,
                                        "startDate":startdate.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")),
                                        "scheduleSlots":CreateSchedualSlotsArr,
                                        "teacherLessonList":CreateTeacherLessonList]
        print("parameters",parameters)
        let target = teacherServices.ReviewMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDetailsM>.self)
            .receive(on: DispatchQueue.main)
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
                    TeacherSubjectGroupsDetails = receivedData.data ?? nil
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func CreateTeacherGroup(){
        TeacherSubjectGroupCreated = false
        guard let TeacherSubjectGroupsDetailsParameters = TeacherSubjectGroupsDetails?.toDictionary() else {return}
        let parameters:[String:Any] = TeacherSubjectGroupsDetailsParameters
        print("parameters",parameters)
        let target = teacherServices.CreateMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDetailsM>.self)
            .receive(on: DispatchQueue.main)
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
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        clearTeacherGroup()
                        clearFilter()
                        TeacherSubjectGroupCreated = true
                        Task{
                            await self.fetchSubjectGroups()
                        }
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
    
    func GetTeacherGroupDetails(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.GetMySubjectGroupDetails(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDetailsM>.self)
            .receive(on: DispatchQueue.main)
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
                if receivedData.success == true{
                    TeacherSubjectGroupsDetails = receivedData.data
                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteTeacherGroup(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.DeleteMySubjectGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDeleteM>.self)
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
                if receivedData.success == true{
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        TeacherSubjectGroups?.removeAll(where: {$0.id == id})
                    })
                    isError =  true

                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func CreateExtraSession(){
        guard checkValidExtraSessionfields() else {return}
        
        guard let group = selectedGroup ,let teacherlessonsessionid = group.id ,let lessonlessonid = extraLesson?.LessonItem?.id,let duration = extraLesson?.LessonItem?.groupDuration,let extradate = extraDate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")),let extratime = extraTime?.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: .current) else {return}
        let parameters:[String:Any] = [
//            "teacherLessonSessionScheduleSlotId": 0,
            "teacherlessonsessionId": teacherlessonsessionid,
            "teacherLessonId": lessonlessonid,
            "duration":duration ,
            "date": extradate,
            "timeFrom":extratime ,
            "isCancel":false
        ]
//        if let teachersubjectAcademicSemesterYearID = teachersubjectAcademicSemesterYearID{
//            parameters["teacherLessonSessionScheduleSlotId"] = teachersubjectAcademicSemesterYearID
//        }

        print("parameters",parameters)
        let target = teacherServices.CreateExtraSession(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<SubjectGroupDeleteM>.self)
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
                ShowAddExtraSession = false

                if receivedData.success == true{
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: {
//                        guard let self = self else {return}
//                        clearExtraSession()
                    })
                    isError =  true

                }else{
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    isError =  true
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }

    
    
    // Map DisplaySchedualSlotsArr to CreateSchedualSlotsArr
    func prepareSlotsArrays() {
        CreateSchedualSlotsArr = DisplaySchedualSlotsArr.map{ newSlot in
            return newSlot.toDictionary()
//           return ["dayId" : newSlot.day?.id ?? 0, "fromTime": newSlot.fromTime ?? ""]
        }
    }
    func prepareLessonsForList() {
        CreateTeacherLessonList = teacherLessonList.map{ newSlot in
            return newSlot.toDictionary()
        }
    }
    func clearCurrentSlot(){
        day = nil
        startTime = nil
        //        endTime = nil
    }
    func deleteFromDisplaySchedualSlot(at index: Int) {
           guard index >= 0 && index < DisplaySchedualSlotsArr.count else {
               // Handle invalid index
               return
           }
           DisplaySchedualSlotsArr.remove(at: index)
       }
    
    func clearTeacherGroup(){
        subject = nil
        groupName = ""
        startDate = nil
        AllLessonsForList.removeAll()
        DisplaySchedualSlotsArr.removeAll()
        CreateSchedualSlotsArr.removeAll()
        clearCurrentSlot()
    }
    func clearFilter(){
        filtersubject = nil
        filtergroupName = ""
        filterstartdate = nil
        filterenddate = nil
    }
    
    func clearExtraSession(){
        extraLesson = nil
        extraDate = nil
        extraTime = nil
        selectedGroup = nil
    }
    
    func cleanup() {
        // Cancel any ongoing Combine subscriptions
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }
    
    private func checkValidfields()->Bool{
        issubjectvalid = subject != nil
        isgroupNamevalid = !groupName.isEmpty
        isstartDatevalid = startDate != nil

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
//        isgroupCostvalid = !groupCost.isEmpty && Int(groupCost) != 0
//        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
        
        return issubjectvalid ?? true && isgroupNamevalid ?? true && isstartDatevalid ?? true && isSessionPricevalid ?? true
    }
    
    private func checkValidExtraSessionfields()->Bool{
        isextraLessonvalid = extraLesson != nil
        isextraDatevalid = extraDate != nil
        isextraTimevalid = extraTime != nil

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
//        isgroupCostvalid = !groupCost.isEmpty && Int(groupCost) != 0
//        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
        
        return isextraLessonvalid ?? true && isextraDatevalid ?? true && isextraTimevalid ?? true
    }

}




