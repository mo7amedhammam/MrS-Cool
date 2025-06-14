//
//  TeacherTabBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 11/03/2024.
//

import SwiftUI

enum Teacherdestinations{
    case editProfile,documents,subjects,scheduals,subjectgroup,lessonGroups ,calendar,rates ,changePassword, tickets, signOut, deleteAccount
}
struct TeacherTabBarView: View {
    @StateObject var tabbarvm = StudentTabBarVM()
//    @StateObject var localizeHelper = LocalizeHelper.shared

    @State private var selectedDestination : Teacherdestinations?
    
    private let tabBarItems = [
        TabBarItem(icon: "tab0", selectedicon: "tab0selected", title: ""),
        TabBarItem(icon: "tab1", selectedicon: "tab1selected", title: ""),
        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
        TabBarItem(icon: "tab3", selectedicon: "tab3selected", title: ""),
        TabBarItem(icon: "tab4", selectedicon: "tab4selected", title: "")
    ]
    @StateObject var teacherProfilevm = ManageTeacherProfileVM()

    @State var destination = AnyView(EmptyView())
    
    @State var presentSideMenu = false
    var body: some View {
        //        NavigationView{
        VStack() {
            HStack {
                VStack(alignment: .leading){
                    Group{
                        Text("Hi, ".localized())+Text(teacherProfilevm.name)
                  }
                    .font(Font.bold(size: 18))
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
            
//            switch tabbarvm.selectedIndex {
//                case 0:
//                EmptyView()
//                case 1:
//                TeacherFinanceView()
//                case 2:
//                TeacherHomeView(hasNavBar:false, selectedChild: .constant(nil))
//                    .environmentObject(tabbarvm)
//                case 3:
//                ChatsListView(hasNavBar : false, selectedChild: .constant(nil)) // chats
//                    .environmentObject(tabbarvm)
//                case 4:
//                CompletedLessonsList(hasNavBar : false)
//                    .environmentObject(tabbarvm)
//            default:
//                EmptyView()
//            }
            
            TabView(selection: $tabbarvm.selectedIndex) {
                Text("") // dashboard
                    .tag(0)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
//                    .onAppear(perform: {
//                        presentSideMenu = true
//                    })
                
                TeacherFinanceView() // finance
                    .tag(1)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )

//                TeacherHomeAsAnonymous()
                TeacherHomeView(hasNavBar:false, selectedChild: .constant(nil))
                    .tag(2)
                    .environmentObject(tabbarvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                ChatsListView(hasNavBar : false, selectedChild: .constant(nil)) // chats
                    .tag(3)
                    .environmentObject(tabbarvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                CompletedLessonsList(hasNavBar : false)
                    .tag(4)
                    .environmentObject(tabbarvm)
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
            CustomTabBarView(selectedIndex: $tabbarvm.selectedIndex,tabBarItems:tabBarItems)
            
        }
        .localizeView()
        .disableSwipeBack()
        .task{
            teacherProfilevm.GetTeacherProfile()
        }
        .onChange(of: tabbarvm.selectedIndex){newval in
            guard newval == 0 else {return}
                presentSideMenu = true
        }
//        .task(id: localizeHelper.currentLanguage, {
//            teacherProfilevm.GetTeacherProfile()
//        })
//            .onAppear{
//                Task(priority: .background, operation: {
//                    teacherProfilevm.GetTeacherProfile()
//                })
//            }
//            .onChange(of: localizeHelper.currentLanguage, perform: {_ in
//                Task(priority: .background, operation: {
//                    teacherProfilevm.GetTeacherProfile()
//                })
//            })
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
                    tabbarvm.destination = AnyView(ManageTeacherProfileView().environmentObject(teacherProfilevm))
                    
                }else if newval == .documents{
                    tabbarvm.destination = AnyView(ManageMyDocumentsView( isFinish: .constant(false))
                    )
                    
                }else if newval == .subjects{
                    tabbarvm.destination = AnyView(ManageTeacherSubjectsView()
                    )
                    
                }else if newval == .scheduals{
                    tabbarvm.destination = AnyView(ManageTeacherSchedualsView()
                    )
                    
                }else if newval == .subjectgroup{
                    tabbarvm.destination = AnyView(GroupForLessonView()
                    )
                    
                }else if newval == .lessonGroups{
                    tabbarvm.destination = AnyView(ManageSubjectGroupView()
                    )
                    
                }else if newval == .calendar { //calendar
                    tabbarvm.destination = AnyView(CalView1(selectedChild: .constant(nil))
                    )
                    
                }else if newval == .rates { //calendar
                    tabbarvm.destination = AnyView(TeacherRatesView())
                    
                }else if newval == .changePassword { // change password
                    tabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
//                }else if newval == .tickets { // tickets
                    
                }else if newval == .signOut { // signout
                    //                    tabbarvm.destination =
                    //                   AnyView(SignInView())
                    //                    Helper.shared.changeRoot(toView: SignInView())
                    //                    Helper.shared.logout()
                    tabbarvm.error = .question( image: "MenuSt_signout", message: "Are you sure you want to sign out ?", buttonTitle: "Sign Out", secondButtonTitle: "Cancel", mainBtnAction: {
                        Helper.shared.changeRoot(toView: AnonymousHomeView())
                        Helper.shared.logout()
                    },secondBtnAction:{
                        selectedDestination = nil
                    })
                    tabbarvm.showSignOutConfirm = true
                    
                }else if newval == .deleteAccount{
                    tabbarvm.error = .question( image: "img_subtract", message: "Are you sure you want to Delete Your Account ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                        tabbarvm.deleteAccount()
                    },secondBtnAction:{
                        selectedDestination = nil
                    })
                    tabbarvm.showDeleteConfirm = true
                }
            }
            .showAlert(hasAlert: $tabbarvm.isError, alertType: tabbarvm.error)
            .showAlert(hasAlert: $tabbarvm.showSignOutConfirm, alertType: tabbarvm.error)
            .showAlert(hasAlert: $tabbarvm.showDeleteConfirm, alertType: tabbarvm.error)

        NavigationLink(destination: tabbarvm.destination, isActive: $tabbarvm.ispush, label: {})
            .onChange(of: presentSideMenu, perform: { value in
                if value == false && tabbarvm.selectedIndex == 0{
                    tabbarvm.selectedIndex = 2
                }
            })
        
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(TeacherSideMenuContent(presentSideMenu: $presentSideMenu, selectedDestination: $selectedDestination, isPush: $tabbarvm.ispush).environmentObject(teacherProfilevm)), direction: .leading)
            .localizeView()
            .onDisappear(perform: {
                selectedDestination = nil
            })
    }
}

#Preview{
    TeacherTabBarView()
}

struct TeacherSideMenuContent: View {
    @EnvironmentObject var teacherprofilevm : ManageTeacherProfileVM
    
    @Binding var presentSideMenu: Bool
    @Binding var selectedDestination: Teacherdestinations?
    @Binding var isPush: Bool
    
    var body: some View {
        VStack {
            ScrollView{
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing:20){
                        ZStack(alignment: .topLeading){
                            let imageURL : URL? = URL(string: Constants.baseURL+(teacherprofilevm.imageStr ?? "").reverseSlaches())
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
                            Text(teacherprofilevm.name)
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
                    SideMenuButton(image: "img_group_512380", title: "My Subjects"){
                        selectedDestination = .subjects // calendar
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuButton(image: "img_group58", title: "Manage Subject Groups"){
                        selectedDestination = .lessonGroups // rates
                        presentSideMenu =  false
                        isPush = true
                    }

                    SideMenuButton(image: "img_group58", title: "Manage Lesson Groups"){
                        selectedDestination = .subjectgroup // calendar
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuButton(image: "img_group148", title: "My Schedule"){
                        selectedDestination = .scheduals // rates
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuSectionTitle(title: "My Information")
                    SideMenuButton(image: "MenuSt_calendar", title: "My Documents"){
                        selectedDestination = .documents // calendar
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuSectionTitle(title: "Student Sessions")
                    
//                    SideMenuButton(image: "MenuSt_calendar", title: "Calendar"){
//                        selectedDestination = .calendar // calendar
//                        presentSideMenu =  false
//                        isPush = true
//                    }
                    
                    SideMenuButton(image: "MenuSt_rates", title: "Rates & Reviews"){
                        selectedDestination = .rates // rates
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    SideMenuSectionTitle(title: "Settings")
                    
                    SideMenuButton(image: "MenuSt_lock", title: "Change Password"){
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
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Sign Out-menu"){
                        selectedDestination = .signOut // sign out
                        presentSideMenu =  false
                        //                    isPush = true
                    }
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Delete Account",titleColor: ColorConstants.Red400){
                        selectedDestination = .deleteAccount // delete account
                        presentSideMenu =  false
//                        isPush = true
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

extension View {
    func disableSwipeBack() -> some View {
        self.background(
            DisableSwipeBackView()
        )
    }
}

struct DisableSwipeBackView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DisableSwipeBackViewController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class DisableSwipeBackViewController: UIViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let parent = parent?.parent,
           let navigationController = parent.navigationController,
           let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            navigationController.view.removeGestureRecognizer(interactivePopGestureRecognizer)
        }
    }
}
