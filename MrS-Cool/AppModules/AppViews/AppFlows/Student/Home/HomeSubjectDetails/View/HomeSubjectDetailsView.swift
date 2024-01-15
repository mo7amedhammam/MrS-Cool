//
//  HomeSubjectDetailsView.swift
//  MrS-Cool
//
//  Created by wecancity on 15/01/2024.
//

import SwiftUI

struct HomeSubjectDetailsView: View {
    //        @Environment(\.dismiss) var dismiss
    var selectedsubjectid : Int
    @StateObject var homesubjectdetailsvm = HomeSubjectDetailsVM()
    
    @State var showFilter : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Subject Info")
            
            VStack (alignment: .leading){
                
                if let details = homesubjectdetailsvm.StudentSubjectDetails{
                    HStack {
                        AsyncImage(url: URL(string: Constants.baseURL+(details.image ?? "")  )){image in
                            image
                                .resizable()
                        }placeholder: {
                            Image("img_younghappysmi")
                                .resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60,height: 60)
                        .clipShape(Circle())
                        
                        VStack{
                            Text(details.name ?? "Arabic")
                                .font(.SoraBold(size: 18))
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
                    Text(details.systemBrief ?? "brief")
                        .font(.SoraRegular(size: 10))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal,30)
                        .frame(minHeight: 20)
                
                GeometryReader { gr in
                    VStack{ // (Title - Data - Submit Button)
                        
                        HStack(){
                            SignUpHeaderTitle(Title:"Subject Content",subTitleView: AnyView(
                                Text("\(details.getSubjectLessonsDetailsDtoList?.count ?? 2)") +
                                Text(" units .".localized()) +
                                Text(" \(details.lessonsCount ?? 25) ") +
                                Text("Lessons".localized())))
                            .foregroundColor(.mainBlue)
                            .font(.SoraRegular(size: 10))
                            
                            Spacer()
//                            Image("img_maskgroup62_clipped")
//                                .resizable()
//                                .renderingMode(.template)
//                                .foregroundColor(ColorConstants.MainColor)
//                                .frame(width: 25, height: 25, alignment: .center)
//                                .onTapGesture(perform: {
//                                    showFilter = true
//                                })
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        ScrollView(.vertical,showsIndicators: false){
                            
                            //                        List(completedlessonsvm.completedLessonsList?.items ?? [], id:\.self) { lesson in
                            //
                            //                            CompletedLessonCell(model: lesson,reviewBtnAction: {
                            //                                completedlessonsvm.selectedLessonid = lesson.teacherLessonSessionSchedualSlotID
                            //                                destination = AnyView(CompletedLessonDetails().environmentObject(completedlessonsvm))
                            //
                            //                                isPush = true
                            //                            })
                            //                            .listRowSpacing(0)
                            //                            .listRowSeparator(.hidden)
                            //                            .listRowBackground(Color.clear)
                            //                            .onAppear {
                            //                                if let totalCount = completedlessonsvm.completedLessonsList?.totalCount, let itemsCount = completedlessonsvm.completedLessonsList?.items?.count, itemsCount < totalCount {
                            //                                    // Load the next page if there are more items to fetch
                            //                                    completedlessonsvm.skipCount += completedlessonsvm.maxResultCount
                            //                                    completedlessonsvm.GetCompletedLessons()
                            //                                }
                            //                            }
                            //                        }
                            //                        .padding(.horizontal,-4)
                            //                        .listStyle(.plain)
                            //                        .frame(minHeight: gr.size.height/2)
                            
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
                    
                }
                
                .background{
                    ColorConstants.WhiteA700
                        .clipShape(RoundedCorners(topLeft: 25, topRight: 25, bottomLeft: 0, bottomRight: 0))
                        .ignoresSafeArea()
                    
                }
                
                .onAppear(perform: {
                    homesubjectdetailsvm.SelectedStudentSubjectId = selectedsubjectid
                    homesubjectdetailsvm.GetStudentSubjectDetails()
                })
                }

            }
            .background{
                ColorConstants.ParentDisableBg
                    .ignoresSafeArea()
                
            }
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onDisappear {
            homesubjectdetailsvm.cleanup()
        }
        //        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        //        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
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
                        //                        ScrollView{
                        //                            VStack{
                        //                                Group {
                        //                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $completedlessonsvm.filtersubject,options:homesubjectdetailsvm.SubjectsForList)
                        //                                        .onChange(of: completedlessonsvm.filtersubject){newval in
                        //                                            if                                                     homesubjectdetailsvm.SelectedSubjectForList != completedlessonsvm.filtersubject
                        //                                            {
                        //                                                completedlessonsvm.filterlesson = nil
                        //                                                homesubjectdetailsvm.SelectedSubjectForList = completedlessonsvm.filtersubject
                        //                                            }
                        //                                        }
                        //
                        //                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $completedlessonsvm.filterlesson,options:homesubjectdetailsvm.LessonsForList)
                        //
                        //                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $completedlessonsvm.filtergroupName)
                        //
                        //                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$completedlessonsvm.filterdate,datePickerComponent:.date)
                        //                                }.padding(.top,5)
                        //
                        //                                Spacer()
                        //                                HStack {
                        //                                    Group{
                        //                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                        //                                            completedlessonsvm .GetCompletedLessons()
                        //                                            showFilter = false
                        //                                        })
                        //
                        //                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                        //                                            completedlessonsvm.clearFilter()
                        //                                            completedlessonsvm .GetCompletedLessons()
                        //                                            showFilter = false
                        //                                        })
                        //                                    } .frame(width:130,height:40)
                        //                                        .padding(.vertical)
                        //                                }
                        //                            }
                        //                            .padding(.horizontal,3)
                        //                            .padding(.top)
                        //                        }
                    }
                    .padding()
                    .frame(height:430)
                    .keyboardAdaptive()
                }
            }
        }
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    HomeSubjectDetailsView(selectedsubjectid: 0)
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(CompletedLessonsVM())
    
}
