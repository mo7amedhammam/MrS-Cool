//
//  CompletedLessonsList.swift
//  MrS-Cool
//
//  Created by wecancity on 12/12/2023.
//

import SwiftUI

struct CompletedLessonsList: View {
    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var completedlessonsvm = CompletedLessonsVM()
    
    @State var showFilter : Bool = false
    //    var currentSubject:TeacherSubjectM?
    
    var hasNavBar : Bool? = true
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    @State var filtersubject : DropDownOption?
    @State var filterlesson : DropDownOption?
    @State var filtergroupName : String = ""
    @State var filterdate : String?
    @State private var ScrollToTop = false

    func applyFilter() {
        completedlessonsvm.filtersubject = filtersubject
        completedlessonsvm.filterlesson = filterlesson
        completedlessonsvm.filtergroupName = filtergroupName
        completedlessonsvm.filterdate = filterdate

        completedlessonsvm.skipCount = 0
        completedlessonsvm.GetCompletedLessons()
    }
    func clearFilter() {
       if filtersubject != nil ||
        filterlesson != nil ||
        filtergroupName != "" ||
            filterdate != nil{
           
           filtersubject = nil
           filterlesson = nil
           filtergroupName = ""
          filterdate = nil
           
           completedlessonsvm.skipCount = 0
           completedlessonsvm.clearFilter()
           lookupsvm.BookedLessonsForList.removeAll()
           completedlessonsvm.GetCompletedLessons()
       }
    }
    func validateFilterValues() async{
       if completedlessonsvm.filtersubject == nil {
           filtersubject = nil
           lookupsvm.BookedLessonsForList.removeAll()
           lookupsvm.AllLessonsForList.removeAll()
       }else {
           filtersubject = completedlessonsvm.filtersubject
//           lookupsvm.SelectedSubjectForList = completedlessonsvm.filtersubject
//           lookupsvm.GetAllLessonsForList(id: filtersubject?.id ?? 0)
           await fetchlessons(id:filtersubject?.id ?? 0)
       }
        
        if completedlessonsvm.filterlesson != filterlesson{
            filterlesson = nil
        }
        if completedlessonsvm.filtergroupName != filtergroupName{
            filtergroupName = ""
        }
        if completedlessonsvm.filterdate != filterdate{
            filterdate = nil
        }
    }
    
    @MainActor
    private func fetchlessons(id:Int)async{
        await lookupsvm.GetAllLessonsForList(id: id)
    }
    
    var body: some View {
        VStack {
            if hasNavBar ?? true{
                CustomTitleBarView(title: "Completed Lessons")
            }
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Completed Lessons")
                                Spacer()
                                Image("img_maskgroup62_clipped")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(ColorConstants.MainColor)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .onTapGesture(perform: {
                                        showFilter = true
                                        Task {
                                         await validateFilterValues()
                                        }
                                    })
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
                        
                        let lessons = completedlessonsvm.completedLessonsList?.items ?? []
                        ScrollViewReader{proxy in
                        List(lessons, id:\.self){ lesson in
                            CompletedLessonCell(model: lesson,reviewBtnAction: {
                                completedlessonsvm.selectedLessonid = lesson.teacherLessonSessionSchedualSlotID
                                //                                if hasNavBar ?? true{
                                //
                                //                                    destination = AnyView(CompletedLessonDetails().environmentObject(completedlessonsvm))
                                //                                    isPush = true
                                //                                }else{
                                tabbarvm.destination = AnyView(CompletedLessonDetails().environmentObject(completedlessonsvm))
                                tabbarvm.ispush = true
                                
                                //                                }
                            })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                guard lesson == lessons.last else {return}
                                
                                if let totalCount = completedlessonsvm.completedLessonsList?.totalCount, lessons.count < totalCount {
                                    // Load the next page if there are more items to fetch
                                    completedlessonsvm.skipCount += completedlessonsvm.maxResultCount
                                    completedlessonsvm.GetCompletedLessons()
                                }
                            }
                            .id(lesson)
                            .onChange(of: ScrollToTop) { value in
                                if value == true {
                                    withAnimation {
                                        proxy.scrollTo(lessons.first , anchor: .bottom)
                                    }
                                }
                                ScrollToTop = false
                            }
                        }
                        .padding(.horizontal,-4)
                        .listStyle(.plain)
                        .frame(minHeight: gr.size.height/2)
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
            lookupsvm.GetSubjestForList()
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
        .onChange(of: tabbarvm.selectedIndex){ value in
            if value == 4{
                completedlessonsvm.clearFilter()
                completedlessonsvm.completedLessonsList?.items?.removeAll()
                completedlessonsvm.skipCount = 0
                completedlessonsvm.GetCompletedLessons()
            }
        }
        .onDisappear {
            showFilter = false
//            completedlessonsvm.cleanup()
        }
        .showHud(isShowing: $completedlessonsvm.isLoading)
        .showAlert(hasAlert: $completedlessonsvm.isError, alertType: completedlessonsvm.error)
        
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
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $filtersubject,options:lookupsvm.SubjectsForList)
                                        .onChange(of: filtersubject){newval in
                                            guard let newval = newval,let id = newval.id else {return}
//                                            if                                                     lookupsvm.SelectedSubjectForList != completedlessonsvm.filtersubject
//                                            {
                                                filterlesson = nil
//                                                lookupsvm.SelectedSubjectForList = newval
                                            Task{
                                                await fetchlessons(id: id)
                                                //                                            if let id = newval.id{
                                                //                                                lookupsvm.GetAllLessonsForList(id: id)
                                                //                                            }
                                                //                                            }
                                            }
                                        }
                                    
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $filterlesson,options:lookupsvm.AllLessonsForList)
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $filtergroupName)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$filterdate,datePickerComponent:.date)
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
                    .frame(height:430)
                    .keyboardAdaptive()
                }
//                .onAppear(perform: {
////                    lookupsvm.SelectedSubjectForList = nil
////                    lookupsvm.AllLessonsForList.removeAll()
//                })
            }
        }
        
//        if hasNavBar ?? true{
//            NavigationLink(destination: destination, isActive: $isPush, label: {})
//        }
    }
}

#Preview {
    CompletedLessonsList()
        .environmentObject(StudentTabBarVM())
//        .environmentObject(CompletedLessonsVM())
    
}
