//
//  LookUpsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Combine

class LookUpsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var GendersArray: [GendersM] = []{
        didSet{
            if !GendersArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                GendersList = GendersArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
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
            }
        }
    }
    @Published var SelectedCountry: DropDownOption?

    @Published var GovernoratesArray: [GovernorateM] = []{
        didSet{
            if !GovernoratesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                GovernoratesList = GovernoratesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
            }
        }
    }
    @Published var SelectedGovernorate: DropDownOption?

    @Published var CitiesArray: [CityM] = []{
        didSet{
            if !CitiesArray.isEmpty {
                // Use map to transform GendersM into DropDownOption
                CitiesList = CitiesArray.map { gender in
                    return DropDownOption(id: gender.id, Title: gender.name)
                }
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
            // Use map to transform GendersM into DropDownOption
            EducationTypesList = EducationTypesArray.map { gender in
                return DropDownOption(id: gender.id, Title: gender.name)
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
            // Use map to transform GendersM into DropDownOption
            EducationLevelsList = EducationLevelsArray.map { gender in
                return DropDownOption(id: gender.id, Title: gender.name)
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
            // Use map to transform GendersM into DropDownOption
            AcademicYearsList = AcademicYearsArray.map { gender in
                return DropDownOption(id: gender.id, Title: gender.name)
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

    @Published var SubjectsArray: [GendersM] = []{
        didSet{
            // Use map to transform GendersM into DropDownOption
            SubjectsList = SubjectsArray.map { gender in
                return DropDownOption(id: gender.id, Title: gender.name)
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

    @Published private var error: Error?
 
    init()  {
//        Task{
            getGendersArr()
            getCountriesArr()
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
                SubjectsArray = receivedData.data ?? []
            })
            .store(in: &cancellables)
    }
}


