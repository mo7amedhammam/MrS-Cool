//
//  ParentTabBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/03/2024.
//

import SwiftUI

enum Parentdestinations{
    case editProfile,changePassword,signOut, deleteAccount,editStudentProfile,calendar, tickets
}
struct ParentTabBarView: View {
    @StateObject var tabbarvm = StudentTabBarVM()
    @State private var selectedIndex = 2
    @State private var selectedDestination : Parentdestinations?
    
    private let tabBarItems = [
        TabBarItem(icon: "tab0", selectedicon: "tab0selected", title: ""),
        TabBarItem(icon: "tab1", selectedicon: "tab1selected", title: ""),
        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
        TabBarItem(icon: "tab3", selectedicon: "tab3selected", title: ""),
        TabBarItem(icon: "tab4", selectedicon: "tab4selected", title: "")
    ]
    
    @StateObject var parentProfilevm = ParentProfileVM()
    @StateObject var listchildrenvm = ListChildrenVM()

    //    @StateObject var completedlessonsvm = StudentCompletedLessonsVM()
    //    @StateObject var chatListvm = ChatListVM()
    //    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State var presentSideMenu = false
    var body: some View {
        //        NavigationView{
        VStack() {
            HStack {
                VStack(alignment: .leading){
                    Group{
                        Text("Hi, ".localized())+Text(parentProfilevm.name)
                        
                        //                            Text("Lets Start Learning! ".localized())
                        //                                .font(Font.SoraRegular(size: 11))
                        //                                .padding(.vertical,0.5)
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
                
                ListChildrenView() // home
                //                    Text("tab2")
                    .tag(2)
                    .environmentObject(tabbarvm)
                    .environmentObject(listchildrenvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                
//                Text("tab 3")
                ChatsListView(hasNavBar : false) // chats
                    .tag(3)
                    .environmentObject(tabbarvm)
                //                        .environmentObject(chatListvm)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
//                Text("tab4")
                            
                StudentCompletedLessonsView(hasNavBar : false) // completed lessons
                    .tag(4)
                //                        .environmentObject(LookUpsVM())
                //                        .environmentObject(completedlessonsvm)
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
            CustomTabBarView(selectedIndex: $selectedIndex,tabBarItems:tabBarItems)
            
        }
        .onAppear{
            Task(priority: .background, operation: {
            parentProfilevm.GetParentProfile()
            })
        }
        //            .onAppear(perform: {
        //                tabbarvm.destination = AnyView(ManageTeacherProfileView().environmentObject(teacherProfilevm))
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
//                tabbarvm.destination = AnyView(ManageTeacherProfileView().environmentObject(teacherProfilevm))
               
                
                tabbarvm.destination = AnyView(EditParentProfileView().environmentObject(parentProfilevm))
                
            }else if newval == .editStudentProfile{
                tabbarvm.destination = AnyView(StudentEditProfileView().environmentObject(StudentEditProfileVM()))

                
            }else if newval == .calendar { //calendar
                tabbarvm.destination = AnyView(CalView1())
                //                }else if newval == .rates { // rates
                //                    studenttabbarvm.destination = AnyView(Text("Rates"))
                
            }else if newval == .changePassword { // change password
                tabbarvm.destination = AnyView(ChangePasswordView(hideImage: false).environmentObject(ChangePasswordVM()))
            }else if newval == .tickets { // tickets
                
            }else if newval == .signOut { // signout
//                tabbarvm.destination =  AnyView(SignInView())
                Helper.shared.changeRoot(toView: SignInView())

                Helper.shared.IsLoggedIn(value: false)
            }
        }
        //        }
        
//                .showAlert(hasAlert: $tabbarvm.isError, alertType: tabbarvm.error)

        NavigationLink(destination: tabbarvm.destination, isActive: $tabbarvm.ispush, label: {})
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
                            .font(.SoraBold(size: 18))
                            .foregroundStyle(.whiteA700)
                        
                        Text("Edit your profile")
                            .font(.SoraRegular(size: 12))
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

                SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
                    selectedDestination = .changePassword // cahnage Password for child
                    presentSideMenu =  false
                    isPush = true
                }
                SideMenuButton(image: "MenuSt_signout", title: "Sign Out"){
                    selectedDestination = .signOut // sign out
                    presentSideMenu =  false
//                    isPush = true
                }
            
            SideMenuButton(image: "MenuSt_signout", title: "Delete Account",titleColor: ColorConstants.Red400){
                selectedDestination = .deleteAccount // delete account
                presentSideMenu =  false
                isPush = true
            }
                
                if listchildrenvm.selectedChild != nil{
                        HStack(spacing:20){
                            ZStack(alignment: .topLeading){
                                let imageURL : URL? = URL(string: Constants.baseURL+(listchildrenvm.selectedChild?.image ?? "").reverseSlaches())
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
                                Text(listchildrenvm.selectedChild?.name ?? "")
                                    .font(.SoraBold(size: 14))
                                    .foregroundStyle(.whiteA700)
                                
                                Text("Edit your kid profile")
                                    .font(.SoraRegular(size: 12))
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
                    
                    SideMenuButton(image: "MenuSt_calendar", title: "Calendar"){
                        selectedDestination = .calendar // calendar
                        presentSideMenu =  false
                        isPush = true
                    } 
                    .padding(.leading,30)

                    
//                    SideMenuButton(image: "MenuSt_lock", title: "Rates & Reviews"){
//                        selectedDestination = .rates // rates
//                        presentSideMenu =  false
//                        isPush = true
//                    }
                    
                    SideMenuSectionTitle(title: "Settings")
                    
//                    SideMenuButton(image: "MenuSt_rates", title: "Change Password"){
//                        selectedDestination = .changePassword // cahnage Password
//                        presentSideMenu =  false
//                        isPush = true
//                    }
                    
                    SideMenuButton(image: "MenuSt_tickets", title: "Tickets"){
                        selectedDestination = .tickets // Tickets
                        presentSideMenu =  false
                        isPush = true
                    }
                    .padding(.leading,30)

                    
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
