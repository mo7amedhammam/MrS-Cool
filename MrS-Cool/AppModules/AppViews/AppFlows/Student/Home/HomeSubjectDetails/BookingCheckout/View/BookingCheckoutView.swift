//
//  BookingCheckoutView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/02/2024.
//

import SwiftUI

struct BookingCheckoutView: View {
    var selectedid : Int
    var bookingcase:LessonCases?
    @StateObject var checkoutvm = BookingCheckoutVM()
    
    @State var showFilter : Bool = false
    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State private var currentPage = 0
    @State private var forwards = false

//    init(selectedid : Int,bookingcase:LessonCases? = nil) {
//        self.selectedid = 0
//        self.bookingcase = bookingcase
//        checkoutvm.bookingcase =  bookingcase
//    }
    
    var body: some View {
        VStack {
            CustomTitleBarView(title:checkoutvm.bookingcase == nil ? "Booking Full Subject" : checkoutvm.bookingcase == .Group ? "Booking Group Lesson":"Booking Individual Lesson")
            
            VStack (alignment: .leading){
                
//                if let details = lessondetailsvm.lessonDetails {
//                    HStack {
//                        AsyncImage(url: URL(string: Constants.baseURL+(details.SubjectOrLessonDto?.image ?? "")  )){image in
//                            image
//                                .resizable()
//                        }placeholder: {
//                            Image("img_younghappysmi")
//                                .resizable()
//                        }
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 60,height: 60)
//                        .clipShape(Circle())
//                        
//                        VStack{
//                            Text(details.SubjectOrLessonDto?.headerName ?? "subjectname")
//                                .font(.SoraBold(size: 18))
//                        }
//                        .foregroundColor(.mainBlue)
//                        
//                        Spacer()
//                    }
//                    .padding(.vertical)
//                    .padding(.horizontal,30)
//                    
//                    Text(details.SubjectOrLessonDto?.systemBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
//                        .font(.SoraRegular(size: 10))
//                        .foregroundColor(.mainBlue)
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal,30)
//                        .frame(minHeight: 20)
//                    
//                    GeometryReader { gr in
//                        VStack(alignment:.leading){ // Title - Data - Submit Button)
//                            
//                            ScrollView(.vertical,showsIndicators: false){
//                                Spacer().frame(height:20)
//                                
//                                HStack {
//                                    Text("Teacher Info".localized())
//                                        .font(.SoraBold(size: 18))
//                                        .foregroundColor(ColorConstants.WhiteA700)
//                                        .multilineTextAlignment(.leading)
//                                    Spacer()
//                                }
//                                .frame(height: 45)
//                                .padding(.horizontal)
//                                .background(content: {
//                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
//                                })
//                                
//                                LessonTeacherInfoView(teacher: details)
//                                
//                                HStack{
//                                    Button(action: {
//                                        lessoncase = .Group
//                                    }, label: {
//                                        Text("Group".localized())
//                                            .font(.SoraBold(size: 18))
//                                            .padding()
//                                            .frame(minWidth:80,maxWidth:.infinity)
//                                            .foregroundColor(lessoncase == .Group ? ColorConstants.WhiteA700 : ColorConstants.MainColor)
//                                            .background(content: {
//                                                Group{lessoncase == .Group ? ColorConstants.MainColor : ColorConstants.ParentDisableBg}.clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
//                                            })
//                                        
//                                    })
//                                    
//                                    Button(action: {
//                                        lessoncase = .Individual
//                                    }, label: {
//                                        Text("Individual".localized())
//                                            .font(.SoraBold(size: 18))
//                                            .padding()
//                                            .frame(minWidth:80,maxWidth:.infinity)
//                                            .foregroundColor(lessoncase == .Individual ? ColorConstants.WhiteA700 : ColorConstants.MainColor)
//                                            .background(content: {
//                                                Group{lessoncase == .Individual ? ColorConstants.MainColor : ColorConstants.ParentDisableBg}.clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
//                                            })
//                                        
//                                    })
//                                }
//                                HStack {
//                                    Text(lessoncase == .Group ? "Group Booking".localized():"Individual Booking".localized())
//                                        .font(.SoraBold(size: 18))
//                                        .foregroundColor(ColorConstants.WhiteA700)
//                                    //                                        .multilineTextAlignment(.leading)
//                                }
//                                .frame(minWidth:50,maxWidth:.infinity)
//                                .frame(height: 45)
//                                .padding(.horizontal)
//                                .background(content: {
//                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
//                                })
//                                
//                                switch lessoncase {
//                                case .Group:
//                                    HStack {
//                                        Button(action: {
//                                            forwards = true
//                                            withAnimation {
//                                                currentPage = min(currentPage + 1, (details.LessonGroupsDto?.count ?? 0) - 1)
//                                            }
//                                        }) {
//                                            Image(currentPage >= 0 && currentPage < (details.LessonGroupsDto?.count ?? 0) - 1 ? "nextfill":"nextempty")
//                                                .resizable()
//                                                .frame(width:30,height:30)
//                                        }
//                                        .padding()
//                                        .buttonStyle(.plain)
//                                        
//                                        Spacer()
//                                        
//                                        let isselected = lessondetailsvm .selectedLessonGroup == details.LessonGroupsDto?[currentPage].teacherLessonSessionID
//                                        VStack(alignment:.leading){
//                                            HStack {
//                                                ZStack{
//                                                    Image("circleempty")
//                                                    Image("img_line1")
//                                                        .renderingMode(.template)
//                                                        .foregroundColor(isselected ? ColorConstants.MainColor:.clear)
//                                                }
//                                                .offset(x:-40)
//                                                Text(details.LessonGroupsDto?[currentPage].groupName ?? "group 1")
//                                                    .font(.SoraBold(size: 18))
//                                                    .foregroundColor(isselected ? ColorConstants.WhiteA700:ColorConstants.MainColor)
//                                            }
//                                            .frame(width:170,height: 45)
//                                            .padding(.horizontal)
//                                            .background(content: {
//                                                if isselected {
//                                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight])) }else{
//                                                        Color.clear.borderRadius(ColorConstants.MainColor, width: 1.5, cornerRadius: 15, corners: [.topLeft, .topRight])
//                                                        
//                                                    }
//                                            })
//                                            Group{
//                                                Label(title: {
//                                                    Group {
//                                                        Text("Date".localized())+Text(details.LessonGroupsDto?[currentPage].date ?? "15 Nov 2023")
//                                                    }
//                                                    .font(.SoraRegular(size: 10))
//                                                    .foregroundColor(.mainBlue)
//                                                }, icon: {
//                                                    Image("calvector")
//                                                        .resizable()
//                                                        .frame(width:15,height:15)
//                                                })
//                                                
//                                                Label(title: {
//                                                    Group {
//                                                        Text("Start Time".localized())+Text(details.LessonGroupsDto?[currentPage].timeFrom ?? "15 Nov 2023")
//                                                    }
//                                                    .font(.SoraRegular(size: 10))
//                                                    .foregroundColor(.mainBlue)
//                                                }, icon: {
//                                                    Image("caltimevector")
//                                                        .resizable()
//                                                        .frame(width:15,height:15)
//                                                })
//                                                Label(title: {
//                                                    Group {
//                                                        Text("End Time".localized())+Text(details.LessonGroupsDto?[currentPage].timeTo ?? "15 Nov 2023")
//                                                    }
//                                                    .font(.SoraRegular(size: 10))
//                                                    .foregroundColor(.mainBlue)
//                                                }, icon: {
//                                                    Image("caltimevector")
//                                                        .resizable()
//                                                        .frame(width:15,height:15)
//                                                })
//                                            }
//                                            .padding(.top,8)
//                                            .padding(.horizontal)
//                                            
//                                        }.padding(.bottom)
//                                            .background(content: {
//                                                ColorConstants.ParentDisableBg.opacity(0.5).clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
//                                            })
//                                            .onTapGesture(perform: {
//                                                lessondetailsvm.selectedLessonGroup = details.LessonGroupsDto?[currentPage].teacherLessonSessionID
//                                            })
//                                        
//                                            .transition(
//                                                .asymmetric(
//                                                    insertion: .move(edge: forwards ? .trailing : .leading),
//                                                    removal: .move(edge: forwards ? .leading : .trailing)
//                                                )
//                                            )
//                                            .id(UUID())
//                                        
//                                        Spacer()
//                                        
//                                        Button(action: {
//                                            forwards = false
//                                            withAnimation {
//                                                currentPage = max(currentPage - 1, 0)
//                                            }
//                                        }) {
//                                            Image((currentPage > 0 && currentPage <= (details.LessonGroupsDto?.count ?? 0) - 1) ? "prevfill":"prevempty")
//                                                .resizable()
//                                                .frame(width:30,height:30)
//                                        }
//                                        .padding()
//                                        .buttonStyle(.plain)
//                                    }
//                                    .padding(.vertical)
//                                    .frame(width: gr.size.width-50)
//                                case .Individual:
//                                    
//                                    
//                                    WeeklyCalendarView(selectedDate: $selectedDate)
//                                    
//                                    //                                    .frame(height:222)
//                                    
//                                    
//                                    
//                                    //                                    WeekView(
//                                    //                                        calendar: calendar,
//                                    //                                        date: $selectedDate,
//                                    //                                        content: {
//                                    //                                            date in
//                                    //                                            Button(action: {
//                                    //                                                if date >= Calendar.current.startOfDay(
//                                    //                                                    for: Date()
//                                    //                                                ) {
//                                    //                                                    self.selectedDate = date
//                                    //                                                }
//                                    //                                            }) {
//                                    //                                                Text(dayFormatter.string(from: date))
//                                    //                                                .padding(5)
//                                    //                                                .foregroundColor(selectedDate == date ? .white : .mainBlue)
//                                    //                                                .background(
//                                    //                                                    Circle()
//                                    //                                                        .fill(selectedDate == date ? .mainBlue : Color.clear
//                                    //                                                        ) // Circular background
//                                    //                                                )
//                                    //                                                .opacity(date < Calendar.current.startOfDay(for: Date()) ? 0.5 : 1.0) // Adjust opacity based on date
//                                    //
//                                    //                                            }
//                                    //
//                                    //                                        },
//                                    //                                        header: { weekStartDate in
//                                    //                                            Text( weekDayFormatter.string(from: weekStartDate))
//                                    //
//                                    //                                        }
//                                    //                                    )
//                                    
//                                    
//                                }
//                                
//                                
//                                
//                                CustomButton(Title:"Book Now",IsDisabled:.constant(false) , action: {
//                                    
//                                    //                                    switch lessoncase {
//                                    //                                    case .Group:
//                                    //                                        destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: selectedsubjectid, bookingcase: .subject))
//                                    //                                        isPush = true
//                                    
//                                    //                                    case .Individual:
//                                    //                                        <#code#>
//                                    //                                    }
//                                    
//                                })
//                                .frame(height: 40)
//                                .padding(.top,10)
//                                .padding(.horizontal)
//                                
//                                
//                                Spacer()
//                                    .frame(height:50)
//                            }
//                            .padding(.horizontal)
//                            .frame(minHeight: gr.size.height)
//                        }
//                    }
//                    
//                    .background{
//                        ColorConstants.WhiteA700
//                            .clipShape(RoundedCorners(topLeft: 25, topRight: 25, bottomLeft: 0, bottomRight: 0))
//                            .ignoresSafeArea()
//                    }
//                }else{
//                    Spacer()
//                }
                
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
            checkoutvm.bookingcase =  bookingcase
            checkoutvm.GetBookCheckout(lessonId: selectedid)
        })
        .onDisappear {
            checkoutvm.cleanup()
        }
        //        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        //        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
}

#Preview {
    BookingCheckoutView(selectedid: 0, bookingcase: .Group)
}


