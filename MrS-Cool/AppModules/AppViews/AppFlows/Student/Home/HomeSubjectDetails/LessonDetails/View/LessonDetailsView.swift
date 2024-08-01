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
        self.dayFormatter = DateFormatter.cachedFormatter
        self.dayFormatter.dateFormat = "dd"
        self.weekDayFormatter = DateFormatter.cachedFormatter
        self.weekDayFormatter.dateFormat = "EEE"
    }
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter.cachedFormatter
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
                        
                        VStack(alignment:.leading){
                            Text(details.SubjectOrLessonDto?.headerName ?? "")
                                .font(.SoraBold(size: 18))
                            Text(details.SubjectOrLessonDto?.subjectName ?? "")
                                .font(.SoraSemiBold(size: 16))

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
                                        guard lessoncase != .Group else {return}
                                        lessoncase = .Group
                                        lessondetailsvm.selectedsched = nil //clear individual
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
                                        guard lessoncase != .Individual else {return}
                                        lessoncase = .Individual
                                        lessondetailsvm.selectedLessonGroup = nil // clear group
                                        selectedDate = Date()
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
                                            if (details.LessonGroupsDto?.count ?? 0) > 1{
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

                                            }
                                            
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
                                                            Text("Date".localized())+Text(": ")+Text("\(slot.date ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "d MMMM yyyy"))
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
                                                            Text("Start Time".localized())+Text(": ")+Text("\(slot.timeFrom ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
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
                                                            Text("End Time".localized())+Text(": ")+Text("\(slot.timeTo ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
                                                        }
                                                        .font(.SoraRegular(size: 10))
                                                        .foregroundColor(.mainBlue)
                                                    }, icon: {
                                                        Image("caltimevector")
                                                            .resizable()
                                                            .frame(width:15,height:15)
                                                    })
                                                }
                                                .frame(maxWidth:.infinity,alignment:.leading)
                                                .padding(.top,8)
                                                .padding(.horizontal)
                                                
                                            }
                                            .padding(.bottom)
                                            .background(content: {
                                                ColorConstants.ParentDisableBg.opacity(0.5).clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                            })
                                            .frame(width:170)

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
                                            
                                            
                                            if (details.LessonGroupsDto?.count ?? 0) > 1{
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
                                            Text("  \(details.individualCost ?? 0,specifier:"%.2f") ")
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
                                    
                                    if (lessoncase == .Individual && lessondetailsvm.availableScheduals == []){
                                        Group{
                                        Text(" No Available Times on ".localized())
                                        + Text("\(selectedDate ?? Date())" .ChangeDateFormat(FormatFrom: "yyyy-MM-dd HH:mm:ss Z", FormatTo: "EEEE, MMMM d, yyyy")
                                        )
                                    }
                                        .font(Font.SoraBold(size: 15))
                                        .foregroundColor(ColorConstants.MainColor)
                                }
                                    ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                                        .padding(.horizontal)
                                    
                                    HorizontalScrollWithTwoRows(items:  $lessondetailsvm.availableScheduals ,selectedsched:$lessondetailsvm.selectedsched)
                                }
                                
                                if (lessoncase == .Group && details.LessonGroupsDto != []) || (lessoncase == .Individual && lessondetailsvm.availableScheduals != [])  {
                                    CustomButton(Title:"Book Now",IsDisabled:.constant( lessondetailsvm.selectedLessonGroup == nil && lessondetailsvm.selectedsched == nil) , action: {
                                        if Helper.shared.CheckIfLoggedIn(){
                                            destination = AnyView(BookingCheckoutView(selectedgroupid: selectedDataToBook(selectedId: lessoncase == .Group ? lessondetailsvm.selectedLessonGroup:selectedlessonid, Date: lessondetailsvm.selectedsched?.date, DayName: lessondetailsvm.selectedsched?.dayName, FromTime: lessondetailsvm.selectedsched?.fromTime, ToTime: lessondetailsvm.selectedsched?.toTime), bookingcase: lessoncase))
                                        isPush = true                                  
                                        }else{
                                            lessondetailsvm.error = .error(image:"img_subtract", message: "You have to login first",buttonTitle:"OK",secondButtonTitle:"Cancel",mainBtnAction:{
                                                Helper.shared.changeRoot(toView: SignInView())
                                            })
                                            lessondetailsvm.isError = true
                                        }
                                })
                                .frame(height: 40)
                                .padding(.top,10)
                                .padding(.horizontal)
                            }
                                
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
            if lessoncase == .Group {
                lessondetailsvm.GetLessonDetails(lessonId: selectedlessonid)
            }else{
                let date = selectedDate?.formatDate(format: "yyyy-MM-dd'T'hh:mm:ss'Z'")
                lessondetailsvm.GetAvailableScheduals(startDate:date ?? "")
            }
        })
        .onDisappear {
            lessondetailsvm.cleanup()
        }
        .onChange(of: selectedDate){newdate in
            let date = newdate?.formatDate(format: "yyyy-MM-dd'T'hh:mm:ss'Z'")
//            if newdate != Data(){
            lessondetailsvm.GetAvailableScheduals(startDate:date ?? "")
            lessondetailsvm.selectedsched = nil //clear individual selected sched
        }
                .showHud(isShowing: $lessondetailsvm.isLoading)
                .showAlert(hasAlert: $lessondetailsvm.isError, alertType: lessondetailsvm.error)
        
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
                                                Text("\(items[index].fromTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
                                            }
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.WhiteA700:.mainBlue)
                                            
                                        }
                                        
                                        ColorConstants.Gray300.frame(height: 0.5).padding(.vertical,8)
                                        
                                        HStack {
                                            Group{
                                                Text("End Time".localized())
                                                
                                                Spacer()
                                                Text("\(items[index].toTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
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
                                                Text("\(items[index].fromTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
                                            }
                                            .foregroundColor(selectedsched == items[index] ? ColorConstants.WhiteA700:.mainBlue)
                                            
                                        }
                                        
                                        CustomDivider()
                                        
                                        HStack {
                                            Group{
                                                Text("End Time".localized())
                                                
                                                Spacer()
                                                Text("\(items[index].toTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
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
