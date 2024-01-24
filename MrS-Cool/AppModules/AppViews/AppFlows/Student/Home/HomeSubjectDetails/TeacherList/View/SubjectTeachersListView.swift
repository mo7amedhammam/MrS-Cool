//
//  SubjectTeachersListView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/01/2024.
//


import SwiftUI

struct SubjectTeachersListView: View {
    var selectedsubjectorlessonid : Int
    @StateObject var homesubjectteachersvm = SubjectTeachersListVM()
    
    @State var showFilter : Bool = false
    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    var bookingcase:BookingCases
    
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Subject Info")
            
            VStack (alignment: .leading){
                
                if let teachers = homesubjectteachersvm.TeachersModel{
                    HStack {
                        AsyncImage(url: URL(string: Constants.baseURL+(teachers.items?.first?.getSubjectOrLessonDto?.image ?? "")  )){image in
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
                            Text(teachers.items?.first?.getSubjectOrLessonDto?.headerName ?? "Arabic")
                                .font(.SoraBold(size: 18))
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
                    Text(teachers.items?.first?.getSubjectOrLessonDto?.systemBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
                        .font(.SoraRegular(size: 10))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal,30)
                        .frame(minHeight: 20)
                    
                    GeometryReader { gr in
                        VStack(alignment:.leading){ // (Title - Data - Submit Button)
                            
                            
                            SignUpHeaderTitle(Title:"Teachers")
                                .padding([.top,.horizontal])
                                .foregroundColor(.mainBlue)
                            
                            HStack(){
                                Button(action: {
                                    showSort = true
                                }, label: {
                                    HStack(spacing:0){
                                        Image("sorticonup")
                                        Image("sorticondown")
                                        
                                        Text(homesubjectteachersvm.sortCase?.rawValue.localized() ?? "Sort".localized())
                                            .font(.SoraSemiBold(size: 13))
                                            .padding(.leading,6)
                                    }
                                })
                                .foregroundColor(ColorConstants.MainColor)
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
                            .padding(.horizontal)
                            ScrollView(.vertical,showsIndicators: false){
                                Spacer().frame(height:20)
                                ForEach(teachers.items ?? [SubjectTeacherM.init()],id:\.self){teacher in
                                    TeacherCellView(teacher: teacher)
                                    
                                }
                                
                                
                                Spacer()
                                    .frame(height:50)
                            }
                            .frame(minHeight: gr.size.height)
                        }
                    }
                    
                    .background{
                        ColorConstants.WhiteA700
                            .clipShape(RoundedCorners(topLeft: 25, topRight: 25, bottomLeft: 0, bottomRight: 0))
                            .ignoresSafeArea()
                        
                    }
                    
                    
                }else{
                    
                    
                    Spacer()
                }
                
            }
            .background{
                ColorConstants.ParentDisableBg
                    .ignoresSafeArea()
                
            }
            
            Spacer()
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onAppear(perform: {
            switch bookingcase {
            case .subject:
                homesubjectteachersvm.subjectId = selectedsubjectorlessonid
            case .lesson:
                homesubjectteachersvm.lessonId = selectedsubjectorlessonid
            }
            homesubjectteachersvm.GetStudentSubjectTeachers()
        })
        .onDisappear {
            homesubjectteachersvm.cleanup()
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
    SubjectTeachersListView(selectedsubjectorlessonid: 0, bookingcase: .subject)
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(CompletedLessonsVM())
    
}


struct TeacherCellView : View {
    var teacher : SubjectTeacherM = SubjectTeacherM.init()
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: Constants.baseURL+(teacher.teacherImage ?? "")  )){image in
                image
                    .resizable()
            }placeholder: {
                Image("img_younghappysmi")
                    .resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 72,height: 72)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing:0){
                HStack {
                    Text(teacher.teacherName ?? "teacher name")
                        .font(.SoraSemiBold(size: 13))
                    Spacer()
                    HStack{
                        StarsView(rating: teacher.teacherRate ?? 0.0)
                        if let ratescount = teacher.teacherReview, ratescount > 0{
                        Text(" \(ratescount)")
                            .foregroundColor(ColorConstants.Bluegray30066)
                            .font(Font.SoraRegular(size: 12))
                        }
                    }
                }
                
                Text(teacher.teacherBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
                    .font(.SoraRegular(size: 7))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.leading)
//                    .frame(minHeight: 20)
                    .frame(height:40)
                
                HStack{
                    HStack{
                        Image("img_maskgroup7cl")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                            Text("Duration :".localized())
                            + Text("  \(teacher.duration?.formattedTime() ?? "1:33") ")
                                .font(Font.SoraSemiBold(size: 13))
                            + Text("hrs".localized())
                                .font(Font.SoraSemiBold(size: 13))
                        }
                        .font(Font.SoraRegular(size: 10))
                        .foregroundColor(.mainBlue)
                    }
                    Spacer()
                    HStack{
                        Image("moneyicon")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                            Text("  \(teacher.price ?? 222) ")
                            + Text("EGP".localized())
                        }
                        .font(Font.SoraSemiBold(size: 13))
                        .foregroundColor(ColorConstants.MainColor)
                    }
                }
                
            }
            .foregroundColor(.mainBlue)
            
            Spacer()
        }
        .padding(.vertical)
        .padding(.horizontal,20)
    }
}
