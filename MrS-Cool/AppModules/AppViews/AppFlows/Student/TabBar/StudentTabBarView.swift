//
//  StudentTabBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/01/2024.
//


import SwiftUI
enum Studentdestinations{
    case editProfile, calendar, rates, changePassword, tickets, signOut, deleteAccount
}
struct StudentTabBarView: View {
    @StateObject var studenttabbarvm = StudentTabBarVM()
    @State private var selectedIndex = 2
    @State private var selectedDestination : Studentdestinations = .editProfile

    private let tabBarItems = [
        TabBarItem(icon: "tab0", selectedicon: "tab0selected", title: ""),
        TabBarItem(icon: "tab1", selectedicon: "tab1selected", title: ""),
        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
        TabBarItem(icon: "tab3", selectedicon: "tab3selected", title: ""),
        TabBarItem(icon: "tab4", selectedicon: "tab4selected", title: "")
    ]
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    
    @State var presentSideMenu = false
    var body: some View {
//        NavigationView{
            VStack() {
                HStack {
                    VStack(alignment: .leading){
                        Group{
                            Text("Hi ")+Text("Student ")+Text(",\(selectedIndex)".localized())
                            
                            Text("Lets Start Learning! ".localized())
                                .font(Font.SoraRegular(size: 11))
                                .padding(.vertical,0.5)
                        }
                        .font(Font.SoraBold(size: 18))
                        .foregroundColor(.whiteA700)
                        
                    }
                    
                    Spacer()
                    Button(action: {
                        presentSideMenu.toggle()
                    }, label: {
                        Image("sidemenue")
                            .padding(.vertical,15)
                            .padding(.horizontal,10)

                    })
                    .background(
                        CornersRadious(radius: 10, corners: [.topLeft,.topRight,.bottomLeft,.bottomRight])
                            .fill(ColorConstants.WhiteA700)
                    )
                }
                .padding([.bottom,.horizontal])
                .background(
                    CornersRadious(radius: 10, corners: [.bottomLeft,.bottomRight])
                        .fill(ColorConstants.MainColor)
                        .edgesIgnoringSafeArea(.top)
                )
                
                TabView(selection: $selectedIndex) {
//                    StudentHomeView()
                    Text("tab 0") // dashboard
                        .tag(0)
                        .gesture(
                            DragGesture().onChanged { _ in
                                // Disable swipe gestures
                            }
                        )
                    
//                    StudentHomeView()
                    Text("tab 1") // finance
                        .tag(1)
                        .gesture(
                            DragGesture().onChanged { _ in
                                // Disable swipe gestures
                            }
                        )
                    
                    StudentHomeView() // home
                        .environmentObject(studenttabbarvm)
                        .tag(2)
                        .gesture(
                            DragGesture().onChanged { _ in
                                // Disable swipe gestures
                            }
                        )
                    
                    
//                    StudentHomeView()
//                    Text("tab 3")
//                    destination = AnyView(ChatsListView()
////                            .environmentObject(lookupsvm)
//                        .environmentObject(chatlistvm)
////                                .hideNavigationBar()
//                    )
                    ChatsListView() // chats
                        .environmentObject(ChatListVM())
                        .tag(3)
                        .gesture(
                            DragGesture().onChanged { _ in
                                // Disable swipe gestures
                            }
                        )
                    
//                    StudentHomeView()
                    Text("tab 4") // completed lessons
                        .tag(4)
                        .gesture(
                            DragGesture().onChanged { _ in
                                // Disable swipe gestures
                            }
                        )
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.top,-8)
                .padding(.bottom,-15)
                                
                Spacer()
                CustomTabBarView(selectedIndex: $selectedIndex,tabBarItems:tabBarItems)

            }
            .overlay(content: {
                SideMenuView()
            })
            .edgesIgnoringSafeArea(.bottom)
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            .onChange(of: selectedDestination) {newval in
                if newval == .editProfile{ //edit Profile
                    
                }else if newval == .calendar { //calendar
                    studenttabbarvm.destination = AnyView(CalView1())
                    
                }else if newval == .rates { // rates
                    studenttabbarvm.destination = AnyView(Text("Rates"))
                }else if newval == .changePassword { // change password
                    studenttabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
                }else if newval == .tickets { // tickets
                    
                }else if newval == .signOut { // signout
                    studenttabbarvm.destination =
                   AnyView(SignInView())
                    Helper.shared.IsLoggedIn(value: false)
                }
            }
//        }
            NavigationLink(destination: studenttabbarvm.destination, isActive: $studenttabbarvm.ispush, label: {})
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(StudentSideMenuContent(presentSideMenu: $presentSideMenu, selectedDestination: $selectedDestination, isPush: $studenttabbarvm.ispush)), direction: .leading)
    }
}

#Preview{
    StudentTabBarView()
}

enum HomeTabs {
    case tab0,tab1,tab2,tab3,tab4
}
struct CustomTabBarView: View {
    @Binding var selectedIndex : Int
    let tabBarItems : [TabBarItem]
    private let middleTabWidth: CGFloat = 60
    private let middleTabHeight: CGFloat = 66
    private let middleTabCurveHeight: CGFloat = 30
    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 0) {
                ForEach(0..<tabBarItems.count) { index in
                    TabBarItemView(
                        item: tabBarItems[index],
                        isSelected: selectedIndex == index,
                        onTap: {
                            selectedIndex = index
                        }
                    )
                    .offset(y:index == tabBarItems.count / 2  ? -12 : 8 )
                    if index == tabBarItems.count / 2 - 1 {
                        Spacer()
                    }
                }
            }
            .frame(height: middleTabHeight)
            .background(content: {
                tabshape(midpoint: UIScreen.main.bounds.midX+4)
                    .fill(ColorConstants.WhiteA700)
                    .shadow(color: ColorConstants.Black900.opacity(0.2), radius: 10, x: 0, y: 0)
                    .edgesIgnoringSafeArea(.bottom)
                
            })
            //            }
            //            .frame(height: middleTabHeight)
        }
        
        //        .frame(height: middleTabHeight)
        
    }
}

struct TabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
//        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(isSelected ? item.selectedicon:item.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(item.title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
            .onTapGesture {
                onTap()
            }
//        }
//        .frame(maxWidth: .infinity)
    }
}

struct TabBarItem {
    let icon: String
    let selectedicon: String
    let title: String
}

struct tabshape:Shape {
    var midpoint:CGFloat
    func path(in rect:CGRect) -> Path {
        return Path{ path in
            path.addPath(Rectangle().path(in: rect))
            
            path.move(to: .init(x: midpoint - 60, y: 0))
            let to = CGPoint(x: midpoint, y: -25)
            let cont1 = CGPoint(x: midpoint - 25 , y: 0)
            let cont2 = CGPoint(x: midpoint - 25, y: -25)
            path.addCurve(to: to, control1: cont1, control2: cont2)
            
            let to1 = CGPoint(x: midpoint + 60, y: 0)
            let cont3 = CGPoint(x: midpoint + 25 , y: -25)
            let cont4 = CGPoint(x: midpoint + 25, y: 0)
            path.addCurve(to: to1, control1: cont3, control2: cont4)
            
        }
    }
}

enum Categories:String{
    case home = "home"
    case favorite = "favorite"
    case chat = "chat"
    case profile = "profile"
}

struct StudentSideMenuContent: View {
    @Binding var presentSideMenu: Bool
    @Binding var selectedDestination: Studentdestinations
    @Binding var isPush: Bool

    var body: some View {
        ScrollView{
            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing:20){
                    
                    ZStack(alignment: .topLeading){
                        AsyncImage(url: URL(string: Constants.baseURL+"")){image in
                            image
                                .resizable()
                        }placeholder: {
                            Image("img_younghappysmi")
                                .resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60,height: 60)
                        .clipShape(Circle())
                        
                        Image("Edit_fill")
                        //                        .resizable().aspectRatio(contentMode: .fit)
                        //                        .font(.InterMedium(size: 12))
                            .frame(width: 15,height: 15)
                            .background(.white)
                            .clipShape(Circle())
                            .offset(x:0,y:2)
                            .onTapGesture(perform: {
                                // show edit profile
                                selectedDestination = .editProfile
                                isPush = true
                            })
                        
                    }
                    VStack(alignment:.leading) {
                        Text("Jhon Smith")
                            .font(.SoraBold(size: 18))
                            .foregroundStyle(.whiteA700)
                        
                        Text("Edit your profile")
                            .font(.SoraRegular(size: 12))
                            .foregroundStyle(.whiteA700)
                    }
                    
                    Spacer()
                    }
                .padding()
                
                SideMenuSectionTitle(title: "Academic")
                
                SideMenuButton(image: "MenuSt_calendar", title: "Calendar"){
                    selectedDestination = .calendar // calendar
                    presentSideMenu =  false
                    isPush = true
                }

                SideMenuButton(image: "MenuSt_lock", title: "Rates & Reviews"){
                    selectedDestination = .rates // rates
                    presentSideMenu =  false
                    isPush = true
                }
                
                SideMenuSectionTitle(title: "Settings")

                SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
                    selectedDestination = .changePassword // cahnage Password
                    presentSideMenu =  false
                    isPush = true
                }

                SideMenuButton(image: "MenuSt_tickets", title: "Tickets"){
                    selectedDestination = .tickets // Tickets
                    presentSideMenu =  false
                    isPush = true
                }

                SideMenuButton(image: "MenuSt_signout", title: "Sign Out"){
                    selectedDestination = .signOut // sign out
                    presentSideMenu =  false
                    isPush = true
                }
                
                SideMenuButton(image: "MenuSt_signout", title: "Delete Account"){
                    selectedDestination = .deleteAccount // delete account
                    presentSideMenu =  false
                    isPush = true
                }

                Spacer()
            }
        }
            .frame(width: UIScreen.main.bounds.width - 80)
            .padding(.top, 55)
            .background{
                Color.mainBlue
        }
    }
    
}

struct SideMenuSectionTitle: View {
    var title : String
    
    var body: some View {
        HStack {
            Text(title.localized())
                .font(.SoraBold(size: 18))
                .foregroundColor(ColorConstants.WhiteA700)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
        .background(content: {
            ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                .padding(.leading,-20)
        })
    }
}

struct SideMenuButton: View {
    var image : String
    var title : String
    var action : () -> ()
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack{
                Image(image)
                Text(title.localized())
                    .font(.SoraSemiBold(size: 13))
                    .foregroundStyle(ColorConstants.WhiteA700)
                Spacer()
            }
            .padding()
        })
    }
}
