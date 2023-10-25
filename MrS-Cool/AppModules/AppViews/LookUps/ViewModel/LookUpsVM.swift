//
//  LookUpsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Combine

class LookUpsVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published var GendersArray: [GendersM] = []
    @Published var CountriesArray: [GendersM] = []
    @Published var SelectedCountry: DropDownOption?

    @Published var GovernoratesArray: [GovernorateM] = []
    @Published var SelectedGovernorate: DropDownOption?

    @Published var CitiesArray: [CityM] = []
    @Published var SelectedCity: DropDownOption?

    @Published var GendersList : [DropDownOption] = []
    @Published var CountriesList : [DropDownOption] = []
    @Published var GovernoratesList: [DropDownOption] = []
    @Published var CitiesList: [DropDownOption] = []

    //    @Published var selectedGender = DropDownOption()
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
                fillGendersList()
            })
            .store(in: &cancellables)
    }
    func fillGendersList() {
        // Use map to transform GendersM into DropDownOption
        GendersList = GendersArray.map { gender in
            return DropDownOption(id: gender.id, Title: gender.name)
        }
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
                fillCountriesList()
            })
            .store(in: &cancellables)
    }
    
    func fillCountriesList() {
        // Use map to transform GendersM into DropDownOption
        CountriesList = CountriesArray.map { gender in
            return DropDownOption(id: gender.id, Title: gender.name)
        }
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
                fillGovernoratesList()
            })
            .store(in: &cancellables)
    }
    
    func fillGovernoratesList() {
        // Use map to transform GendersM into DropDownOption
        GovernoratesList = GovernoratesArray.map { gender in
            return DropDownOption(id: gender.id, Title: gender.name)
        }
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
                fillCitiesList()
            })
            .store(in: &cancellables)
    }
    
    func fillCitiesList() {
        // Use map to transform GendersM into DropDownOption
        CitiesList = CitiesArray.map { gender in
            return DropDownOption(id: gender.id, Title: gender.name)
        }
    }

}




