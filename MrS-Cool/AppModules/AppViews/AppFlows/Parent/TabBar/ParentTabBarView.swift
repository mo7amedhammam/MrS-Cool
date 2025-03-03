//
//  ParentTabBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/03/2024.
//

import SwiftUI

enum Parentdestinations{
    case editProfile,changePassword,signOut, deleteAccount,editStudentProfile,calendar, schedualsList, tickets
}
struct ParentTabBarView: View {
    @StateObject var tabbarvm = StudentTabBarVM()
//    @StateObject var localizeHelper = LocalizeHelper.shared
    @State private var selectedDestination : Parentdestinations?
    
    private let tabBarItems = [
//        TabBarItem(icon: "tab0", selectedicon: "tab0selected", title: ""),
        TabBarItem(icon: "newtab0", selectedicon: "newtab0selected", title: ""),
        TabBarItem(icon: "tab1", selectedicon: "tab1selected", title: ""),
        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
        TabBarItem(icon: "tab3", selectedicon: "tab3selected", title: ""),
        TabBarItem(icon: "tab4", selectedicon: "tab4selected", title: "")
    ]
    @StateObject var parentProfilevm = ParentProfileVM()
    @StateObject var listchildrenvm = ListChildrenVM()
    @State var destination = AnyView(EmptyView())
    @State var presentSideMenu = false
    var body: some View {
        //        NavigationView{
        VStack(spacing:0) {
            HStack {
                VStack(alignment: .leading){
                    Group{
                        Text("Hi, ".localized())+Text(parentProfilevm.name)
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
            
            TabView(selection: $tabbarvm.selectedIndex){
                //                    StudentHomeView()
//                Text("") // dashboard
                TeacherHomeView(hasNavBar:false,selectedChild: $listchildrenvm.selectedChild)
                    .environmentObject(StudentEditProfileVM())
                    .gesture(DragGesture().onChanged { _ in })
//                    .padding(.top, 20)

                    .tag(0)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
//                    .onAppear(perform: {
//                        presentSideMenu = true
//                    })
                
                StudentFinanceView(selectedChild:$listchildrenvm.selectedChild) // finance
                    .tag(1)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
//                    .padding(.top, 20)

                
                ListChildrenView() // home
                    .tag(2)
                    .environmentObject(tabbarvm)
                    .environmentObject(listchildrenvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
//                    .padding(.top, 20)

                
                ChatsListView(hasNavBar : false,selectedChild:$listchildrenvm.selectedChild) // chats
                    .tag(3)
                    .environmentObject(tabbarvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
//                    .padding(.top, 20)

                
                StudentCompletedLessonsView(hasNavBar : false,selectedChild:$listchildrenvm.selectedChild) // completed lessons
                    .tag(4)
                    .environmentObject(tabbarvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
//                    .padding(.top, 20)

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .padding(.top,-8)
            .padding(.bottom,-15)
            
            Spacer()
            CustomTabBarView(selectedIndex: $tabbarvm.selectedIndex,tabBarItems:tabBarItems)
            
        }
        .localizeView()
        .task {
            parentProfilevm.GetParentProfile()
        }
//        .onChange(of: tabbarvm.selectedIndex){newval in
//            guard newval == 0 else {return}
//                presentSideMenu = true
//        }
//        .task(id: localizeHelper.currentLanguage, {
//            parentProfilevm.GetParentProfile()
//            listchildrenvm.GetMyChildren()
//        })
//        .onAppear{
//            Task(priority: .background, operation: {
//                parentProfilevm.GetParentProfile()
//            })
//        }
//        .onChange(of: localizeHelper.currentLanguage, perform: {_ in
//            Task(priority: .background, operation: {
//                parentProfilevm.GetParentProfile()
//            })
//        })

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
                
                tabbarvm.destination = AnyView(EditParentProfileView().environmentObject(parentProfilevm))
                
            }else if newval == .editStudentProfile{
                tabbarvm.destination = AnyView(StudentEditProfileView().environmentObject(StudentEditProfileVM()))
                
                
            }else if newval == .calendar { //calendar
                tabbarvm.destination = AnyView(CalView1(selectedChild: $listchildrenvm.selectedChild))
                
            }else if newval == .schedualsList{
               

                tabbarvm.destination = AnyView( TeacherHomeView(hasNavBar:true,selectedChild: $listchildrenvm.selectedChild)
                    .environmentObject(StudentEditProfileVM()))
                
            }else if newval == .changePassword { // change password
                tabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
//            }else if newval == .tickets { // tickets
                
            }else if newval == .signOut { // signout
                
                tabbarvm.error = .question( image: "MenuSt_signout", message: "Are you sure you want to sign out ?", buttonTitle: "Sign Out", secondButtonTitle: "Cancel", mainBtnAction: {
                    listchildrenvm.selectedChild = nil
                    Helper.shared.selectedchild = nil
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
        
//            .onChange(of: presentSideMenu, perform: { value in
//                if value == false && tabbarvm.selectedIndex == 0{
//                    tabbarvm.selectedIndex = 2
//                }
//            })
        
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(ParentSideMenuContent(presentSideMenu: $presentSideMenu, selectedDestination: $selectedDestination, isPush: $tabbarvm.ispush).environmentObject(parentProfilevm)                    .environmentObject(listchildrenvm)), direction: .leading)
            .onDisappear(perform: {
                selectedDestination = nil
            })
    }
}

#Preview{
    ParentTabBarView()
}

struct ParentSideMenuContent: View {
    @EnvironmentObject var parentprofilevm : ParentProfileVM
    @EnvironmentObject var listchildrenvm : ListChildrenVM
    
    @Binding var presentSideMenu: Bool
    @Binding var selectedDestination: Parentdestinations?
    @Binding var isPush: Bool
    
    var body: some View {
        VStack {
            ScrollView{
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing:20){
                        ZStack(alignment: .topLeading){
                            let imageURL : URL? = URL(string: Constants.baseURL+(parentprofilevm.imageStr ?? "").reverseSlaches())
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
                            Text(parentprofilevm.name)
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
                    
                    SideMenuSectionTitle(title: "My Information",backgroundcolor:Color.parentBtnBg)
                    
                    SideMenuButton(image: "MenuSt_lock", title: "Change Password"){
                        selectedDestination = .changePassword // cahnage Password for child
                        presentSideMenu =  false
                        isPush = true
                    }
                    
                    ChangeLanguage()
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Sign Out-menu"){
                        selectedDestination = .signOut // sign out
                        presentSideMenu =  false
                        //                    isPush = true
                    }
                    
                    SideMenuButton(image: "MenuSt_signout", title: "Delete Account",titleColor: ColorConstants.Red400){
                        selectedDestination = .deleteAccount // delete account
                        presentSideMenu =  false
                    }
                    
                    if Helper.shared.selectedchild != nil{
                        HStack(spacing:20){
                            ZStack(alignment: .topLeading){
                                let imageURL : URL? = URL(string: Constants.baseURL+(Helper.shared.selectedchild?.image ?? "").reverseSlaches())
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
                                Text(Helper.shared.selectedchild?.name ?? "")
                                    .font(.bold(size: 14))
                                    .foregroundStyle(.whiteA700)
                                
                                Text("Edit your kid profile".localized())
                                    .font(.regular(size: 12))
                                    .foregroundStyle(.whiteA700)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading,30)
                        .padding()
                        .onTapGesture {
                            selectedDestination = .editStudentProfile // for child
                            presentSideMenu =  false
                            isPush = true
                        }
                        
                        //                        SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
                        //                            selectedDestination = .changePassword // cahnage Password for child
                        //                            presentSideMenu =  false
                        //                            isPush = true
                        //                        }
                        //                        SideMenuButton(image: "MenuSt_signout", title: "Sign Out"){
                        ////                            selectedDestination = .signOut // sign out for child
                        //                            listchildrenvm.selectedChild = nil
                        //                            presentSideMenu =  false
                        ////                            isPush = true
                        //                        }
                        
                        
                        
                        SideMenuSectionTitle(title: "Academic")
                        
//                        SideMenuButton(image: "MenuSt_calendar", title: "Calendar"){
//                            selectedDestination = .calendar // calendar
//                            presentSideMenu =  false
//                            isPush = true
//                        }
//                        .padding(.leading,30)
                        
                        SideMenuButton(image: "checkoutcaltime", title: "Schedual List"){
                            selectedDestination = .schedualsList // rates
                            presentSideMenu =  false
                            isPush = true
                        }
                        .padding(.leading,30)

                        
                        //                    SideMenuButton(image: "MenuSt_lock", title: "Rates & Reviews"){
                        //                        selectedDestination = .rates // rates
                        //                        presentSideMenu =  false
                        //                        isPush = true
                        //                    }
                        
//                        SideMenuSectionTitle(title: "Settings")
                        
                        //                    SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
                        //                        selectedDestination = .changePassword // cahnage Password
                        //                        presentSideMenu =  false
                        //                        isPush = true
                        //                    }
                        
    //                    SideMenuButton(image: "MenuSt_tickets", title: "Tickets"){
    //                        selectedDestination = .tickets // Tickets
    //                        presentSideMenu =  false
    //                        isPush = true
    //                    }
    //                    .padding(.leading,30)
                        
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
