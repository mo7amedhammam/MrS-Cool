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
    @State var selectedChatId : Int?
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
                    if let array = chatlistvm.ChatsList{
                        List(Array(array.enumerated()), id:\.element.hashValue){ index,chat in
                        Button(action: {
                            if selectedChatId == nil{
                                selectedChatId = index
                            }else{
                                selectedChatId = nil
                            }
                        }, label: {
                            ChatListCell(model: chat, isExpanded: .constant(selectedChatId == index), selectLessonBtnAction: {
                                //                                chatlistvm.selectedLessonid = lesson.teacherLessonSessionSchedualSlotID
                                                    
                                destination = AnyView(CompletedLessonDetails().environmentObject(CompletedLessonsVM()))
                                isPush = true
                                
                            })
                        })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchQuery)
                }
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
