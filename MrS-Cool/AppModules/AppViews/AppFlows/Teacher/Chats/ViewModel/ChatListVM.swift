//
//  ChatListVM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//

import Foundation
import Combine

class ChatListVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---    
    @Published var selectedChatId : Int?

//    @Published var filtersubject : DropDownOption?
//    @Published var filterlesson : DropDownOption?
//    @Published var filtergroupName : String = ""
    @Published var comment : String=""
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
    @Published var ChatsList : [ChatListM]?
    @Published var ChatDetails : ChatDetailsM?

//    @Published var StudentChatsList : [StudentChatListM]?
//    @Published var StudentChatDetails : StudentChatDetailsM?

    init(){
    }
}

extension ChatListVM{
    
    func GetChatsList(){
//        isLoading = false
        let target = teacherServices.GetAllComentsList
        isLoading = true
        if Helper.shared.getSelectedUserType() == .Teacher {
            BaseNetwork.CallApi(target, BaseResponse<[ChatListM]>.self)
                .receive(on: DispatchQueue.main)
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
                        ChatsList = receivedData.data
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
            
        }else if Helper.shared.getSelectedUserType() == .Student{
            BaseNetwork.CallApi(target, BaseResponse<[StudentChatListM]>.self)
                .receive(on: DispatchQueue.main)
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
                        ChatsList = receivedData.data?.convertToChatList()
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)

        }
    }
    func GetChatComments(){
//        isLoading = false
        var parameters:[String:Any] = [:]
        if let chatid = selectedChatId{
            parameters["bookTeacherLessonSessionDetailId"] = chatid
        }
        print("parameters",parameters)
        let target = teacherServices.GetAllComentsListById(parameters: parameters)
        isLoading = true
        
        if Helper.shared.getSelectedUserType() == .Teacher{
            BaseNetwork.CallApi(target, BaseResponse<ChatDetailsM>.self)
                .receive(on: DispatchQueue.main)
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
                        ChatDetails = receivedData.data
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
        }else if Helper.shared.getSelectedUserType() == .Student{
            BaseNetwork.CallApi(target, BaseResponse<StudentChatDetailsM>.self)
                .receive(on: DispatchQueue.main)
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
                        ChatDetails = receivedData.data?.convertToChatDetails()
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoading = false
                })
                .store(in: &cancellables)
        }
    }
    func CreateChatComment(){
//        isLoading = false
        let parameters:[String:Any] = ["bookTeacherLessonSessionDetailId" : selectedChatId ?? 0,"comment":comment ]
        print("parameters",parameters)
        let target = teacherServices.CreateComment(parameters: parameters)
        isLoading = true
        BaseNetwork.CallApi(target, BaseResponse<ChatDetailsM>.self)
            .receive(on: DispatchQueue.main)
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
                    ChatDetails = receivedData.data
                }else{
                    isError =  true
                    //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                    error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                }
                isLoading = false
            })
            .store(in: &cancellables)
    }
    
//    func cleanup() {
//        isLoading = false
//        // Cancel any ongoing Combine subscriptions
//        cancellables.forEach { cancellable in
//            cancellable.cancel()
//        }
//        cancellables.removeAll()
//    }
}

extension Array where Element == StudentChatListM {
    func convertToChatList() -> [ChatListM] {
        return self.map { studentChat in
            return ChatListM(studentName: studentChat.teacherName,
                             studentImage: studentChat.teacherImage,
                             lessonNum: studentChat.lessonNum,
                             teacherLessonSessionsDtos: studentChat.teacherLessonSessionsDtos)
        }
    }
}

extension StudentChatDetailsM {
    func convertToChatDetails() -> ChatDetailsM {
        return ChatDetailsM(id: self.bookTeacherLessonSessionDetailID,
                            teacherName: self.teacherName,
                            studentName: self.studentName,
                            subjectName: self.subjectName,
                            comments: self.teacherLessonSessionCommentDetailsDtos?.map { commentDto in
                                return CommentDetailsDto(comment: commentDto.comment,
                                                         fromName: commentDto.fromName,
                                                         toName: commentDto.toName,
                                                         fromImage: commentDto.fromImage,
                                                         toImage: commentDto.toImage,
                                                         creationDate: commentDto.creationDate)
                            })
    }
}
