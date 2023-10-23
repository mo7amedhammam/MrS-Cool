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
   
    @Published var GendersList : [DropDownOption] = []
//    @Published var selectedGender = DropDownOption()
    @Published private var error: Error?
 
    init()  {
        getGendersArr()
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
                fillDropDownOptions()
            })
            .store(in: &cancellables)
    }
    
    func fillDropDownOptions() {
        // Use map to transform GendersM into DropDownOption
        GendersList = GendersArray.map { gender in
            return DropDownOption(id: gender.id, Title: gender.name)
        }
    }
}




