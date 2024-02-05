//
//  SubjectDetailsView.swift
//  MrS-Cool
//
//  Created by wecancity on 27/01/2024.
//

import SwiftUI

struct SubjectDetailsView: View {
    var selectedsubjectid : Int
    @StateObject var subjectdetailsvm = SubjectDetailsVM()
    
    @State var showFilter : Bool = false
    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    //    var bookingcase:BookingCases
    
    @State private var isNameVisible = false
    @State private var isPriceVisible = false
    @State private var isRateVisible = false
    @State private var isGenderVisible = false
    
    @State private var currentPage = 0
    @State private var forwards = false
//    let images = ["tab0", "tab1", "tab2", "tab3"] // Replace with your image names
    
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Subject Info")
            
            VStack (alignment: .leading){
                
                if let details = subjectdetailsvm.subjectDetails{
                    HStack {
                        AsyncImage(url: URL(string: Constants.baseURL+(details.SubjectOrLessonDto?.image ?? "")  )){image in
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
                            Text(details.SubjectOrLessonDto?.headerName ?? "subjectname")
                                .font(.SoraBold(size: 18))
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
                    Text(details.SubjectOrLessonDto?.systemBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
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
                                
                                SubjectTeacherInfoView(teacher: details)
                                
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
                                
                                HStack {
                                    Button(action: {
                                        forwards = true
                                        withAnimation {
                                            currentPage = min(currentPage + 1, (details.SubjectGroups?.count ?? 0) - 1)
                                        }
                                    }) {
                                        Image(currentPage >= 0 && currentPage < (details.SubjectGroups?.count ?? 0) - 1 ? "nextfill":"nextempty")
                                            .resizable()
                                            .frame(width:30,height:30)
                                    }
                                    .padding()
                                    .buttonStyle(.plain)
                                    
                                    Spacer()
                                    
                                    let isselected = subjectdetailsvm.selectedSubjectId == details.SubjectGroups?[currentPage].teacherLessonSessionID
                                        VStack(alignment:.leading){
                                            HStack {
                                                ZStack{
                                                    Image("circleempty")
                                                    Image("img_line1")
                                                        .renderingMode(.template)
                                                            .foregroundColor(isselected ? ColorConstants.MainColor:.clear)
                                                    }
                                                    .offset(x:-40)
                                                Text(details.SubjectGroups?[currentPage].groupName ?? "group 1")
                                                    .font(.SoraBold(size: 18))
                                                    .foregroundColor(isselected ? ColorConstants.WhiteA700:ColorConstants.MainColor)
                                            }
                                            .frame(width:170,height: 45)
                                            .padding(.horizontal)
                                            .background(content: {
                                                if isselected {
                                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight])) }else{
                                                        Color.clear.borderRadius(ColorConstants.MainColor, width: 1.5, cornerRadius: 15, corners: [.topLeft, .topRight])
                                                        
                                                    }
                                            })
                                            Group{
                                            Label(title: {
                                                Group {
                                                    Text("Start Date".localized())+Text(details.SubjectGroups?[currentPage].startDate ?? "15 Nov 2023")
                                                }
                                                .font(.SoraRegular(size: 10))
                                                .foregroundColor(.mainBlue)
                                            }, icon: {
                                                Image("calvector")
                                                    .resizable()
                                                    .frame(width:15,height:15)
                                            })
                                            
                                            Label(title: {
                                                Group {
                                                    Text("End Date".localized())+Text(details.SubjectGroups?[currentPage].startDate ?? "15 Nov 2023")
                                                }
                                                .font(.SoraRegular(size: 10))
                                                .foregroundColor(.mainBlue)
                                            }, icon: {
                                                Image("calvector")
                                                    .resizable()
                                                    .frame(width:15,height:15)
                                            })
                                            
                                            ForEach (details.SubjectGroups?[currentPage].getSubjectScheduleGroups ?? [],id:\.self){ schedual in
                                                Label(title: {
                                                    Group {
                                                        Text(schedual.dayName ?? "sunday" )+Text(schedual.fromTime ?? "1:20 am")
                                                    }
                                                    .font(.SoraRegular(size: 10))
                                                    .foregroundColor(.mainBlue)
                                                }, icon: {
                                                    Image("calvector")
                                                        .resizable()
                                                        .frame(width:15,height:15)
                                                })
                                                .padding(.top,8)
                                            }
                                        }
                                            .padding(.top,8)
                                            .padding(.horizontal)

                                        }
                                        .padding(.bottom)
                                        .background(content: {
                                            ColorConstants.ParentDisableBg.opacity(0.5).clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                        })
                                        .onTapGesture(perform: {
                                            subjectdetailsvm.selectedSubjectId = details.SubjectGroups?[currentPage].teacherLessonSessionID
                                        })
                                    
                                    .transition(
                                        .asymmetric(
                                            insertion: .move(edge: forwards ? .trailing : .leading),
                                            removal: .move(edge: forwards ? .leading : .trailing)
                                        )
                                    )
                                    .id(UUID())
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        forwards = false
                                        withAnimation {
                                            currentPage = max(currentPage - 1, 0)
                                        }
                                    }) {
                                        Image((currentPage > 0 && currentPage <= (details.SubjectGroups?.count ?? 0) - 1) ? "prevfill":"prevempty")
                                            .resizable()
                                            .frame(width:30,height:30)
                                    }
                                    .padding()
                                    .buttonStyle(.plain)
                                }
                                .padding(.vertical)
                                .frame(width: gr.size.width-50)

                                CustomButton(Title:"Book Now",IsDisabled:.constant(false) , action: {
                                    destination = AnyView(BookingCheckoutView(selectedid: subjectdetailsvm.selectedSubjectId ?? 0, bookingcase: nil))
                                    isPush = true

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
            subjectdetailsvm.GetSubjectDetails(subjectId: selectedsubjectid)
        })
        .onDisappear {
            subjectdetailsvm.cleanup()
        }
        //        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        //        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    SubjectDetailsView(selectedsubjectid: 0)
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(CompletedLessonsVM())
}

struct SubjectTeacherInfoView : View {
    var teacher : TeacherSubjectDetailsM = TeacherSubjectDetailsM.init()
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
                
                Text(teacher.teacherBIO ?? "Teacher Bio")
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
                    
                    Text(teacher.SubjectOrLessonDto?.systemBrief ?? "Subject Breif")
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
                                + Text(" \(teacher.minGroup ?? 0) ")
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
                                + Text(" \(teacher.lessonsCount ?? 0) ")
                                    .font(Font.SoraSemiBold(size: 13))
                                
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
                                + Text(" \(teacher.maxGroup ?? 0)")
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
    SubjectTeacherInfoView(teacher: TeacherSubjectDetailsM.init())
}


