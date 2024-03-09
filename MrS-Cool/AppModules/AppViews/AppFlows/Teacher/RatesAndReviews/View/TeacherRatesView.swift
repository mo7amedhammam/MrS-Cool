//
//  TeacherRatesView.swift
//  MrS-Cool
//
//  Created by wecancity on 09/03/2024.
//

import SwiftUI

//
//  ChatsListView.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//
import SwiftUI

struct TeacherRatesView: View {
    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
//    @EnvironmentObject var lookupsvm : LookUpsVM
    @StateObject var chatlistvm = ChatListVM()
        
//    @State var showFilter : Bool = false
    @State private var searchQuery = ""

    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @State var selectedChatId : Int?
    @State var selectedLessonId : Int = 0
    var hasNavBar : Bool? = true

    var body: some View {
        VStack {
//            if hasNavBar ?? true{
                CustomTitleBarView(title: "Rates and Reviews")
//            }
            GeometryReader { gr in
                HStack (alignment:.top){
                    
                    Image("MenuSt_rates")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.mainBlue)
                        .frame(width: 35, height: 35, alignment: .center)
                    
                    VStack{ // (Title - Data - Submit Button)
                        //                        Group{
                        //                            HStack(){
                        
                        
                        SignUpHeaderTitle(Title: "Rates and Reviews")
                            .foregroundStyle(Color.mainBlue)

                        //                                Spacer()
                        Group{
                            Text("4.5 of 5 ")
                                .font(.SoraBold(size: 30))
                            + Text(" /   ")
                            + Text("113 ")
                                .font(.SoraBold(size: 16))
                            + Text("Rate")
                                .font(.SoraRegular(size: 13))
                        }
                        .foregroundStyle(Color.mainBlue)
//                        }
//                        .padding(.horizontal)
                        
                        if let array = chatlistvm.ChatsList{
                            
                            List(Array(array.enumerated()), id:\.element.hashValue){ index,chat in
                                Button(action: {
                                    if selectedChatId == nil{
                                        selectedChatId = index
                                    }else{
                                        selectedChatId = nil
                                    }
                                }, label: {
                                    ChatListCell(model: chat, isExpanded: .constant(selectedChatId == index), selectedLessonId: $selectedLessonId, selectLessonBtnAction: {
                                        destination = AnyView(MessagesListView( selectedLessonId: selectedLessonId ).environmentObject(chatlistvm))
                                        isPush = true
                                        if hasNavBar == false{
                                            studenthometabbarvm.destination = AnyView(MessagesListView( selectedLessonId: selectedLessonId).environmentObject(chatlistvm))
                                            studenthometabbarvm.ispush = true
                                        }
                                    })
                                })
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
                            //                        .searchable(text: $searchQuery, prompt: "Search".localized())
                        }
                        Spacer()
                    }
                    .frame(minHeight:gr.size.height)
                    .onAppear(perform: {
                        chatlistvm.GetChatsList()
                })
                }
                .padding(.top)
                .padding(.horizontal)
            }
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
//        .onDisappear {
////            chatlistvm.isLoading = false
//
////            chatlistvm.cleanup()
//        }
        .showHud(isShowing: $chatlistvm.isLoading)
//        .showAlert(hasAlert: $chatlistvm.isError, alertType: chatlistvm.error)
//        if hasNavBar == true{
//            NavigationLink(destination: destination, isActive: $isPush, label: {})
//        }
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
    TeacherRatesView()
        .environmentObject(StudentTabBarVM())
//        .environmentObject(ChatListVM())
    
}
