//
//  ChatsListView.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//
import SwiftUI

struct ChatsListView: View {  
//    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var chatlistvm : ChatListVM
        
//    @State var showFilter : Bool = false
    @State private var searchQuery = ""

    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
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
//                ScrollView(.vertical,showsIndicators: false){
                
                        List(chatlistvm.ChatsList ?? [], id:\.self) { chat in
                            ChatListCell(model: chat, selectLessonBtnAction: {
                                //                                chatlistvm.selectedLessonid = lesson.teacherLessonSessionSchedualSlotID
                                //                                destination = AnyView(CompletedLessonDetails().environmentObject(chatlistvm))
                                                                
                                //                                isPush = true

                            })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .padding(.horizontal,-4)
                        .listStyle(.plain)
//                        .frame(height: gr.size.height)
                        .searchable(text: $searchQuery)

                        Spacer()
//                    }
//                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
//                lookupsvm.GetSubjestForList()
                chatlistvm.GetChatsList()
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
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    ChatsListView()
//        .environmentObject(LookUpsVM())
        .environmentObject(ChatListVM())
    
}
