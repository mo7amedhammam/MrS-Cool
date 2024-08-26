//
//  StudentCompletedLessonsView.swift
//  MrS-Cool
//
//  Created by wecancity on 20/02/2024.
//

import SwiftUI

struct StudentCompletedLessonsView: View {
    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
    @StateObject var lookupsvm = LookUpsVM()
    @StateObject var completedlessonsvm = StudentCompletedLessonsVM()
    
    @State var showFilter : Bool = false
    @State var showRating : Bool = false
    //    var currentSubject:TeacherSubjectM?
    
    var hasNavBar : Bool? = true
    //    @State var isPush = false
    //    @State var destination = AnyView(EmptyView())
    @Binding var selectedChild:ChildrenM?
    
    @State var filtersubject : DropDownOption?
    @State var filterlesson : DropDownOption?
    @State var filtergroupName : String = ""
    @State var filterdate : String?
    
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
            filterdate != nil {
            
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
    func validateFilterValues(){
        if completedlessonsvm.filtersubject != filtersubject {
            filtersubject = nil
            lookupsvm.BookedLessonsForList.removeAll()
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
    
    var body: some View {
        VStack {
            if hasNavBar ?? true{
                CustomTitleBarView(title: "Completed Lessons")
            }
            GeometryReader { gr in
                if Helper.shared.getSelectedUserType() == .Parent && selectedChild == nil{
                    VStack{
                        Text("You Have To Select Child First".localized())
                            .frame(minHeight:gr.size.height)
                            .frame(width: gr.size.width,alignment: .center)
                            .font(.title2)
                            .foregroundColor(ColorConstants.MainColor)
                    }
                }else {
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
                                            validateFilterValues()
                                        })
                                }
                                .padding(.top)
                            }
                            .padding(.horizontal)
                            if let lessons = completedlessonsvm.completedLessonsList?.items{
                                List(lessons, id:\.self) { lesson in
                                    StudenCompletedLessonCellView(model: lesson,reviewBtnAction:{
                                        completedlessonsvm.GetCompletedLessonDetails(teacherlessonid: lesson.teacherLessonId ?? 0)
                                        studenthometabbarvm.destination = AnyView(StudentCompletedLessonDetails().environmentObject(completedlessonsvm))
                                        studenthometabbarvm.ispush = true
                                    },chatBtnAction: {
                                        studenthometabbarvm.destination = AnyView(MessagesListView( selectedLessonId: lesson.bookSessionDetailId ?? 0 ).environmentObject(ChatListVM()))
                                        studenthometabbarvm.ispush = true
                                        
                                    },rateBtnAction:{
                                        completedlessonsvm.selectedLesson = lesson
                                        showRating = true
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
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .task {
            lookupsvm.GetBookedSubjestForList()
        }
//        .onAppear(perform: {
//            //                        let dispatchGroup = DispatchGroup()
//            //                        dispatchGroup.enter()
////            if Helper.shared.getSelectedUserType() == .Student || selectedChild != nil{
////
//////                lookupsvm.GetBookedSubjestForList()
////                completedlessonsvm.completedLessonsList?.items?.removeAll()
////                completedlessonsvm.skipCount = 0
////                completedlessonsvm.GetCompletedLessons()
//                //                        dispatchGroup.leave()
//
//                //            dispatchGroup.notify(queue: .main) {
//                //                // Update the UI when all tasks are complete
//                //                isLoading = false
//                //            }
////            }
//        })
        .onChange(of: studenthometabbarvm.selectedIndex){ value in
            if value == 4 && (Helper.shared.getSelectedUserType() == .Student || selectedChild != nil){
//                let dispatchGroup = DispatchGroup()
//                dispatchGroup.enter()

                completedlessonsvm.skipCount = 0
                completedlessonsvm.completedLessonsList?.items?.removeAll()
                completedlessonsvm.clearFilter()
                completedlessonsvm.GetCompletedLessons()
//                dispatchGroup.leave()

            }
        }
        .onDisappear {
            showFilter = false
            showRating = false
//            completedlessonsvm.clearFilter()
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
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        ScrollView{
                            VStack{
                                Group {
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $filtersubject,options:lookupsvm.BookedSubjectsForList)
                                        .onChange(of: filtersubject){newval in
                                            filterlesson = nil
                                            lookupsvm.SelectedBookedSubjectForList = newval
                                        }
                                    
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $filterlesson,options:lookupsvm.BookedLessonsForList)
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $filtergroupName)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$filterdate,datePickerComponent:.date)
                                }.padding(.top,5)
                                
                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            applyFilter()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            clearFilter()
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
            }else if showRating{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showRating.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showRating){
                    VStack {
                        ColorConstants.Bluegray100
                            .frame(width:50,height:5)
                            .cornerRadius(2.5)
                            .padding(.top,2.5)
                        HStack {
                            Text("Rating".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        //                        ScrollView{
                        VStack{
                            
                            HStack(spacing:20){
                                ForEach(0..<5){ num in
                                    Button(action: {
                                        completedlessonsvm.rate = num+1
                                    }, label: {
                                        Image(systemName: completedlessonsvm.rate>num ? "star.fill":"star")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 45, height: 45, alignment: .center)
                                            .foregroundColor(.yellow)
                                    })
                                }
                            }
                            
                            Spacer()
                            HStack {
                                Group{
                                    CustomButton(Title:"Yes",IsDisabled: .constant(completedlessonsvm.rate == 0), action: {
                                        completedlessonsvm.AddStudentRate()
                                        showRating = false
                                    })
                                    
                                    CustomBorderedButton(Title:"No",IsDisabled: .constant(false), action: {
                                        showRating = false
                                    })
                                } .frame(width:130,height:40)
                                    .padding(.vertical)
                            }
                        }
                        .padding(.horizontal,3)
                        .padding(.top)
                        //                        }
                    }
                    .onDisappear(perform: {
                        completedlessonsvm.rate = 0
                    })
                    .padding()
                    .frame(height:220)
                    .frame(maxWidth:.infinity)
                    .keyboardAdaptive()
                }
            }
        }
        
        //        NavigationLink(destination:studenthometabbarvm.destination, isActive: $studenthometabbarvm.ispush, label: {})
    }
}

#Preview {
    StudentCompletedLessonsView( selectedChild: .constant(nil))
        .environmentObject(StudentTabBarVM())
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(StudentCompletedLessonsVM())
    
}
