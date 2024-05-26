//
//  LookUpsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Combine
import CoreFoundation
import Foundation
import UIKit
import SwiftUI

class LookUpsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var GendersArray: [GendersM] = []{
        didSet{
            if !GendersArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                GendersList = GendersArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                GendersList.removeAll()
            }
        }
    }
    @Published var CountriesArray: [GendersM] = []{
        didSet{
            if !CountriesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                CountriesList = CountriesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                CountriesList.removeAll()
            }
        }
    }
    @Published var SelectedCountry: DropDownOption?{
        didSet{
            getGovernoratesArr()
            SelectedGovernorate = nil
        }
    }
    
    @Published var GovernoratesArray: [GovernorateM] = []{
        didSet{
            if !GovernoratesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                GovernoratesList = GovernoratesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                GovernoratesList.removeAll()
            }
        }
    }
    @Published var SelectedGovernorate: DropDownOption?{
        didSet{
            getCitiesArr()
            SelectedCity = nil
        }
    }
    
    @Published var CitiesArray: [CityM] = []{
        didSet{
            if !CitiesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                CitiesList = CitiesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                CitiesList.removeAll()
            }
        }
    }
    @Published var SelectedCity: DropDownOption?
    
    @Published var GendersList : [DropDownOption] = []
    @Published var CountriesList : [DropDownOption] = []
    @Published var GovernoratesList: [DropDownOption] = []
    @Published var CitiesList: [DropDownOption] = []
    
    @Published var EducationTypesArray: [EducationTypeM] = []{
        didSet{
            if !EducationTypesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                EducationTypesList = EducationTypesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                EducationTypesList.removeAll()
            }
        }
    }
    @Published var EducationTypesList: [DropDownOption] = []
    @Published var SelectedEducationType: DropDownOption?{
        didSet{
            GetEducationLevels()
            SelectedEducationLevel = nil
        }
    }
    
    @Published var EducationLevelsArray: [EducationLevellM] = []{
        didSet{
            if !EducationLevelsArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                EducationLevelsList = EducationLevelsArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                EducationLevelsList.removeAll()
            }
        }
    }
    @Published var EducationLevelsList: [DropDownOption] = []
    @Published var SelectedEducationLevel: DropDownOption?{
        didSet{
            if SelectedEducationLevel == nil {
                EducationLevelsList.removeAll()
                SelectedAcademicYear = nil
            }else{
                GetAcademicYears()
            }
        }
    }
    
    @Published var AcademicYearsArray: [GendersM] = []{
        didSet{
            if !AcademicYearsArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                AcademicYearsList = AcademicYearsArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                AcademicYearsList.removeAll()
            }
        }
    }
    @Published var AcademicYearsList: [DropDownOption] = []
    @Published var SelectedAcademicYear: DropDownOption?{
        didSet{
            if SelectedAcademicYear == nil {
                AcademicYearsList.removeAll()
                SelectedSubject = nil
            }else{
                GetSubjects()
            }
        }
    }
    
    @Published var SubjectsArray: [SubjectsByAcademicLevelM] = []{
        didSet{
            if !SubjectsArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                SubjectsList = SubjectsArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name,subject: gender)
                }
            }else{
                SubjectsList.removeAll()
            }
        }
    }
    @Published var SubjectsList: [DropDownOption] = []
    @Published var SelectedSubject: DropDownOption?{
        didSet{
            if SelectedSubject == nil{
                SubjectsList.removeAll()
            }
        }
    }

    @Published var StatusArray: [GendersM] = []{
        didSet{
            if !StatusArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                StatusList = StatusArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                StatusList.removeAll()
            }
        }
    }
    @Published var StatusList: [DropDownOption] = []
    @Published var SelectedStatus: DropDownOption?{
        didSet{
            if SelectedStatus == nil{
                StatusList.removeAll()
            }
        }
    }
    
    
    @Published var SemestersArray: [AcademicSemesterM] = []{
        didSet{
            if !SemestersArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                SemestersList = SemestersArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                SemestersList.removeAll()
            }
        }
    }
    @Published var SemestersList: [DropDownOption] = []
    
    
    @Published var documentTypesArray: [DocumentTypeM] = []{
        didSet{
            if !documentTypesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                documentTypesList = documentTypesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                documentTypesList.removeAll()
            }
        }
    }
    @Published var documentTypesList: [DropDownOption] = []
    
    @Published var materialTypesArray: [GendersM] = []{
        didSet{
            if !materialTypesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                materialTypesList = materialTypesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                materialTypesList.removeAll()
            }
        }
    }
    @Published var materialTypesList: [DropDownOption] = []
    
    @Published var daysArray: [GendersM] = []{
        didSet{
            if !daysArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                daysList = daysArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                daysList.removeAll()
            }
        }
    }
    @Published var daysList : [DropDownOption] = []
    
    @Published var SubjectsForListArray: [SubjectForListM] = []{
        didSet{
            if !SubjectsForListArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                SubjectsForList = SubjectsForListArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.subjectDisplayName)
                }
            }else{
                SubjectsForList.removeAll()
            }
        }
    }
    @Published var SubjectsForList: [DropDownOption] = []
    @Published var SelectedSubjectForList: DropDownOption?{
        didSet{
//            if SelectedSubjectForList == nil{
//                SubjectsForList.removeAll()
//            }else{
                GetLessonsForList()
//            }
        }
    }
    @Published var LessonsForListArray: [LessonForListM] = []{
        didSet{
            if !LessonsForListArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                LessonsForList = LessonsForListArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.lessonName,subTitle: gender.groupDuration)
                }
            }else{
                LessonsForList.removeAll()
            }
        }
    }
    @Published var LessonsForList: [DropDownOption] = []

    @Published var BookedSubjectsForListArray: [BookedStudentSubjectsM] = []{
        didSet{
            if !BookedSubjectsForListArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                BookedSubjectsForList = BookedSubjectsForListArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                BookedSubjectsForList.removeAll()
            }
        }
    }
    @Published var BookedSubjectsForList: [DropDownOption] = []
    @Published var SelectedBookedSubjectForList: DropDownOption?{
        didSet{
//            if SelectedSubjectForList == nil{
//                SubjectsForList.removeAll()
//            }else{
                GetBookedLessonsForList()
//            }
        }
    }
    @Published var BookedLessonsForListArray: [BookedStudentLessonsM] = []{
        didSet{
            if !BookedLessonsForListArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                BookedLessonsForList = BookedLessonsForListArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }else{
                BookedLessonsForList.removeAll()
            }
        }
    }
    @Published var BookedLessonsForList: [DropDownOption] = []

    
    @Published private var error: Error?
    
    init()  {
        //        Task{
        //            getGendersArr()
        //            getCountriesArr()
        //            getGovernoratesArr()
        //            getCitiesArr()
        //        }
    }
}


extension LookUpsVM{
    func getGendersArr(){
        let target = LookupsServices.GetGenders
        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                GendersArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func getCountriesArr(){
        let target = LookupsServices.GetCountries
        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                CountriesArray = receivedData.data ?? []
                //                fillCountriesList()
            })
            .store(in: &cancellables)
    }
    
    func getGovernoratesArr(){
        guard let countryId = SelectedCountry?.id else {return}
        let parameters = ["countryId":countryId]
        
        let target = LookupsServices.GetGovernorates(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[GovernorateM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                GovernoratesArray = receivedData.data ?? []
                //                fillGovernoratesList()
            })
            .store(in: &cancellables)
    }
    
    func getCitiesArr(){
        guard let GovernorateId = SelectedGovernorate?.id else {return}
        let parameters = ["GovernorateId":GovernorateId]
        
        let target = LookupsServices.GetCities(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[CityM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                CitiesArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
}

extension LookUpsVM {
    func GetEducationTypes() {
        let target = LookupsServices.GetEducationTypes
        BaseNetwork.CallApi(target, BaseResponse<[EducationTypeM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                EducationTypesArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetEducationLevels() {
        guard let educationTypeId = SelectedEducationType?.id else {return}
        let parameters = ["educationTypeId":educationTypeId]
        
        let target = LookupsServices.GetEducationLevels(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[EducationLevellM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                EducationLevelsArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetAcademicYears() {
        guard let educationLevelId = SelectedEducationLevel?.id else {return}
        let parameters = ["educationLevelId":educationLevelId]
        
        let target = LookupsServices.GetAcademicYears(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                AcademicYearsArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetSubjects() {
        guard let academicYearId = SelectedAcademicYear?.id else {return}
        let parameters = ["academicEducationLevelId":academicYearId]
        
        let target = LookupsServices.GetAllSubjects(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[SubjectsByAcademicLevelM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                SubjectsArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetStatus() {
        let target = LookupsServices.GetStatus
        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                StatusArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetSemesters() {
        let target = LookupsServices.GetSemesters
        BaseNetwork.CallApi(target, BaseResponse<[AcademicSemesterM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                SemestersArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
}



extension LookUpsVM{
    func GetDocumentTypes() {
        //        guard let academicYearId = SelectedAcademicYear?.id else {return}
        //        let parameters = ["academicEducationLevelId":academicYearId]
        
        let target = LookupsServices.GetDocumentTypes
        BaseNetwork.CallApi(target, BaseResponse<[DocumentTypeM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                documentTypesArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    func GetMaterialTypes() {
        //        guard let academicYearId = SelectedAcademicYear?.id else {return}
        //        let parameters = ["academicEducationLevelId":academicYearId]
        
        let target = LookupsServices.GetMaterialTypes
        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                materialTypesArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetDays() {
        let target = LookupsServices.GetDays
        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                daysArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetSubjestForList() {
        let target = LookupsServices.GetSubjectsForList
        BaseNetwork.CallApi(target, BaseResponse<[SubjectForListM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                SubjectsForListArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    func GetLessonsForList() {
        guard let SelectedSubjectForListid = SelectedSubjectForList?.id else {LessonsForListArray.removeAll(); return}
        let parameters:[String:Any] = ["teacherSubjectAcademicSemesterYearId":SelectedSubjectForListid]
        let target = LookupsServices.GetLessonsForList(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[LessonForListM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                LessonsForListArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    
    func GetBookedSubjestForList() {
        var parameters:[String:Any] = [:]
        if Helper.shared.getSelectedUserType() == .Parent{
//            guard let SelectedSubjectForListid = SelectedSubjectForList?.id else {return}
            parameters["StudentId"] = Helper.shared.selectedchild?.id
                       }
        
        let target = LookupsServices.GetBookedStudentSubjects(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[BookedStudentSubjectsM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                BookedSubjectsForListArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
    func GetBookedLessonsForList(){
        guard let SelectedSubjectForListid = SelectedBookedSubjectForList?.id else {return}
        var parameters:[String:Any] = ["SubjectId":SelectedSubjectForListid]
        if Helper.shared.getSelectedUserType() == .Parent{
            parameters["StudentId"] = Helper.shared.selectedchild?.id
                       }
        let target = LookupsServices.GetBookedStudentLessons(parameters: parameters)
        BaseNetwork.CallApi(target, BaseResponse<[BookedStudentLessonsM]>.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: {[weak self] receivedData in
                guard let self = self else{return}
                print("receivedData",receivedData)
                BookedLessonsForListArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
}


//MARK: -- keyboard --
final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    init() {
        keyboardWillShowNotification.map { notification in
            CGFloat((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
        }
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)

        keyboardWillHideNotification.map { _ in
            CGFloat(0)
        }
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)
    }

    private var cancellableSet: Set<AnyCancellable> = []
}

struct KeyboardAdaptive: ViewModifier {
    @ObservedObject private var keyboard = KeyboardResponder()

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboard.currentHeight)
            .animation(.easeOut(duration: 0.16))
    }
}
extension View {
    func keyboardAdaptive() -> some View {
        modifier(KeyboardAdaptive())
    }
}



// MARK: - SubjectsByAcademicLevel
struct SubjectsByAcademicLevelM: Codable,Hashable {
    static func == (lhs: SubjectsByAcademicLevelM, rhs: SubjectsByAcademicLevelM) -> Bool {
        return lhs.id == rhs.id
    }

    var id: Int?
    var name: String?
    var groupDurationFrom, groupDurationTo: Int?
    var individualCostFrom, individualCostTo, groupCostFrom, groupCostTo: Float?
}
