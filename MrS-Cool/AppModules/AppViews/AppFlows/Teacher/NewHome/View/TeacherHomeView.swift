//
//  TeacherHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

import SwiftUI

struct TeacherHomeView: View {
    @EnvironmentObject var tabbarvm : StudentTabBarVM
//    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var SchedualsVm = TeacherHomeVM()
    
    @State var showFilter : Bool = false
    //    var currentSubject:TeacherSubjectM?
    
    var hasNavBar : Bool? = true
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    @State var filterstartdate : String?
    @State var filterenddate : String?

    @State private var ScrollToTop = false

    func applyFilter() {
        SchedualsVm.filterstartdate = filterstartdate
        SchedualsVm.filterenddate = filterenddate

        SchedualsVm.skipCount = 0
        SchedualsVm.GetScheduals()
    }
    func clearFilter() {
       if filterstartdate != nil || filterenddate != nil{
           filterstartdate = nil
           filterenddate = nil
           
           SchedualsVm.skipCount = 0
           SchedualsVm.clearFilter()
           SchedualsVm.GetScheduals()
       }
    }
    func validateFilterValues(){
        
//        if SchedualsVm.filterstartdate != filterstartdate{
//            filterstartdate = nil
//        }

//        if SchedualsVm.filterenddate != filterenddate{
//            filterenddate = nil
//        }
    }
    var body: some View {
        VStack {
//            if hasNavBar ?? true{
//                CustomTitleBarView(title: "Completed Lessons")
//            }
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Scheduals")
                                Spacer()
                                Image("img_maskgroup62_clipped")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(ColorConstants.MainColor)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .onTapGesture(perform: {
                                        showFilter = true
                                        validateFilterValues()
                                    })
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
                        
                        if Helper.shared.getSelectedUserType() == .Teacher{
                        ScrollViewReader{proxy in
                            let scheduals = SchedualsVm.TeacherScheduals?.items ?? []
                            List(scheduals, id:\.self){ schedual in
                                
                                TeacherHomeCellView(model: schedual, cancelBtnAction: {
                                    
                                }, joinBtnAction: {
                                    
                                })

//                                .frame(height: 120)
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .onAppear {
                                    guard schedual == scheduals.last else {return}
                                    
                                    if let totalCount = SchedualsVm.TeacherScheduals?.totalCount, scheduals.count < totalCount {
                                        // Load the next page if there are more items to fetch
                                        SchedualsVm.skipCount += SchedualsVm.maxResultCount
                                        SchedualsVm.GetScheduals()
                                    }
                                }
                                .id(schedual)
                                .onChange(of: ScrollToTop) { value in
                                    if value == true {
                                        withAnimation {
                                            proxy.scrollTo(scheduals.first , anchor: .bottom)
                                        }
                                    }
                                    ScrollToTop = false
                                }
                            }
                            .padding(.horizontal,-4)
                            .listStyle(.plain)
                            .frame(minHeight: gr.size.height/2)
                        }
                        }else{
                            
                        }
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .task {
            SchedualsVm.clearFilter()
            SchedualsVm.GetScheduals()
        }
        
//        .onAppear{
////            let dispatchGroup = DispatchGroup()
////            dispatchGroup.enter()
////            lookupsvm.GetSubjestForList()
////            completedlessonsvm.completedLessonsList?.items?.removeAll()
////            completedlessonsvm.skipCount = 0
////            completedlessonsvm.GetCompletedLessons()
////            dispatchGroup.leave()
//
////            dispatchGroup.notify(queue: .main) {
////                // Update the UI when all tasks are complete
////                isLoading = false
////            }
//
//        }
//        .onChange(of: tabbarvm.selectedIndex){ value in
//            if value == 2{
//                SchedualsVm.clearFilter()
//                SchedualsVm.TeacherScheduals?.items?.removeAll()
//                SchedualsVm.StudentScheduals?.items?.removeAll()
//                SchedualsVm.skipCount = 0
//                SchedualsVm.GetScheduals()
//            }
//        }
        .onDisappear {
            showFilter = false
//            completedlessonsvm.cleanup()
        }
        .showHud(isShowing: $SchedualsVm.isLoading)
        .showAlert(hasAlert: $SchedualsVm.isError, alertType: SchedualsVm.error)
        
        .overlay{
            if showFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showFilter){
                    VStack {
                        ColorConstants.Bluegray100
                            .frame(width:50,height:5)
                            .cornerRadius(2.5)
                            .padding(.top,2.5)
                        HStack {
                            Text("Filter".localized())
                                .font(Font.bold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        ScrollView{
                            VStack{
                                Group {
//                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $filtersubject,options:lookupsvm.SubjectsForList)
//                                        .onChange(of: filtersubject){newval in
////                                            if                                                     lookupsvm.SelectedSubjectForList != completedlessonsvm.filtersubject
////                                            {
//                                                filterlesson = nil
//                                                lookupsvm.SelectedSubjectForList = newval
////                                            }
//                                        }
                                    
//                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $filterlesson,options:lookupsvm.LessonsForList)
                                    
//                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $filtergroupName)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$filterstartdate,datePickerComponent:.date)
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$filterenddate,datePickerComponent:.date)

                                }.padding(.top,5)
                                
                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            applyFilter()
                                            ScrollToTop = true
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            clearFilter()
                                            ScrollToTop = true
                                            showFilter = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                            }
                            .padding(.horizontal,3)
                            .padding(.top)
                        }
                    }
                    .padding()
                    .frame(height:300)
                    .keyboardAdaptive()
                }
//                .onAppear(perform: {
//                    lookupsvm.SelectedSubjectForList = nil
//                })
            }
        }
        
//        if hasNavBar ?? true{
//            NavigationLink(destination: destination, isActive: $isPush, label: {})
//        }
    }
}

#Preview {
    TeacherHomeView()
        .environmentObject(StudentTabBarVM())
//        .environmentObject(CompletedLessonsVM())
    
}
