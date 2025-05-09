    //
    //  ChatListVM.swift
    //  MrS-Cool
    //
    //  Created by wecancity on 26/12/2023.
    //

    import Foundation
    import Combine

@MainActor
    class ChatListVM: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []
        private var currentTasks: [Task<Void, Never>] = []

        //    MARK: --- inputs ---    
        @Published var selectedChatId : Int?

    //    @Published var filtersubject : DropDownOption?
    //    @Published var filterlesson : DropDownOption?
    //    @Published var filtergroupName : String = ""
        @Published var comment : String = ""
        
        //    MARK: --- outpust ---
        @Published var isLoading : Bool?
        @Published var isLoadingComments : Bool?
        @Published var isError : Bool = false
        //    @Published var error: Error?
        @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
        
        //    @Published var isTeacherHasSubjects: Bool = false
        @Published var ChatsList : [ChatListM]?
        @Published var ChatDetails : StudentChatDetailsM?

    //    @Published var StudentChatsList : [StudentChatListM]?
    //    @Published var StudentChatDetails : StudentChatDetailsM?

        init(){
        }
        func cleanup(){
            isLoading = false
            isLoadingComments = false
            cancelAllRequests()
            cancellables.forEach{ $0.cancel()}
            cancellables.removeAll()
        }
        func cancelAllRequests() {
            currentTasks.forEach { $0.cancel() }
            currentTasks.removeAll()
            BaseNetwork.shared.cancelAllRequests()
        }
    }

    extension ChatListVM{
        
        func GetChatsList(){
    //        isLoading = false
            var parameters:[String:Any] = [:]
            if Helper.shared.getSelectedUserType() == .Parent {
                parameters["studentId"] = Helper.shared.selectedchild?.id
            }
            print("parameters",parameters)
            let target = teacherServices.GetAllComentsList(parameters: parameters)
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
            }else {
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
        
        
        
        func GetChatsList1() async{
                 isLoading = true
            // Cancel any previous tasks
             if !currentTasks.isEmpty {
                 currentTasks.forEach { $0.cancel() }
                 currentTasks.removeAll()
             }
            
            let task = Task {

            var parameters:[String:Any] = [:]
            if Helper.shared.getSelectedUserType() == .Parent {
                parameters["studentId"] = Helper.shared.selectedchild?.id
            }
//                try Task.checkCancellation()

            let target = teacherServices.GetAllComentsList(parameters: parameters)

            if Helper.shared.getSelectedUserType() == .Teacher{
        
//                isLoadingComments = true
                    do{
                        let response = try await BaseNetwork.shared.request(target, BaseResponse<[ChatListM]>.self)
                        print(response)
                        try Task.checkCancellation()

                        if response.success == true {
                            ChatsList = response.data
                        } else {
                            self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                            self.isError = true
                        }
//                        self.isLoadingComments = false

//                    } catch let error as NetworkError {
//                        self.isLoadingComments = false
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        self.isError = true
//        //                print("Network error: \(error.errorDescription)")
                    } catch {
//                        self.isLoadingComments = false
                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                        self.isError = true
        //                print("Unexpected error: \(error.localizedDescription)")
                    }
                
                }else{
    
//                    isLoadingComments = true
                    //            error = nil
                    do{
                        let response = try await BaseNetwork.shared.request(target, BaseResponse<[StudentChatListM]>.self)
                        print("response in VM : ",response)
                        try Task.checkCancellation()

                        if response.success == true {
                            ChatsList = response.data?.convertToChatList()
                        } else {
                            self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                            self.isError = true
                        }
//                        self.isLoadingComments = false

//                    } catch let error as NetworkError {
//                        self.isLoading = false
//                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        self.isError = true
//        //                print("Network error: \(error.errorDescription)")
                    } catch {
//                        self.isLoadingComments = false
                        if error is CancellationError || (error as? NetworkError) == .requestCancelled {
                                    print("Request cancelled intentionally")
                                    return
                                }
                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                        self.isError = true
                    }
                }
            }
            currentTasks.append(task)

            isLoading = false

        }

      
//        func GetChatComments(chatid:Int){
//    //        isLoading = false
//            var parameters:[String:Any] = [:]
////            if let chatid = selectedChatId{
//                parameters["bookTeacherLessonSessionDetailId"] = chatid
////            }
//            
//            print("parameters",parameters)
//            let target = teacherServices.GetAllComentsListById(parameters: parameters)
//            isLoadingComments = true
//            if Helper.shared.getSelectedUserType() == .Teacher{
//                BaseNetwork.CallApi(target, BaseResponse<StudentChatDetailsM>.self)
//                    .receive(on: DispatchQueue.main)
//                    .sink(receiveCompletion: {[weak self] completion in
//                        guard let self = self else{return}
//                        isLoadingComments = false
//                        switch completion {
//                        case .finished:
//                            break
//                        case .failure(let error):
//                            isError =  true
//                            self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        }
//                    },receiveValue: {[weak self] receivedData in
//                        guard let self = self else{return}
//                        print("receivedData",receivedData)
//                        if receivedData.success == true {
//                            //                    TeacherSubjects?.append(model)
//                            ChatDetails = receivedData.data
//                        }else{
//                            isError =  true
//                            //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                            error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                        }
//                        isLoadingComments = false
//                    })
//                    .store(in: &cancellables)
//            }else{
//                BaseNetwork.CallApi(target, BaseResponse<StudentChatDetailsM>.self)
//                    .receive(on: DispatchQueue.main)
//                    .sink(receiveCompletion: {[weak self] completion in
//                        guard let self = self else{return}
//                        isLoadingComments = false
//                        switch completion {
//                        case .finished:
//                            break
//                        case .failure(let error):
//                            isError =  true
//                            self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
//                        }
//                    },receiveValue: {[weak self] receivedData in
//                        guard let self = self else{return}
//                        print("receivedData",receivedData)
//                        if receivedData.success == true {
//                            ChatDetails = receivedData.data
//                        }else{
//                            isError =  true
//                            //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
//                            error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
//                        }
//                        isLoadingComments = false
//                    })
//                    .store(in: &cancellables)
//            }
//        }

        
        func GetChatComments(chatid:Int) async{
            // Cancel any previous tasks
//             if !currentTasks.isEmpty {
//                 currentTasks.forEach { $0.cancel() }
//                 currentTasks.removeAll()
//             }
            
//            let task = Task{
            var parameters:[String:Any] = [:]
                parameters["bookTeacherLessonSessionDetailId"] = chatid
            
//            print("parameters",parameters)
            let target = teacherServices.GetAllComentsListById(parameters: parameters)
//            isLoadingComments = true

            if Helper.shared.getSelectedUserType() == .Teacher{
                    print(parameters)
        
//                isLoadingComments = true
                    do{
                        let response = try await BaseNetwork.shared.request(target, BaseResponse<StudentChatDetailsM>.self)
                        print(response)
//                        try Task.checkCancellation()

                        if response.success == true {
                            ChatDetails = response.data
                        } else {
                            self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                            self.isError = true
                        }
//                        self.isLoadingComments = false

                    } catch let error as NetworkError {
//                        self.isLoadingComments = false
                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                        self.isError = true
        //                print("Network error: \(error.errorDescription)")
                    } catch {
//                        self.isLoadingComments = false
                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                        self.isError = true
        //                print("Unexpected error: \(error.localizedDescription)")
                    }
                
                }else{
    
//                    isLoadingComments = true
                    //            error = nil
                    do{
                        let response = try await BaseNetwork.shared.request(target, BaseResponse<StudentChatDetailsM>.self)
                        print(response)
//                        try Task.checkCancellation()

                        if response.success == true {
                            ChatDetails = response.data
                        } else {
                            self.error = .error(image:nil, message: response.message ?? "",buttonTitle:"Done")
                            self.isError = true
                        }
//                        self.isLoadingComments = false

                    } catch let error as NetworkError {
//                        self.isLoading = false
                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                        self.isError = true
        //                print("Network error: \(error.errorDescription)")
                    } catch {
//                        if error is CancellationError || (error as? NetworkError) == .requestCancelled {
//                                    print("Request cancelled intentionally")
//                                    return
//                                }
//                        self.isLoadingComments = false
                        self.error = .error(image:nil, message: "\(error.localizedDescription)",buttonTitle:"Done")
                        self.isError = true
                    }
                }
                
//            }
//            currentTasks.append(task)

            }
        
        
        func CreateChatComment(chatid:Int){
    //        isLoading = false
            // Trim leading and trailing spaces
            let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            // Check if the trimmed comment is empty
               guard !trimmedComment.isEmpty,comment != "" else {
                   print("Comment is empty or only contains spaces")
                   return
               }
            
            var parameters:[String:Any] = ["bookTeacherLessonSessionDetailId" : chatid ,"comment":trimmedComment ]
            print("parameters",parameters)
            if Helper.shared.getSelectedUserType() == .Parent {
                parameters["studentId"] = Helper.shared.selectedchild?.id
            }
            let target = teacherServices.CreateComment(parameters: parameters)
            isLoadingComments = true
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
                        comment.removeAll()
                            ChatDetails = receivedData.data
                    }else{
                        isError =  true
                        //                    error = NetworkError.apiError(code: receivedData.messageCode ?? 0, error: receivedData.message ?? "")
                        error = .error(image:nil,  message: receivedData.message ?? "",buttonTitle:"Done")
                    }
                    isLoadingComments = false
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

//    extension StudentChatDetailsM {
//        func convertToChatDetails() -> ChatDetailsM {
//            return ChatDetailsM(id: self.bookTeacherLessonSessionDetailID,
//                                teacherName: self.teacherName,
//                                studentName: self.studentName,
//                                subjectName: self.subjectName,
//                                comments: self.teacherLessonSessionCommentDetailsDtos?.map { commentDto in
//                                    return CommentDetailsDto(comment: commentDto.comment,
//                                                             fromName: commentDto.fromName,
//                                                             toName: commentDto.toName,
//                                                             fromImage: commentDto.fromImage,
//                                                             toImage: commentDto.toImage,
//                                                             creationDate: commentDto.creationDate)
//                                })
//        }
//    }
