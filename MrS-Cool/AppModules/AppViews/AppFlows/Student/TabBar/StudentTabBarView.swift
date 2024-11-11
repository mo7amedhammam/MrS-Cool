//
//  StudentTabBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/01/2024.
//


import SwiftUI
enum Studentdestinations{
    case editProfile, calendar, changePassword, tickets, schedualsList, signOut, deleteAccount
}
//struct StudentTabBarView: View {
//    @StateObject var studenttabbarvm = StudentTabBarVM()
////    @StateObject var localizeHelper = LocalizeHelper.shared
//    @State private var selectedDestination : Studentdestinations?
//
//    private let tabBarItems = [
//        TabBarItem(icon: "tab0", selectedicon: "tab0selected", title: ""),
//        TabBarItem(icon: "tab1", selectedicon: "tab1selected", title: ""),
//        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
//        TabBarItem(icon: "tab3", selectedicon: "tab3selected", title: ""),
//        TabBarItem(icon: "tab4", selectedicon: "tab4selected", title: "")
//    ]
//
//    @StateObject var studentsignupvm = StudentEditProfileVM()
//
//    @State var presentSideMenu = false
//    var body: some View {
////        NavigationView{
//            VStack() {
//                HStack {
//                    VStack(alignment: .leading){
//                        Group{
//                            Text("Hi, ".localized())+Text(studentsignupvm.name)
//                        }
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.whiteA700)
//                    }
//
//                    Spacer()
//                    Button(action: {
//                        presentSideMenu.toggle()
//                    }, label: {
//                        Image("sidemenue")
//                            .padding(.vertical,15)
//                            .padding(.horizontal,10)
//                    })
//                    .background(
//                        CornersRadious(radius: 10, corners: [.topLeft,.topRight,.bottomLeft,.bottomRight])
//                            .fill(ColorConstants.WhiteA700)
//                    )
//                }
//                .padding([.bottom,.horizontal])
//                .background(
//                    CornersRadious(radius: 10, corners: [.bottomLeft,.bottomRight])
//                        .fill(ColorConstants.MainColor)
//                        .edgesIgnoringSafeArea(.top)
//                )
//
////                Group{
////                    switch studenttabbarvm.selectedIndex{
////                        //                case 0:
////                        //                    Text("tab 0") // dashboard
////
////                    case 1:
////                        StudentFinanceView(selectedChild: .constant(nil)) // finance
////
////                    case 2:
////                        StudentHomeView() // home
////                            .environmentObject(studenttabbarvm)
////                            .environmentObject(studentsignupvm)
////                    case 3:
////                        ChatsListView(hasNavBar : false, selectedChild: .constant(nil)) // chats
////                            .environmentObject(studenttabbarvm)
////
////                    case 4:
////                        StudentCompletedLessonsView(hasNavBar : false, selectedChild: .constant(nil)) // completed lessons
////                            .environmentObject(studenttabbarvm)
////
////                    default: // case 0
////                        Text("tab 0") // dashboard
////
////                    }
////                }
////                .padding(.top,-8)
////                .padding(.bottom,-15)
//
//                TabView(selection: $studenttabbarvm.selectedIndex) {
//                   Text("")
//                    .tag(0)
//                        .gesture(
//                            DragGesture().onChanged { _ in
//                                // Disable swipe gestures
//                            }
//                        )
////                        .onAppear(perform: {
////                            presentSideMenu = true
////                        })
//
//                    StudentFinanceView(selectedChild: .constant(nil)) // finance
//                        .tag(1)
//                        .gesture(
//                            DragGesture().onChanged { _ in
//                                // Disable swipe gestures
//                            }
//                        )
//
//                    StudentHomeView() // home
////                    TeacherHomeView(selectedChild: .constant(nil))
//                        .tag(2)
//                        .environmentObject(studenttabbarvm)
//                        .environmentObject(studentsignupvm)
//                        .gesture(
//                            DragGesture().onChanged { _ in
//                                // Disable swipe gestures
//                            }
//                        )
//
//                    ChatsListView(hasNavBar : false, selectedChild: .constant(nil)) // chats
//                        .tag(3)
//                        .environmentObject(studenttabbarvm)
//                        .gesture(
//                            DragGesture().onChanged { _ in
//                                // Disable swipe gestures
//                            }
//                        )
//
//                    StudentCompletedLessonsView(hasNavBar : false, selectedChild: .constant(nil)) // completed lessons
//                        .tag(4)
//                        .environmentObject(studenttabbarvm)
//                        .gesture(
//                            DragGesture().onChanged { _ in
//                                // Disable swipe gestures
//                            }
//                        )
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                .padding(.top,-8)
//                .padding(.bottom,-15)
//
//                Spacer()
//                CustomTabBarView(selectedIndex: $studenttabbarvm.selectedIndex,tabBarItems:tabBarItems)
//            }
//            .localizeView()
////            .onAppear{
//////                Task(priority: .background, operation: {
////                    studentsignupvm.GetStudentProfile()
//////                })
////            }
//            .task{
//                studentsignupvm.GetStudentProfile()
//            }
//            .onChange(of: studenttabbarvm.selectedIndex){newval in
//                guard newval == 0 else {return}
//                    presentSideMenu = true
//            }
////            .task(id: localizeHelper.currentLanguage, {
////                studentsignupvm.GetStudentProfile()
////            })
////            .onChange(of: localizeHelper.currentLanguage, perform: {_ in
////                Task(priority: .background, operation: {
////                    studentsignupvm.GetStudentProfile()
////                })
////            })
//            .overlay(content: {
//                SideMenuView()
//            })
//            .edgesIgnoringSafeArea(.bottom)
//            .hideNavigationBar()
//            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
//                hideKeyboard()
//            })
//            .onChange(of: selectedDestination) {newval in
//                if newval == .editProfile{ //edit Profile
//                    studenttabbarvm.destination = AnyView(StudentEditProfileView().environmentObject(studentsignupvm))
//                }else if newval == .calendar { //calendar
//                    studenttabbarvm.destination = AnyView(CalView1(selectedChild: .constant(nil)))
//                } else if newval == .schedualsList{
//                    studenttabbarvm.destination = AnyView(TeacherHomeView(selectedChild: .constant(nil)).environmentObject(studentsignupvm))
//
//                }else if newval == .changePassword { // change password
//                    studenttabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
//
//                }else if newval == .signOut { // signout
//                    studenttabbarvm.error = .question(title: "Are you sure you want to sign out ?", image: "MenuSt_signout", message: "Are you sure you want to sign out ?", buttonTitle: "Sign Out", secondButtonTitle: "Cancel", mainBtnAction: {
//                        Helper.shared.changeRoot(toView: AnonymousHomeView())
//                        Helper.shared.logout()
//                        Helper.shared.selectedchild = nil
//                    },secondBtnAction:{
//                        selectedDestination = nil
//                    })
//                    studenttabbarvm.showSignOutConfirm = true
//
//                }else if newval == .deleteAccount{
//                    studenttabbarvm.error = .question(title: "Are you sure you want to Delete Your Account ?", image: "img_subtract", message: "Are you sure you want to Delete Your Account ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
//                        studenttabbarvm.deleteAccount()
//                    },secondBtnAction:{
//                        selectedDestination = nil
//                    })
//                    studenttabbarvm.showDeleteConfirm = true
//                }
//            }
//            .showAlert(hasAlert: $studenttabbarvm.isError, alertType: studenttabbarvm.error)
//            .showAlert(hasAlert: $studenttabbarvm.showSignOutConfirm, alertType: studenttabbarvm.error)
//            .showAlert(hasAlert: $studenttabbarvm.showDeleteConfirm, alertType: studenttabbarvm.error)
//
//        NavigationLink(destination: studenttabbarvm.destination, isActive: $studenttabbarvm.ispush, label: {})
//            .onChange(of: presentSideMenu, perform: { value in
//                if value == false && studenttabbarvm.selectedIndex == 0{
//                    studenttabbarvm.selectedIndex = 2
//                }
//            })
//    }
//
//    @ViewBuilder
//    private func SideMenuView() -> some View {
//        SideView(isShowing: $presentSideMenu, content: AnyView(StudentSideMenuContent(presentSideMenu: $presentSideMenu, selectedDestination: $selectedDestination, isPush: $studenttabbarvm.ispush).environmentObject(studentsignupvm)), direction: .leading)
//            .onDisappear(perform: {
//            selectedDestination = nil
//        })
//    }
//}


//
//enum Studentdestinations {
//    case editProfile, calendar, changePassword, tickets, schedualsList, signOut, deleteAccount
//}
//
struct StudentTabBarView: View {
    @StateObject private var studenttabbarvm = StudentTabBarVM()
    @StateObject private var studentsignupvm = StudentEditProfileVM()
    @State private var selectedDestination: Studentdestinations?
    @State private var presentSideMenu = false
    
    private let tabBarItems = [
        TabBarItem(icon: "tab0", selectedicon: "tab0selected", title: ""),
        TabBarItem(icon: "tab1", selectedicon: "tab1selected", title: ""),
        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
        TabBarItem(icon: "tab3", selectedicon: "tab3selected", title: ""),
        TabBarItem(icon: "tab4", selectedicon: "tab4selected", title: "")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(presentSideMenu: $presentSideMenu, name: studentsignupvm.name)
            
            // Main Content
            TabView(selection: $studenttabbarvm.selectedIndex) {
                Text("")
                    .tag(0)
                    .gesture(DragGesture().onChanged { _ in })
                
                StudentFinanceView(selectedChild: .constant(nil))
                    .tag(1)
                    .gesture(DragGesture().onChanged { _ in })
                
                StudentHomeView()
                    .tag(2)
                    .environmentObject(studenttabbarvm)
                    .environmentObject(studentsignupvm)
                    .gesture(DragGesture().onChanged { _ in })
                
                ChatsListView(hasNavBar: false, selectedChild: .constant(nil))
                    .tag(3)
                    .environmentObject(studenttabbarvm)
                    .gesture(DragGesture().onChanged { _ in })
                
                StudentCompletedLessonsView(hasNavBar: false, selectedChild: .constant(nil))
                    .tag(4)
                    .environmentObject(studenttabbarvm)
                    .gesture(DragGesture().onChanged { _ in })
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.top, -8)
            .padding(.bottom, -15)
            
            CustomTabBarView(selectedIndex: $studenttabbarvm.selectedIndex, tabBarItems: tabBarItems)
        }
        .task {
            await studentsignupvm.GetStudentProfile()
        }
        .onChange(of: studenttabbarvm.selectedIndex) { newValue in
            if newValue == 0 {
                presentSideMenu = true
            }
        }
        .overlay {
            SideMenuView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onChange(of: selectedDestination) {newval in
            if newval == .editProfile{ //edit Profile
                studenttabbarvm.destination = AnyView(StudentEditProfileView().environmentObject(studentsignupvm))
            }else if newval == .calendar { //calendar
                studenttabbarvm.destination = AnyView(CalView1(selectedChild: .constant(nil)))
            } else if newval == .schedualsList{
                studenttabbarvm.destination = AnyView(TeacherHomeView(selectedChild: .constant(nil)).environmentObject(studentsignupvm))
                
            }else if newval == .changePassword { // change password
                studenttabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
                
            }else if newval == .signOut { // signout
                studenttabbarvm.error = .question(title: "Are you sure you want to sign out ?", image: "MenuSt_signout", message: "Are you sure you want to sign out ?", buttonTitle: "Sign Out", secondButtonTitle: "Cancel", mainBtnAction: {
                    Helper.shared.changeRoot(toView: AnonymousHomeView())
                    Helper.shared.logout()
                    Helper.shared.selectedchild = nil
                },secondBtnAction:{
                    selectedDestination = nil
                })
                studenttabbarvm.showSignOutConfirm = true
                
            }else if newval == .deleteAccount{
                studenttabbarvm.error = .question(title: "Are you sure you want to Delete Your Account ?", image: "img_subtract", message: "Are you sure you want to Delete Your Account ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                    studenttabbarvm.deleteAccount()
                },secondBtnAction:{
                    selectedDestination = nil
                })
                studenttabbarvm.showDeleteConfirm = true
            }
        }
        .onChange(of: presentSideMenu, perform: { value in
            if value == false && studenttabbarvm.selectedIndex == 0{
                studenttabbarvm.selectedIndex = 2
            }
        })
        .showAlert(hasAlert: $studenttabbarvm.isError, alertType: studenttabbarvm.error)
        .showAlert(hasAlert: $studenttabbarvm.showSignOutConfirm, alertType: studenttabbarvm.error)
        .showAlert(hasAlert: $studenttabbarvm.showDeleteConfirm, alertType: studenttabbarvm.error)
        
        NavigationLink(destination: studenttabbarvm.destination, isActive: $studenttabbarvm.ispush, label: {})
        
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(
            isShowing: $presentSideMenu,
            content: AnyView(
                StudentSideMenuContent(
                    presentSideMenu: $presentSideMenu,
                    selectedDestination: $selectedDestination,
                    isPush: $studenttabbarvm.ispush
                )
                .environmentObject(studentsignupvm)
            ),
            direction: .leading
        )
        .onDisappear {
            selectedDestination = nil
        }
    }
}
//
//// MARK: - Header View
private struct HeaderView: View {
    @Binding var presentSideMenu: Bool
    let name: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Group{
                    Text("Hi, ".localized()) + Text(name)
                }    .font(.bold(size: 18))
                    .foregroundColor(.whiteA700)
            }
            
            Spacer()
            
            Button {
                presentSideMenu.toggle()
            } label: {
                Image("sidemenue")
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
            }
            .background(
                CornersRadious(radius: 10, corners: [.allCorners])
                    .fill(ColorConstants.WhiteA700)
            )
        }
        .padding([.bottom, .horizontal])
        .background(
            CornersRadious(radius: 10, corners: [.bottomLeft, .bottomRight])
                .fill(ColorConstants.MainColor)
                .edgesIgnoringSafeArea(.top)
        )
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
                    //                    if index == tabBarItems.count / 2 - 1 {
                    //                        Spacer()
                    //                    }
                }
            }
            .frame(height: middleTabHeight)
            .background(content: {
                tabshape(midpoint: UIScreen.main.bounds.midX)
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
    @EnvironmentObject var studentsignupvm : StudentEditProfileVM
    
    @Binding var presentSideMenu: Bool
    @Binding var selectedDestination: Studentdestinations?
    @Binding var isPush: Bool
    
    var body: some View {
        VStack {
            ScrollView{
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing:20){
                        ZStack(alignment: .topLeading){
                            let imageURL : URL? = URL(string: Constants.baseURL+(studentsignupvm.imageStr ?? "").reverseSlaches())
                            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
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
                            
                        }
                        VStack(alignment:.leading) {
                            Text(studentsignupvm.name)
                                .font(.bold(size: 18))
                                .foregroundStyle(.whiteA700)
                            
                            Text("Edit your profile".localized())
                                .font(.regular(size: 12))
                                .foregroundStyle(.whiteA700)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .onTapGesture {
                        selectedDestination = .editProfile
                        presentSideMenu =  false
                        isPush = true
                        
                    }
                    SideMenuSectionTitle(title: "Academic")
                    
                    SideMenuButton(image: "MenuSt_calendar", title: "Calendar"){
                        selectedDestination = .calendar // calendar
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuButton(image: "checkoutcaltime", title: "Schedual List"){
                        selectedDestination = .schedualsList // rates
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuSectionTitle(title: "Settings")
                    
                    SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
                        selectedDestination = .changePassword // cahnage Password
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    //                    SideMenuButton(image: "MenuSt_tickets", title: "Tickets"){
                    //                        selectedDestination = .tickets // Tickets
                    //                        presentSideMenu =  false
                    //                        isPush = true
                    //                    }
                    ChangeLanguage()
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Sign Out"){
                        selectedDestination = .signOut // sign out
                        presentSideMenu =  false
                        //                    isPush = true
                    }
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Delete Account",titleColor: ColorConstants.Red400){
                        selectedDestination = .deleteAccount // delete account
                        presentSideMenu =  false
                    }
                    
                    Spacer()
                }
            }
            VStack(alignment:.center){
                //                Spacer()
                HStack {
                    Text("Version:".localized())
                    Text("\(Helper.shared.getAppVersion())")
                }
                //            Text("Build Number: \(Helper.shared.getBuildNumber())")
            }
            .font(.semiBold(size: 12))
            .foregroundStyle(.whiteA700)
            .padding(.bottom)
        }
        .frame(width: UIScreen.main.bounds.width - 80)
        .padding(.top, 55)
        .background{
            Color.mainBlue.opacity(0.95)
        }
        .onDisappear(perform: {
            selectedDestination = nil
        })
    }
    
}

struct SideMenuSectionTitle: View {
    var title : String
    var backgroundcolor : Color? = Color("StudentBtnBg")
    
    var body: some View {
        HStack {
            Text(title.localized())
                .font(.bold(size: 18))
                .foregroundColor(ColorConstants.WhiteA700)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
        .background(content: {
            backgroundcolor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                .padding(.leading,-20)
        })
    }
}

struct SideMenuButton: View {
    var image : String
    var imagecolor:Color?
    var title : String
    var titleColor : Color?
    var action : () -> ()
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack{
                Image(image)
                    .renderingMode(.template)
                    .foregroundStyle(Color("StudentBtnBg"))
                Text(title.localized())
                    .font(.bold(size: 13))
                    .foregroundStyle(titleColor ?? ColorConstants.WhiteA700)
                Spacer()
            }
            .padding()
        })
    }
}
