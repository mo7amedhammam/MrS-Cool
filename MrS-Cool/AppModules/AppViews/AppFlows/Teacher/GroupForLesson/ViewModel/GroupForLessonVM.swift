//
//  GroupForLessonVM.swift
//  MrS-Cool
//
//  Created by wecancity on 02/12/2023.
//

import Foundation
import Combine

class GroupForLessonVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var subject : DropDownOption?{
        didSet{
            issubjectvalid = (subject == nil) ? false:true
            lesson = nil
        }
    }
    @Published var issubjectvalid:Bool?
    
    @Published var lesson : DropDownOption?{
        didSet{
            islessonvalid = (lesson == nil) ? false:true
            
            calculateendTime()
        }
    }
    @Published var islessonvalid:Bool?
    
    @Published var groupName : String = ""{
        didSet{
            isgroupNamevalid = (groupName.isEmpty) ? false:true
        }
    }
    @Published var isgroupNamevalid:Bool?
    
    @Published var date : String?{
        didSet{
            isdatevalid = (date == nil) ? false:true
        }
    }
    @Published var isdatevalid:Bool?
    
    @Published var time : String?{
        didSet{
            istimevalid = (time == nil) ? false:true
            calculateendTime()
        }
    }
    @Published var istimevalid:Bool?

    @Published var endTime : String?

    @Published var filtersubject : DropDownOption?{
        didSet{
            filterlesson = nil
        }
    }
    @Published var filterlesson : DropDownOption?
    @Published var filtergroupName : String = ""
    @Published var filterdate : String?
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    @Published var TeacherGroups : [GroupForLessonM]?
    
    init()  {
    }
}

extension GroupForLessonVM{
    func CreateTeacherGroup(){
        guard checkValidfields() else {return}
        guard let lessonid = lesson?.id,let date = date,let starttime = time,let endtime = endTime else {return}
        
        let Dto:[String:Any] = ["date":date.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")),
                                "timeFrom":starttime.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: .current),
                                "timeTo":endtime.ChangeDateFormat(FormatFrom: "hh:mm aa",FormatTo:"HH:mm",outputLocal: .english,inputTimeZone: .current)]
        let parameters:[String:Any] = [ "groupName":groupName,
                                        "teacherLessonId":lessonid,
                                        "teacherLessonSessionScheduleSlotsDto":[Dto]]
        print("parameters",parameters)
        let target = teacherServices.CreateMyLessonScheduleGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<GroupForLessonM>.self)
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
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        clearTeacherGroup()
                        clearFilter()
                        GetTeacherGroups()
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
    
    func GetTeacherGroups(){
        var parameters:[String:Any] = [:]
        if let filtersubjectid = filtersubject?.id{
            parameters["teacherSubjectAcademicSemesterYearId"] = filtersubjectid
        }
        if let filterlessonid = filterlesson?.id{
            parameters["teacherLessonId"] = filterlessonid
        }
        if filtergroupName.count > 0{
            parameters["groupName"] = filtergroupName
        }
        if let filterdate = filterdate?.ChangeDateFormat(FormatFrom: "dd MMM yyyy", FormatTo:"yyyy-MM-dd'T'HH:mm:ss",outputLocal: .english,inputTimeZone: TimeZone(identifier: "GMT")){
            parameters["startDate"] = filterdate
        }
//        if let time = time{
//            parameters["toEndDate"] = time
//        }
        
        print("parameters",parameters)
        let target = teacherServices.GetMyLessonSchedualGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<[GroupForLessonM]>.self)
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
                    TeacherGroups = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func DeleteTeacherGroup(id:Int?){
        guard let id = id else {return}
        let parameters:[String:Any] = ["id":id]
        
        print("parameters",parameters)
        let target = teacherServices.DeleteMyLessonScheduleGroup(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<GroupForLessonM>.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self = self else{return}
                isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    isError =  true
                    self.error = .error( message: "\(error.localizedDescription)",buttonTitle:"Done")
                }
            },receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                if receivedData.success == true{
                    error = .success( imgrendermode:.original, message: receivedData.message ?? "",buttonTitle:"Done",mainBtnAction: { [weak self] in
                        guard let self = self else {return}
                        TeacherGroups?.removeAll(where: {$0.id == id})
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
    
    func clearTeacherGroup(){
        subject = nil
        lesson = nil
        date = nil
        time = nil
        endTime = nil
        groupName = ""
    }
    func clearFilter(){
        guard filtersubject != nil || filterlesson != nil || filterdate != nil || filtergroupName != "" else {return}
        filtersubject = nil
        filterlesson = nil
        filterdate = nil
        filtergroupName = ""
        GetTeacherGroups()
        
    }
    //    func selectSubjectForEdit(item:TeacherSubjectM){
    //        isEditing = false
    //        editId = item.id ?? 0
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
    //        if let gcost = item.groupCost{
    //            groupCost = String(gcost)
    //        }
    //        if let indcost = item.individualCost{
    //            individualCost = String(indcost)
    //        }
    //        subjectBrief = item.teacherBrief ?? ""
    //        isEditing = true
    //    }
  func calculateendTime(){
        if time != nil && lesson != nil{

            endTime = time?.toDate(withFormat: "hh:mm aa",inputTimeZone: .current, inputLocal: .english, outputLocal: .english)?.adding(minutes: lesson?.subTitle ?? 0).formatDate(format: "hh:mm aa",inputLocal: .english,outputLocal: .current) ?? ""
        }else{
            endTime = nil
        }
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
        islessonvalid = lesson != nil
        isdatevalid = date != nil
        istimevalid = time != nil
        isgroupNamevalid = !groupName.isEmpty

        // Publisher for checking if the phone is 11 char
//        var isPhoneValidPublisher: AnyPublisher<Bool, Never> {
//            $phone
//                .map { phone in
//                    return phone.count == 11
//                }
//                .eraseToAnyPublisher()
//        }
//        isstartDatevalid = ((startDate?.isEmpty) == nil)
//        isendDatevalid = !endDate.isEmpty
//        isgroupCostvalid = !groupCost.isEmpty && Int(groupCost) != 0
//        isindividualCostvalid = !individualCost.isEmpty && Int(individualCost) != 0
//        isgroupTimevalid = !groupTime.isEmpty && Int(groupTime) != 0
//        isindividualTimevalid = !individualTime.isEmpty && Int(individualTime) != 0

        return issubjectvalid ?? true && islessonvalid ?? true && isdatevalid ?? true && istimevalid ?? true && isgroupNamevalid ?? true
    }
}




