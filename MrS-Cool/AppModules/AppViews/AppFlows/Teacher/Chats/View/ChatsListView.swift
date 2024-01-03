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
    @State var selectedLessonId : Int = 0

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
                    
                    if let array = searchResults{
                        CustomSearchBar(searchText: $searchQuery)
                            .padding([.top,.horizontal])
                        
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
                
            }
            .onAppear(perform: {
                chatlistvm.isLoading = false
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
    var searchResults: [ChatListM]? {
//        if let array = chatlistvm.ChatsList{
            if searchQuery.isEmpty {
                return chatlistvm.ChatsList ?? []
            } else {
                return chatlistvm.ChatsList?.filter{"\($0.studentName ?? "")".contains(searchQuery)} ?? []
            }
//        }
    }
    
}

#Preview {
    ChatsListView()
        .environmentObject(ChatListVM())
    
}

struct CustomSearchBar: View {
    var placeHolder: String? = ""
    @Binding var searchText: String

var body: some View {
    HStack {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(placeHolder?.localized() ?? "Search".localized(), text: $searchText)
                .font(Font.SoraRegular(size:13))
                .foregroundColor(.mainBlue)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

            if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
        }
        .padding(12)
        .background(RoundedCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
        .fill(ColorConstants.Red400.opacity(0.08)))
        
        if !searchText.isEmpty {
            Button(action: {
                searchText = ""
                hideKeyboard()
            }) {
                Text("Cancel".localized())
                    .font(Font.SoraRegular(size:13))
                    .foregroundColor(.blue) // Customize the color as needed
            }
        }

    }
}
}
#Preview{
    CustomSearchBar(placeHolder: "Search",searchText: .constant(""))
}


