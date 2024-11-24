////
////  ChatsListView.swift
////  MrS-Cool
////
////  Created by wecancity on 26/12/2023.
////
//import SwiftUI
//
//struct ChatsListView: View {  
//    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
////    @EnvironmentObject var lookupsvm : LookUpsVM
//    @StateObject var chatlistvm = ChatListVM()
//        
////    @State var showFilter : Bool = false
//    @State private var searchQuery = ""
//
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
//    @State var selectedChatId : Int?
//    @State var selectedLessonId : Int = 0
//    var hasNavBar : Bool? = true
//    @Binding var selectedChild:ChildrenM?
//    var body: some View {
//        VStack {
//            if hasNavBar ?? true{
//                CustomTitleBarView(title: "Messages")
//            }
//            GeometryReader { gr in
//                if Helper.shared.getSelectedUserType() == .Parent && selectedChild == nil{
//                    VStack{
//                        Text("You Have To Select Child First".localized())
//                            .frame(minHeight:gr.size.height)
//                            .frame(width: gr.size.width,alignment: .center)
//                            .font(Font.semiBold(size: 18))
//                            .foregroundColor(ColorConstants.MainColor)
//                    }
//                }else {
//                    VStack{ // (Title - Data - Submit Button)
//                        Group{
//                            HStack(){
//                                Image("img_message2")
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .foregroundColor(ColorConstants.MainColor)
//                                    .frame(width: 35, height: 35, alignment: .center)
//                                
//                                SignUpHeaderTitle(Title: "Messages")
//                                Spacer()
//                            }
//                            .padding(.top)
//                        }
//                        .padding(.horizontal)
//                        
//                        if let array = searchResults{
//                            CustomSearchBar(searchText: $searchQuery)
//                                .padding([.top,.horizontal])
//                            
//                            List(Array(array.enumerated()), id:\.element.hashValue){ index,chat in
//                                Button(action: {
//                                    if selectedChatId == nil{
//                                        selectedChatId = index
//                                    }else{
//                                        selectedChatId = nil
//                                    }
//                                    chatlistvm.comment.removeAll()
//                                }, label: {
//                                    ChatListCell(model: chat, isExpanded: .constant(selectedChatId == index), selectedLessonId: $selectedLessonId, selectLessonBtnAction: {
//                                        destination = AnyView(MessagesListView( selectedLessonId: selectedLessonId ).environmentObject(chatlistvm))
//                                        isPush = true
//                                        if hasNavBar == false{
//                                            studenthometabbarvm.destination = AnyView(MessagesListView( selectedLessonId: selectedLessonId).environmentObject(chatlistvm))
//                                            studenthometabbarvm.ispush = true
//                                        }
//                                    })
//                                })
//                                .listRowSpacing(0)
//                                .listRowSeparator(.hidden)
//                                .listRowBackground(Color.clear)
//                            }
//                            .listStyle(.plain)
//                            //                        .searchable(text: $searchQuery, prompt: "Search".localized())
//                        }
//                        Spacer()
//                    }
//                    .frame(minHeight:gr.size.height)
////                    .task{
////                        chatlistvm.GetChatsList()
////                    }
//                    .onAppear(){
//                        Task{
//                            chatlistvm.GetChatsList()
//                        }
//                    }
//                    
//                    .onDisappear(perform: {
//                        chatlistvm.cleanup()
//                    })
//                }
//                //-----
//                
//            }
//            
//        }
//        .hideNavigationBar()
//        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
//            hideKeyboard()
//        })
//
//        .showHud(isShowing: $chatlistvm.isLoading)
//        .showAlert(hasAlert: $chatlistvm.isError, alertType: chatlistvm.error)
//        if hasNavBar == true{
//            NavigationLink(destination: destination, isActive: $isPush, label: {})
//        }
//    }
//    var searchResults: [ChatListM]? {
////        if let array = chatlistvm.ChatsList{
//            if searchQuery.isEmpty {
//                return chatlistvm.ChatsList ?? []
//            } else {
//                return chatlistvm.ChatsList?.filter{"\($0.studentName ?? "")".contains(searchQuery)} ?? []
//            }
////        }
//    }
//    
//}
//
//#Preview {
//    ChatsListView( selectedChild: .constant(nil))
//        .environmentObject(StudentTabBarVM())
////        .environmentObject(ChatListVM())
//    
//}
//
struct CustomSearchBar: View {
    var placeHolder: String? = ""
    @Binding var searchText: String

var body: some View {
    HStack {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(placeHolder?.localized() ?? "Search".localized(), text: $searchText)
                .font(Font.regular(size:13))
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
                    .font(Font.regular(size:13))
                    .foregroundColor(.blue) // Customize the color as needed
            }
        }

    }
}
}
#Preview{
    CustomSearchBar(placeHolder: "Search",searchText: .constant(""))
}






import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var studentHomeTabBarVM: StudentTabBarVM
    @StateObject var chatListVM = ChatListVM()
    
    @State private var searchQuery = ""
    @State private var isPush = false
    @State private var destination = AnyView(EmptyView())
    @State private var selectedChatId: Int?
    @State private var selectedLessonId = 0
    
    let hasNavBar: Bool
    @Binding var selectedChild: ChildrenM?
    
    init(hasNavBar: Bool = true, selectedChild: Binding<ChildrenM?>) {
        self.hasNavBar = hasNavBar
        self._selectedChild = selectedChild
    }
    
    var body: some View {
        VStack {
            if hasNavBar {
                CustomTitleBarView(title: "Messages")
            }
            
            GeometryReader { geometry in
                if shouldShowChildSelection {
                    ChildSelectionView()
                } else {
                    ChatListContent(
                        geometry: geometry,
                        chatListVM: chatListVM,
                        searchQuery: $searchQuery,
                        selectedChatId: $selectedChatId,
                        selectedLessonId: $selectedLessonId,
                        destination: $destination,
                        isPush: $isPush,
                        hasNavBar: hasNavBar,
                        studentHomeTabBarVM: studentHomeTabBarVM
                    )
                }
            }
        }
        .hideNavigationBar()
        .background(backgroundView)
        .showHud(isShowing: $chatListVM.isLoading)
        .showAlert(hasAlert: $chatListVM.isError, alertType: chatListVM.error)
        if hasNavBar == true{
                    NavigationLink(destination: destination, isActive: $isPush, label: {})
                }
    }
    
    private var shouldShowChildSelection: Bool {
        Helper.shared.getSelectedUserType() == .Parent && selectedChild == nil
    }
    
    private var backgroundView: some View {
        ColorConstants.Gray50
            .ignoresSafeArea()
            .onTapGesture(perform: hideKeyboard)
    }
}

// MARK: - Supporting Views
private struct ChildSelectionView: View {
    var body: some View {
        Text("You Have To Select Child First")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(ColorConstants.MainColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ChatListContent: View {
    let geometry: GeometryProxy
    @ObservedObject var chatListVM: ChatListVM
    @Binding var searchQuery: String
    @Binding var selectedChatId: Int?
    @Binding var selectedLessonId: Int
    @Binding var destination: AnyView
    @Binding var isPush: Bool
    let hasNavBar: Bool
    @ObservedObject var studentHomeTabBarVM: StudentTabBarVM
    
    var body: some View {
        VStack {
            HeaderView()
            
            if let chats = filteredChats {
                SearchAndListView(
                    chats: chats,
                    searchQuery: $searchQuery,
                    selectedChatId: $selectedChatId,
                    selectedLessonId: $selectedLessonId,
                    chatListVM: chatListVM,
                    destination: $destination,
                    isPush: $isPush,
                    hasNavBar: hasNavBar,
                    studentHomeTabBarVM: studentHomeTabBarVM
                )
            }
            
            Spacer()
        }
        .frame(minHeight: geometry.size.height)
        .task { await fetchChats() }
        .onDisappear { chatListVM.cleanup() }
    }
    
    private var filteredChats: [ChatListM]? {
        guard let chats = chatListVM.ChatsList else { return nil }
        if searchQuery.isEmpty { return chats }
        return chats.filter { $0.studentName?.contains(searchQuery) ?? false }
    }
    
    @MainActor
       private func fetchChats() async {
           chatListVM.isLoading = true // Start the loading animation
           await chatListVM.GetChatsList1()
           chatListVM.isLoading = false // Stop the loading animation
       }
}

private struct HeaderView: View {
    var body: some View {
        HStack {
            Image("img_message2")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(ColorConstants.MainColor)
                .frame(width: 35, height: 35)
            
            SignUpHeaderTitle(Title: "Messages")
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
    }
}

private struct SearchAndListView: View {
    let chats: [ChatListM]
    @Binding var searchQuery: String
    @Binding var selectedChatId: Int?
    @Binding var selectedLessonId: Int
    @ObservedObject var chatListVM: ChatListVM
    @Binding var destination: AnyView
    @Binding var isPush: Bool
    let hasNavBar: Bool
    @ObservedObject var studentHomeTabBarVM: StudentTabBarVM
    
    var body: some View {
        VStack {
            CustomSearchBar(searchText: $searchQuery)
                .padding([.top, .horizontal])
            
            ChatsList(
                chats: chats,
                selectedChatId: $selectedChatId,
                selectedLessonId: $selectedLessonId,
                chatListVM: chatListVM,
                destination: $destination,
                isPush: $isPush,
                hasNavBar: hasNavBar,
                studentHomeTabBarVM: studentHomeTabBarVM
            )
        }
    }
}

private struct ChatsList: View {
    let chats: [ChatListM]
    @Binding var selectedChatId: Int?
    @Binding var selectedLessonId: Int
    @ObservedObject var chatListVM: ChatListVM
    @Binding var destination: AnyView
    @Binding var isPush: Bool
    let hasNavBar: Bool
    @ObservedObject var studentHomeTabBarVM: StudentTabBarVM
    
    var body: some View {
        List(Array(chats.enumerated()), id: \.element.hashValue) { index, chat in
            ChatRow(
                chat: chat,
                isSelected: selectedChatId == index,
                selectedLessonId: $selectedLessonId,
                onSelect: { handleChatSelection(index) },
                onLessonSelect: { handleLessonSelection() }
            )
            .listRowSpacing(0)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
    
    private func handleChatSelection(_ index: Int) {
        selectedChatId = selectedChatId == index ? nil : index
        chatListVM.comment.removeAll()
    }
    
    private func handleLessonSelection() {
        let messagesView = MessagesListView(selectedLessonId: selectedLessonId)
            .environmentObject(chatListVM)
        
        if hasNavBar {
            destination = AnyView(messagesView)
            isPush = true
        } else {
            studentHomeTabBarVM.destination = AnyView(messagesView)
            studentHomeTabBarVM.ispush = true
        }
    }
}

private struct ChatRow: View {
    let chat: ChatListM
    let isSelected: Bool
    @Binding var selectedLessonId: Int
    let onSelect: () -> Void
    let onLessonSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ChatListCell(
                model: chat,
                isExpanded: .constant(isSelected),
                selectedLessonId: $selectedLessonId,
                selectLessonBtnAction: onLessonSelect
            )
        }
    }
}

#Preview {
    ChatsListView(selectedChild: .constant(nil))
        .environmentObject(StudentTabBarVM())
}
