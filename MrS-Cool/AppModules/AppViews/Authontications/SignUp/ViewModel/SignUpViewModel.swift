//
//  SignUpViewModel.swift
//  MrS-Cool
//
//  Created by wecancity on 23/10/2023.
//

import Combine
import Foundation

class SignUpViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var isUserChangagble = true // available unless teacher save personal data

//    MARK: --- inputs ---
    //Common data (note: same exact data for parent)
    @Published var selecteduser = UserType()
    @Published var name = ""
    @Published var phone = ""
    @Published var Password = ""
    @Published var selectedGender : DropDownOption?
    @Published var confirmPassword = ""
    @Published var acceptTerms = false

    //Student data
    @Published var birthDate : Date?
    // next 4  common with teacher subjects
    @Published var birthDateStr = ""
    @Published var educationType : DropDownOption?
    @Published var educationLevel : DropDownOption?
    @Published var academicYear : DropDownOption?
    
    //Teacher personal data
    @Published var isTeacher : Bool?
    @Published var country : DropDownOption?
    @Published var governorte : DropDownOption?
    @Published var city : DropDownOption?
    @Published var bio = ""

    //Teacher subjects data (have 4 common with student)
    @Published var subject : DropDownOption?

    //Teacher documents data
    @Published var documentType : DropDownOption?
    @Published var documentTitle : DropDownOption?
    @Published var documentOrder : String?

//    MARK: --- outpust ---
    @Published private var error: Error?
 
    init()  {
//        getGendersArr()
    }
    
}

extension SignUpViewModel{
//    func getGendersArr(){
//        let target = LookupsServices.GetGenders
//        BaseNetwork.CallApi(target, BaseResponse<[GendersM]>.self)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.error = error
//                }
//            }, receiveValue: {[weak self] receivedData in
//                guard let self = self else{return}
//                print("receivedData",receivedData)
//                GendersArray = receivedData.data ?? []
//                fillDropDownOptions()
//            })
//            .store(in: &cancellables)
//    }
    
//    func fillDropDownOptions() {
//        // Use map to transform GendersM into DropDownOption
//        GendersList = GendersArray.map { gender in
//            return DropDownOption(id: gender.id, Title: gender.name)
//        }
//    }
    
    
    
    func clearSelections(){
        name = ""
        phone = ""
        selectedGender = nil
        Password = ""
        confirmPassword = ""
        acceptTerms = false
        
        birthDate = nil
        birthDateStr = ""
    }
    
    func clearTeachersSubject(){
        educationType = nil
        educationLevel = nil
        academicYear = nil
        subject = nil
    }

    func clearTeachersDocument(){
        documentType = nil
        documentTitle = nil
        documentOrder = nil
    }

}




