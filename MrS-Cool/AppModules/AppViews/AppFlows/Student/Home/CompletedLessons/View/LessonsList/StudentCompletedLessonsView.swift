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
    //    var currentSubject:TeacherSubjectM?
    
    var hasNavBar : Bool? = true
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    
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
                                    })
                            }
                            .padding(.top)
                        }
                        .padding(.horizontal)
                        List(completedlessonsvm.completedLessonsList?.items ?? [], id:\.self) { lesson in
                            StudenCompletedLessonCellView(model: lesson,reviewBtnAction:{
                                completedlessonsvm.GetCompletedLessonDetails(teacherlessonid: lesson.teacherLessonId ?? 0)
                                studenthometabbarvm.destination = AnyView(StudentCompletedLessonDetails().environmentObject(completedlessonsvm))
                                studenthometabbarvm.ispush = true
                            },chatBtnAction: {
                                studenthometabbarvm.destination = AnyView(MessagesListView( selectedLessonId: lesson.bookSessionDetailId ?? 0 ).environmentObject(ChatListVM()))
                                studenthometabbarvm.ispush = true
                                
                            })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                if let totalCount = completedlessonsvm.completedLessonsList?.totalCount, let itemsCount = completedlessonsvm.completedLessonsList?.items?.count, itemsCount < totalCount {
                                    // Load the next page if there are more items to fetch
                                    completedlessonsvm.skipCount += completedlessonsvm.maxResultCount
                                    completedlessonsvm.GetCompletedLessons()
                                }
                            }
                        }
                        .padding(.horizontal,-4)
                        .listStyle(.plain)
                        .frame(minHeight: gr.size.height/2)
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
                lookupsvm.GetSubjestForList()
                completedlessonsvm.GetCompletedLessons()
            })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onDisappear {
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
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        ScrollView{
                            VStack{
                                Group {
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $completedlessonsvm.filtersubject,options:lookupsvm.SubjectsForList)
                                        .onChange(of: completedlessonsvm.filtersubject){newval in
                                            if                                                     lookupsvm.SelectedSubjectForList != completedlessonsvm.filtersubject
                                            {
                                                completedlessonsvm.filterlesson = nil
                                                lookupsvm.SelectedSubjectForList = completedlessonsvm.filtersubject
                                            }
                                        }
                                    
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $completedlessonsvm.filterlesson,options:lookupsvm.LessonsForList)
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $completedlessonsvm.filtergroupName)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$completedlessonsvm.filterdate,datePickerComponent:.date)
                                }.padding(.top,5)
                                
                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            completedlessonsvm .GetCompletedLessons()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            completedlessonsvm.clearFilter()
                                            completedlessonsvm .GetCompletedLessons()
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
            }
        }
        
//        NavigationLink(destination:studenthometabbarvm.destination, isActive: $studenthometabbarvm.ispush, label: {})
    }
}

#Preview {
    StudentCompletedLessonsView()
        .environmentObject(StudentTabBarVM())
//        .environmentObject(LookUpsVM())
//        .environmentObject(StudentCompletedLessonsVM())
    
}
