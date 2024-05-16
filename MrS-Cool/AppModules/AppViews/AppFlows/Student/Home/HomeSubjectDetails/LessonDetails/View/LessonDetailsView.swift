//
//  LessonDetailsView.swift
//  MrS-Cool
//
//  Created by wecancity on 30/01/2024.
//

import SwiftUI

enum LessonCases{
    case Group, Individual
}

struct LessonDetailsView: View {
    var selectedlessonid : Int
    @StateObject var lessondetailsvm = LessonDetailsVM()
    
    @State var showFilter : Bool = false
    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    //    var bookingcase:BookingCases
    
    @State private var currentPage = 0
    @State private var forwards = false
    //    let images = ["tab0", "tab1", "tab2", "tab3"] // Replace with your image names
    
    @State private var lessoncase:LessonCases = .Group
    
    private let calendar: Calendar
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    
    @State var selectedDate : Date? = Date()
    @State private var ispastdate:Bool = false
//    @State var isselected = false

    init(selectedlessonid : Int) {
        self.selectedlessonid = selectedlessonid
        self.calendar = Calendar.current
        self.dayFormatter = DateFormatter()
        self.dayFormatter.dateFormat = "dd"
        self.weekDayFormatter = DateFormatter()
        self.weekDayFormatter.dateFormat = "EEE"
    }
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd, MMM yyyy"
        return formatter
    }()
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Lesson Info")
            
            VStack (alignment: .leading){
                
                if let details = lessondetailsvm.lessonDetails {
                    HStack {
//                        AsyncImage(url: URL(string: Constants.baseURL+(details.SubjectOrLessonDto?.image ?? "")  )){image in
//                            image
//                                .resizable()
//                        }placeholder: {
//                            Image("img_younghappysmi")
//                                .resizable()
//                        }
                        let imageURL : URL? = URL(string: Constants.baseURL+(details.SubjectOrLessonDto?.image ?? "").reverseSlaches())
                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60,height: 60)
                        .clipShape(Circle())
                        
                        VStack{
                            Text(details.SubjectOrLessonDto?.headerName ?? "")
                                .font(.SoraBold(size: 18))
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
                    Text(details.SubjectOrLessonDto?.systemBrief ?? "")
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
                                
                                LessonTeacherInfoView(teacher: details)
                                
                                    HStack{
                                        Button(action: {
                                            lessoncase = .Group
                                        }, label: {
                                            Text("Group".localized())
                                                .font(.SoraBold(size: 18))
                                                .padding()
                                                .frame(minWidth:80,maxWidth:.infinity)
                                                .foregroundColor(lessoncase == .Group ? ColorConstants.WhiteA700 : ColorConstants.MainColor)
                                                .background(content: {
                                                    Group{lessoncase == .Group ? ColorConstants.MainColor : ColorConstants.ParentDisableBg}.clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                                })
                                        })
                                        
                                        Button(action: {
                                            lessoncase = .Individual
                                        }, label: {
                                            Text("Individual".localized())
                                                .font(.SoraBold(size: 18))
                                                .padding()
                                                .frame(minWidth:80,maxWidth:.infinity)
                                                .foregroundColor(lessoncase == .Individual ? ColorConstants.WhiteA700 : ColorConstants.MainColor)
                                                .background(content: {
                                                    Group{lessoncase == .Individual ? ColorConstants.MainColor : ColorConstants.ParentDisableBg}.clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                                })
                                        })
                                        
                                    }
                                    HStack {
                                        Text(lessoncase == .Group ? "Group Booking".localized():"Individual Booking".localized())
                                            .font(.SoraBold(size: 18))
                                            .foregroundColor(ColorConstants.WhiteA700)
                                        //                                        .multilineTextAlignment(.leading)
                                    }
                                    .frame(minWidth:50,maxWidth:.infinity)
                                    .frame(height: 45)
                                    .padding(.horizontal)
                                    .background(content: {
                                        ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                                    })
                                    
                                
                                switch lessoncase {
                                case .Group:
                                    if details.LessonGroupsDto != [] , let slot = details.LessonGroupsDto?[currentPage]{
                                        
                                        HStack {
                                            Button(action: {
                                                forwards = true
                                                withAnimation {
                                                    currentPage = min(currentPage + 1, (details.LessonGroupsDto?.count ?? 0) - 1)
                                                }
                                            }) {
                                                Image(currentPage >= 0 && currentPage < (details.LessonGroupsDto?.count ?? 0) - 1 ? "nextfill":"nextempty")
                                                    .resizable()
                                                    .frame(width:30,height:30)
                                            }
                                            .padding()
                                            .buttonStyle(.plain)
                                            
                                            Spacer()
                                            
                                                              
                                            let isselected = lessondetailsvm.selectedLessonGroup == details.LessonGroupsDto?[currentPage].teacherLessonSessionID
                                            
                                            VStack(alignment:.leading){
                                                HStack {
                                                    ZStack{
                                                        Image("circleempty")
                                                        Image("img_line1")
                                                            .renderingMode(.template)
                                                            .foregroundColor(isselected ? ColorConstants.MainColor:.clear)
                                                    }
                                                    .offset(x:-40)
                                                    Text(slot.groupName ?? "")
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
                                                            Text("Date".localized())+Text(slot.date ?? "15 Nov 2023")
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
                                                            Text("Start Time".localized())+Text(slot.timeFrom ?? "15 Nov 2023")
                                                        }
                                                        .font(.SoraRegular(size: 10))
                                                        .foregroundColor(.mainBlue)
                                                    }, icon: {
                                                        Image("caltimevector")
                                                            .resizable()
                                                            .frame(width:15,height:15)
                                                    })
                                                    Label(title: {
                                                        Group {
                                                            Text("End Time".localized())+Text(slot.timeTo ?? "15 Nov 2023")
                                                        }
                                                        .font(.SoraRegular(size: 10))
                                                        .foregroundColor(.mainBlue)
                                                    }, icon: {
                                                        Image("caltimevector")
                                                            .resizable()
                                                            .frame(width:15,height:15)
                                                    })
                                                }
                                                .padding(.top,8)
                                                .padding(.horizontal)
                                                
                                            }
                                            .padding(.bottom)
                                            .background(content: {
                                                ColorConstants.ParentDisableBg.opacity(0.5).clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                            })
                                            .onTapGesture(perform: {
                                                lessondetailsvm.selectedLessonGroup = slot.teacherLessonSessionID
                                            })
                                            .transition(
                                                .asymmetric(
                                                    insertion: .move(edge: forwards ? .trailing : .leading),
                                                    removal: .move(edge: forwards ? .leading : .trailing)
                                                )
                                            )
                                            .id(UUID())
//                                            .onChange(of: lessondetailsvm.selectedLessonGroup){value in
//                                                isselected = value == slot.teacherLessonSessionID
//                                                
//                                            }
                                            
                                            
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                forwards = false
                                                withAnimation {
                                                    currentPage = max(currentPage - 1, 0)
                                                }
                                            }) {
                                                Image((currentPage > 0 && currentPage <= (details.LessonGroupsDto?.count ?? 0) - 1) ? "prevfill":"prevempty")
                                                    .resizable()
                                                    .frame(width:30,height:30)
                                            }
                                            .padding()
                                            .buttonStyle(.plain)
                                        }
                                        .padding(.vertical)
                                        .frame(width: gr.size.width-50)
                                        
                                    }else{
                                        Text("No Available Group Times".localized())
                                            .font(Font.SoraBold(size: 15))
                                            .foregroundColor(ColorConstants.MainColor)

                                        //                                          print("no slots to display")
                                    }
                                case .Individual:
                                    
                                    Image("calendar_done")
                                        .resizable()
                                        .frame(width:40,height:40)
                                    
                                    HStack(spacing: 0){
                                        Image("moneyicon")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(ColorConstants.MainColor )
                                            .frame(width: 20,height: 20, alignment: .center)
                                        Group {
                                            Text("  \(details.price ?? 222) ")
                                            + Text("EGP".localized())
                                        }
                                        .font(Font.SoraBold(size: 18))
                                        .foregroundColor(ColorConstants.MainColor)
                                    }.padding(7)
                                    
                                    ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                                        .padding(.horizontal)
                                    
                                    WeeklyCalendarView(selectedDate: $selectedDate)
                                    ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                                        .padding(.horizontal)
                                    
                                    Image("time_loading")
                                        .resizable()
                                        .frame(width:40,height:40)
                                        .padding(.vertical,8)
                                    
                                    Group{
                                    Text("Available Times on".localized())
                                    + Text(" \(selectedDate ?? Date())")
                                    }
                                    .font(Font.SoraBold(size: 15))
                                    .foregroundColor(ColorConstants.MainColor)

                                    
                                    ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                                        .padding(.horizontal)
                                    
                                    HorizontalScrollWithTwoRows(items:  $lessondetailsvm.availableScheduals ,selectedsched:$lessondetailsvm.selectedsched)

                                }
                                
                                CustomButton(Title:"Book Now",IsDisabled:.constant(lessondetailsvm.selectedLessonGroup == nil) , action: {
                                    destination = AnyView(BookingCheckoutView(selectedid: lessondetailsvm.selectedLessonGroup ?? 0, bookingcase: lessoncase))
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
            lessondetailsvm.GetLessonDetails(lessonId: selectedlessonid)
        })
        .onDisappear {
            lessondetailsvm.cleanup()
        }
        .onChange(of: selectedDate){newdate in
            let date = newdate?.formatDate(format: "yyyy-MM-dd'T'hh:mm:ss'Z'")
//            if newdate != Data(){
            lessondetailsvm.GetAvailableScheduals(startDate:date ?? "")
//            }
        }
        //        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        //        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
}

#Preview {
    LessonDetailsView(selectedlessonid: 0)
}


struct HorizontalScrollWithTwoRows: View {
    @Binding var items: [TeacherAvaliableSchedualDto]?
//    var onTap: ((TeacherAvaliableSchedualDto) -> Void)?  // Closure that takes an Int parameter and returns Void
    
    @Binding var selectedsched : TeacherAvaliableSchedualDto?
    
    var body: some View {
        ScrollView(.horizontal) {
            if let items = items{
                if items.count < 3 {
                    HStack(spacing: 10) {
                        ForEach(items.indices, id: \.self) { index in
                            Button(action: {
                                //                            onTap?(items[index])
                                selectedsched = items[index]
                            }){
                                HStack (alignment: .top){
                                    ZStack(){
                                        Image("circleempty")
                                        Image("img_line1")
                                            .renderingMode(.template)
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.MainColor:.clear)
                                    }
                                    .offset(y:-2.5)
                                    VStack{
                                        HStack{
                                            Group{
                                                Text("Start Time".localized())
                                                
                                                Spacer()
                                                Text(items[index].fromTime ?? "03:45 PM")
                                            }
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.WhiteA700:.mainBlue)
                                            
                                        }
                                        
                                        ColorConstants.Gray300.frame(height: 0.5).padding(.vertical,8)
                                        
                                        HStack {
                                            Group{
                                                Text("End Time".localized())
                                                
                                                Spacer()
                                                Text(items[index].toTime ?? "03:45 PM")
                                            }
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.WhiteA700:.mainBlue)
                                        }
                                        
                                    }
                                    .frame(width: 120)
                                    //                                .padding(.horizontal)
                                    
                                    //                                .background(ColorConstants.MainColor)
                                    .font(.SoraRegular(size: 10))
                                    //                            .foregroundColor(ColorConstants.WhiteA700)
                                }
                                .padding(8)
                                .background(content: {
                                    if selectedsched == items[index] {
                                        ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                    } else {
                                        Color.clear.borderRadius(ColorConstants.MainColor, width: 1.5, cornerRadius: 15, corners: [.allCorners])
                                    }
                                })
                            }
                        }
                    }
                    .padding()
                } else {
                    LazyHGrid(rows: [
                        GridItem(.fixed(70)),
                        GridItem(.fixed(70)),
                    ]) {
                        ForEach(items.indices, id: \.self) { index in
                            Button(action: {
                                //                            onTap?(items[index])
                                selectedsched = items[index]
                                
                            }) {
                                HStack (alignment: .top){
                                    ZStack() {
                                        Image("circleempty")
                                        Image("img_line1")
                                            .renderingMode(.template)
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.MainColor:.clear)
                                    }
                                    .offset(y:-2.5)
                                    VStack{
                                        HStack{
                                            Group{
                                                Text("Start Time".localized())
                                                
                                                Spacer()
                                                Text(items[index].fromTime ?? "03:45 PM")
                                            }
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.WhiteA700:.mainBlue)
                                            
                                        }
                                        
                                        CustomDivider()
                                        
                                        HStack {
                                            Group{
                                                Text("End Time".localized())
                                                
                                                Spacer()
                                                Text(items[index].toTime ?? "03:45 PM")
                                            }
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.WhiteA700:.mainBlue)
                                        }
                                        
                                    }
                                    .frame(width: 120)
                                    .font(.SoraRegular(size: 10))
                                }
                                .padding(8)
                                .background(content: {
                                    if selectedsched == items[index] {
                                        ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                    } else {
                                        Color.clear.borderRadius(ColorConstants.MainColor, width: 1.5, cornerRadius: 15, corners: [.allCorners])
                                    }
                                })
                            }
                        }
                    }
                    .padding(5)
                }
            }
        }
    }
}

struct HorizontalScrollWithTwoRows_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollWithTwoRows(items:.constant([TeacherAvaliableSchedualDto.init()]), selectedsched: .constant(TeacherAvaliableSchedualDto.init()))
    }
}

struct CustomDivider: View {
    var body: some View {
        ColorConstants.Gray300.frame(height: 0.5).padding(.vertical,8)
    }
}
