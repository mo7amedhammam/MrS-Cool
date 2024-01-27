//
//  SubjectDetailsView.swift
//  MrS-Cool
//
//  Created by wecancity on 27/01/2024.
//

import SwiftUI

struct SubjectDetailsView: View {
    var selectedsubjectorlessonid : Int
    @StateObject var homesubjectteachersvm = SubjectTeachersListVM()
    
    @State var showFilter : Bool = false
    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    var bookingcase:BookingCases
    
    @State private var isNameVisible = false
    @State private var isPriceVisible = false
    @State private var isRateVisible = false
    @State private var isGenderVisible = false
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
                        VStack(alignment:.leading){ // Title - Data - Submit Button)
                            
                            ScrollView(.vertical,showsIndicators: false){
                                Spacer().frame(height:20)
                                
                                HStack {
                                    Text("Teacher Info".localized())
                                        .font(.SoraBold(size: 18))
                                        .foregroundColor(ColorConstants.WhiteA700)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(height: 45)
                                .padding(.horizontal)
                                .background(content: {
                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                                })
                                
                                TeacherInfoView()
                                
                                HStack {
                                    Text("Group Booking".localized())
                                        .font(.SoraBold(size: 18))
                                        .foregroundColor(ColorConstants.WhiteA700)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(height: 45)
                                .padding(.horizontal)
                                .background(content: {
                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                                })
                                
                                
                                CustomButton(Title:"Book Now",IsDisabled:.constant(false) , action: {
                                    //                                        destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: selectedsubjectid, bookingcase: .subject))
                                    //                                        isPush = true
                                    
                                })
                                .frame(height: 40)
                                .padding(.top,10)
                                .padding(.horizontal)
                                
                                
                                Spacer()
                                    .frame(height:50)
                            }
                            .padding(.horizontal)
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
        
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    SubjectDetailsView(selectedsubjectorlessonid: 0, bookingcase: .subject)
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(CompletedLessonsVM())
}


struct TeacherInfoView : View {
    var teacher : SubjectTeacherM = SubjectTeacherM.init()
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: Constants.baseURL+(teacher.teacherImage ?? "")  )){image in
                image
                    .resizable()
            }placeholder: {
                Image("img_younghappysmi")
                    .resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 115,height: 115)
            .clipShape(Circle())
            
            VStack(alignment: .center, spacing:0){
                //                VStack {
                Text(teacher.teacherName ?? "teacher name")
                    .font(.SoraBold(size: 20))
                //                    Spacer()
                
                Text(teacher.teacherBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
                    .font(.SoraRegular(size: 9))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,30)
                    .frame(minHeight:40)
                    .padding(8)
                
                HStack{
                    StarsView(rating: teacher.teacherRate ?? 0.0)
                    Text("\(teacher.teacherRate ?? 0,specifier: "%.1f")")
                        .foregroundColor(ColorConstants.Black900)
                        .font(.SoraSemiBold(size: 13))
                }
                
//                if let ratescount = teacher.teacherReview, ratescount > 0{
                    Group{
                        Text("\(teacher.teacherReview ?? 0) ")
                        + Text("Reviews")
                    }
                    .foregroundColor(ColorConstants.Black900)
                    .font(.SoraRegular(size: 12))
//                }
                
                HStack(spacing: 0){
                    Image("moneyicon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(ColorConstants.MainColor )
                        .frame(width: 20,height: 20, alignment: .center)
                    Group {
                        Text("  \(teacher.price ?? 222) ")
                        + Text("EGP".localized())
                    }
                    .font(Font.SoraBold(size: 18))
                    .foregroundColor(ColorConstants.MainColor)
                }.padding(7)
                
                ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                
                VStack(alignment:.leading){
                     Text("Subject Breif:".localized())
                .font(Font.SoraSemiBold(size: 13))
                .foregroundColor(.mainBlue)

                    Text(teacher.teacherBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
                        .font(.SoraRegular(size: 9))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight:40)
                        .padding(.bottom,8)
                    
                    HStack{
                        HStack(){
                            Image("img_maskgroup7cl")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor)
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
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        
                        HStack{
                            Image("groupstudentsicon")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor )
                                .frame(width: 12,height: 12, alignment: .center)
                            Group {
                                Text("Minimum :".localized())
                                + Text("  \(teacher.duration?.formattedTime() ?? "13") ")
                                    .font(Font.SoraSemiBold(size: 13))
                            }
                            .font(Font.SoraRegular(size: 10))
                            .foregroundColor(.mainBlue)
                            Spacer()

                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    
                    HStack{
                        HStack{
                            Image("openningBookicon")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor )
                                .frame(width: 12,height: 12, alignment: .center)
                            Group {
                                Text("Lessons :".localized())
                                + Text("  \(teacher.duration?.formattedTime() ?? "1:33") ")
                                    .font(Font.SoraSemiBold(size: 13))
                                + Text("hrs".localized())
                                    .font(Font.SoraSemiBold(size: 13))
                            }
                            .font(Font.SoraRegular(size: 10))
                            .foregroundColor(.mainBlue)
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        
                        HStack{
                            Image("groupstudentsicon")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor )
                                .frame(width: 12,height: 12, alignment: .center)
                            Group {
                                Text("Maximum :".localized())
                                + Text("  \(teacher.duration?.formattedTime() ?? "35") ")
                                    .font(Font.SoraSemiBold(size: 13))
                            }
                            .font(Font.SoraRegular(size: 10))
                            .foregroundColor(.mainBlue)
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    
                }
                .padding()
            }
            .foregroundColor(.mainBlue)
            
        }
        .padding(.vertical)
    }
}

#Preview {
    TeacherInfoView(teacher: SubjectTeacherM.init())
}


