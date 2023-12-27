//
//  MessagesListView.swift
//  MrS-Cool
//
//  Created by wecancity on 27/12/2023.
//

import SwiftUI

struct MessagesListView: View {
    @EnvironmentObject var chatlistvm : ChatListVM
     var selectedLessonId : Int
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Messages")
            
            GeometryReader { gr in
                VStack{ // (Title - Data - Submit Button)
                    Group{
                        HStack(){
                            Image("img_message2")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor)
                                .frame(width: 35, height: 35, alignment: .center)
                            
                            SignUpHeaderTitle(Title: "Messages")
                            Spacer()
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    
                    if let array = chatlistvm.ChatDetails?.comments{
                        List(Array(array.enumerated()), id:\.element.hashValue){ index,comment in
                                    HStack{
                                        if comment.fromName != nil {
                                            Spacer()
                                        }

                                        Text(comment.comment ?? "")
                                            .padding(10)
                                            .foregroundColor(Color.black)
                                            .background(comment.fromName != nil ? Color.clear : ColorConstants.Red400.opacity(0.08))
                                            .cornerRadius(10)
                                        
                                        if comment.fromName == nil {
                                            Spacer()
                                        }
                                    }
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                    }
                    Spacer()
                }
            }
            .onAppear(perform: {
                chatlistvm.selectedChatId = selectedLessonId
                chatlistvm.GetChatComments()
            })
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onDisappear {
            chatlistvm.cleanup()
        }
        .showHud(isShowing: $chatlistvm.isLoading)
        .showAlert(hasAlert: $chatlistvm.isError, alertType: chatlistvm.error)
        
    }
//    var searchResults: [ChatListM]? {
////        if let array = chatlistvm.ChatsList{
//            if searchQuery.isEmpty {
//                return chatlistvm.ChatsList ?? []
//            } else {
//                return chatlistvm.ChatsList?.filter{"\($0.studentName ?? "")".contains(searchQuery)} ?? []
//            }
////        }
//    }
}

#Preview {
    MessagesListView( selectedLessonId: 0)
        .environmentObject(ChatListVM())
}



