//
//  LookUpsVM.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Foundation

import Combine

class LookUpsVM: ObservableObject {
//    static var shared = LookUpsVM()

    @Published var GendersArray: [GendersM] = []
        
    //    let passthroughSubject = PassthroughSubject<String, Error>()
    //    let passthroughModelSubject = PassthroughSubject<BaseResponse<[TruckTypeModel]>, Error>()
    //    private let authServices = MoyaProvider<AuthServices>()
    //    private var cancellables: Set<AnyCancellable> = []
    //
    //    // ------- input
    //    //------- output
    //    @Published var publishedTypesArray: [TruckTypeModel] = []
    //    @Published var isLogedin = false
    //
    //    @Published var isLoading:Bool? = false
    //    @Published var isAlert = false
    //    @Published var activeAlert: ActiveAlert = .NetworkError
    //    @Published var message = ""
    
    init() {
        Task{
            do{
                try await GetGenders()
                //        passthroughModelSubject.sink { (completion) in
                //        } receiveValue: { [weak self](modeldata) in
                //            DispatchQueue.main.async {
                //            self?.publishedTypesArray = modeldata.data ?? []
                //            }
                //        }.store(in: &cancellables)
                print(GendersArray)
            }catch{
                print(error)
                throw error
            }
        }
    }
    
}
 
extension LookUpsVM{
    // MARK: - API Services
    func GetGenders()async throws{
        do {
            GendersArray = try await asyncGetGenders()
//            newestTipsArr = try await GetNewestTips()
//            interestingTipsArr = try await GetInterestingTips()
//            mostViewedTipsArr = try await GetMostViewedTips()
        } catch {
            throw error
        }
    }
    
    
    func asyncGetGenders() async throws -> [GendersM]  {
        let target = LookupsServices.GetGenders
        print("target :",target)
            do {
                 let result = try await BaseNetwork.asyncCallApi(target, BaseResponse<[GendersM]>.self)
//                print("result.data",result.data ?? [])
                return result.data ?? []
            } catch {
                throw error
            }
    }

}
