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
                                .font(.bold(size: 18))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
//                    Text(details.SubjectOrLessonDto?.systemBrief ?? "")
//                        .font(.regular(size: 10))
//                        .foregroundColor(.mainBlue)
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal,30)
//                        .frame(minHeight: 20)
                    
                    scrollableBriefText(text:details.SubjectOrLessonDto?.systemBrief ?? "")

                    GeometryReader { gr in
                        VStack(alignment:.leading){ // Title - Data - Submit Button)
                            
                            ScrollView(.vertical,showsIndicators: false){
                                Spacer().frame(height:20)
                                
                                HStack {
                                    Text("Teacher Info".localized())
                                        .font(.bold(size: 18))
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
                                        .font(.bold(size: 18))
                                        .foregroundColor(ColorConstants.WhiteA700)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(height: 45)
                                .padding(.horizontal)
                                .background(content: {
                                    ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                                })
                                
                                if details.SubjectGroups != [] , let slot = details.SubjectGroups?[currentPage]{
                                    
                                    HStack {
                                        if details.SubjectGroups?.count ?? 0 > 1{
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
                                            .localizeView()
                                            Spacer()
                                        }
                                        
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
                                                Text(slot.groupName ?? "")
                                                    .font(.bold(size: 18))
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
                                                        Text("\(slot.numOfLessons ?? 0) ")+Text("Lessons".localized())
                                                    }
                                                    .font(.bold(size: 10))
                                                    .foregroundColor(.mainBlue)
                                                }, icon: {
                                                    Image("img_vector_black_900_20x20")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .foregroundColor(ColorConstants.MainColor )
                                                        .frame(width:15,height:15)
                                                })
                                                .frame(maxWidth:.infinity,alignment:.leading)
                                                
                                                Label(title: {
                                                    Group {
                                                        Text("Duration".localized())+Text(": ".localized()) +
//                                                        HStack(spacing:0){
                                                            Text("\((slot.duration ?? 0).hours) ") +
                                                            Text("hrs".localized()) +
                                                            Text(", ".localized()) +
                                                            Text("\((slot.duration ?? 0).minutes) ") +
                                                            Text("mins".localized())
//                                                        }
                                                        
                                                    }
                                                    .font(.bold(size: 10))
                                                    .foregroundColor(.mainBlue)
                                                }, icon: {
                                                    Image("clockcheckout")
                                                        .resizable()
                                                        .frame(width:15,height:15)
                                                })
                                                .frame(maxWidth:.infinity,alignment:.leading)
                                                
                                                Label(title: {
                                                    Group {
                                                        Text("Start Date".localized())+Text(": ".localized())+Text("\(slot.startDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "d MMM yyyy"))
                                                    }
                                                    .font(.bold(size: 10))
                                                    .foregroundColor(.mainBlue)
                                                }, icon: {
                                                    Image("calvector")
                                                        .resizable()
                                                        .frame(width:15,height:15)
                                                })
                                                .frame(maxWidth:.infinity,alignment:.leading)
                                                
                                                Label(title: {
                                                    Group {
                                                        Text("End Date".localized())+Text(": ".localized())+Text("\(slot.endDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "d MMM yyyy"))
                                                    }
                                                    .font(.bold(size: 10))
                                                    .foregroundColor(.mainBlue)
                                                }, icon: {
                                                    Image("calvector")
                                                        .resizable()
                                                        .frame(width:15,height:15)
                                                })
                                                .frame(maxWidth:.infinity,alignment:.leading)
                                                
                                                ForEach(slot.getSubjectScheduleGroups ?? [],id:\.self){ schedual in
                                                    Label(title: {
                                                        Group {
                                                            Text(schedual.dayName ?? "" )+Text(": ".localized())+Text("\(schedual.fromTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
                                                        }
                                                        .font(.bold(size: 10))
                                                        .foregroundColor(.mainBlue)
                                                    }, icon: {
                                                        Image("calvector")
                                                            .resizable()
                                                            .frame(width:15,height:15)
                                                    })
                                                    .frame(maxWidth:.infinity,alignment:.leading)
                                                    .padding(.top,8)
                                                }
                                            }
                                            .padding(.top,8)
                                            .padding(.leading )
                                            
                                        }
                                        .padding(.bottom)
                                        .background(content: {
                                            ColorConstants.ParentDisableBg.opacity(0.5).clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                        })
                                        .frame(width:170)
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
                                        
                                        if details.SubjectGroups?.count ?? 0 > 1{
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
                                    }
                                    .padding(.vertical)
                                    .frame(width: gr.size.width-50)
                                    
                                    CustomButton(Title:"Book Now",IsDisabled:.constant(subjectdetailsvm.selectedSubjectId == nil) , action: {
                                        if Helper.shared.CheckIfLoggedIn(){
                                            if Helper.shared.getSelectedUserType() == .Teacher{
                                                subjectdetailsvm.error = .error(image:"img_subtract", message: "This Service Available For Student Only",buttonTitle:"OK",mainBtnAction:{

                                                })
                                                subjectdetailsvm.isError = true
                                            }else{
                                                destination = AnyView(BookingCheckoutView(selectedgroupid:selectedDataToBook(selectedId: subjectdetailsvm.selectedSubjectId ?? 0) , bookingcase: nil))
                                                isPush = true
                                            }
                                        }else{
                                            subjectdetailsvm.error = .error(image:"img_subtract", message: "You have to login first",buttonTitle:"OK",secondButtonTitle:"Cancel",mainBtnAction:{
//                                                Helper.shared.logout()
//                                                Helper.shared.changeRoot(toView: SignInView(hideimage:false))

                                                destination =                           AnyView(SignInView(hideimage:false))
                                                                          
                                                Helper.shared.logout()
                                                isPush = true

                                            })
                                            subjectdetailsvm.isError = true
                                        }
                                        
                                    })
                                    .frame(height: 40)
                                    .padding(.top,10)
                                    .padding(.horizontal)
                                    
                                }else{
                                    Text("No Available Subject Groups".localized())
                                        .font(Font.bold(size: 15))
                                        .foregroundColor(ColorConstants.MainColor)
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
            subjectdetailsvm.GetSubjectDetails(subjectId: selectedsubjectid)
        })
        .onDisappear {
            subjectdetailsvm.cleanup()
        }
        .showHud(isShowing: $subjectdetailsvm.isLoading)
        .showAlert(hasAlert: $subjectdetailsvm.isError, alertType: subjectdetailsvm.error)
        
        
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
            //            AsyncImage(url: URL(string: Constants.baseURL+(teacher.teacherImage ?? "")  )){image in
            //                image
            //                    .resizable()
            //            }placeholder: {
            //                Image("img_younghappysmi")
            //                    .resizable()
            //            }
            let imageURL : URL? = URL(string: Constants.baseURL+(teacher.teacherImage ?? "").reverseSlaches())
            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"),isOpenable: true)
            
                .aspectRatio(contentMode: .fill)
                .frame(width: 115,height: 115)
                .clipShape(Circle())
            
            VStack(alignment: .center, spacing:0){
                //                VStack {
                Text(teacher.teacherName ?? "")
                    .font(.bold(size: 20))
                    .multilineTextAlignment(.leading)
                //                    Spacer()
                
                Text(teacher.teacherBIO ?? "")
                    .font(.semiBold(size: 12))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .foregroundColor(.mainBlue)
//                    .padding(.horizontal,30)
                    .frame(minHeight:40)
                    .padding(8)
                
                HStack{
                    StarsView(rating: teacher.teacherRate ?? 0.0)
                    Text("\(teacher.teacherRate ?? 0,specifier: "%.1f")")
                        .foregroundColor(ColorConstants.Black900)
                        .font(.bold(size: 12))
                }
                .padding(.vertical,5)
                
                //                if let ratescount = teacher.teacherReview, ratescount > 0{
                HStack(spacing:2) {
                    Text("\(teacher.teacherReview ?? 0) ")
                    Text("Reviews".localized())
                }
                .foregroundColor(ColorConstants.Black900)
                .font(.semiBold(size: 12))
                //                }
                
                HStack(spacing: 5){
                    Image("moneyicon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(ColorConstants.MainColor )
                        .frame(width: 20,height: 20, alignment: .center)
                    HStack (spacing:8){
                        if let minprice = teacher.minPrice{
                            Text("\(minprice ,specifier:"%.2f")")
                            Text("-")
                             }
                        Text("\(teacher.maxPrice ?? 0,specifier:"%.2f")")

                        Text("EGP".localized())
                    }
                    .font(Font.bold(size: 18))
                    .foregroundColor(ColorConstants.MainColor)
                }.padding(7)
                
                ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                
                VStack(alignment:.leading){
                    Text("Subject Breif:".localized())
                        .font(Font.bold(size: 13))
                        .foregroundColor(.mainBlue)
                    
                    if let teacherBrief = teacher.teacherBrief{
                        Text(teacherBrief)
                            .font(.semiBold(size: 12))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(5)
                            .foregroundColor(.mainBlue)
                            .frame(minHeight:40)
                            .padding(.bottom,8)
                    }else{
                        Text(teacher.SubjectOrLessonDto?.systemBrief ?? "")
                            .font(.semiBold(size: 12))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(5)
                            .foregroundColor(.mainBlue)
                            .frame(minHeight:40)
                            .padding(.bottom,8)
                    }
                    HStack{
                        HStack(){
                            Image("img_maskgroup7cl")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor)
                                .frame(width: 12,height: 12, alignment: .center)
                            HStack(spacing:2) {
                                Text("Duration :".localized())
                                 Text("  \(teacher.duration?.formattedTime() ?? "") ")
                                    .font(Font.bold(size: 13))
                                 Text("hrs".localized())
                                    .font(Font.bold(size: 13))
                            }
                            .font(Font.regular(size: 10))
                            .foregroundColor(.mainBlue)
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        
//                        HStack{
//                            Image("groupstudentsicon")
//                                .renderingMode(.template)
//                                .foregroundColor(ColorConstants.MainColor )
//                                .frame(width: 12,height: 12, alignment: .center)
//                            Group {
//                                Text("Minimum :".localized())
//                                + Text(" \(teacher.minGroup ?? 0) ")
//                                    .font(Font.semiBold(size: 13))
//                            }
//                            .font(Font.regular(size: 10))
//                            .foregroundColor(.mainBlue)
//                            Spacer()
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    
                    HStack{
                        HStack{
                            Image("openningBookicon")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor )
                                .frame(width: 12,height: 12, alignment: .center)
                            HStack(spacing:2) {
                                Text("Lessons :".localized())
                                 Text(" \(teacher.lessonsCount ?? 0) ")
                                    .font(Font.bold(size: 13))
                            }
                            .font(Font.semiBold(size: 10))
                            .foregroundColor(.mainBlue)
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        
//                        HStack{
//                            Image("groupstudentsicon")
//                                .renderingMode(.template)
//                                .foregroundColor(ColorConstants.MainColor )
//                                .frame(width: 12,height: 12, alignment: .center)
//                            Group {
//                                Text("Maximum :".localized())
//                                + Text(" \(teacher.maxGroup ?? 0)")
//                                    .font(Font.semiBold(size: 13))
//                            }
//                            .font(Font.regular(size: 10))
//                            .foregroundColor(.mainBlue)
//                            Spacer()
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity)
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



//struct scrollableBriedText: View {
//    var text : String
//    var body: some View {
//        ScrollView(.vertical){
//            Text(text)
//                .font(.regular(size: 10))
//                .foregroundColor(.mainBlue)
//                .lineSpacing(10)
//                .multilineTextAlignment(.leading)
//                .padding(.horizontal,30)
//        }
//        .frame(minHeight:20,idealHeight:50,maxHeight: 80)
//    }
//}

struct scrollableBriefText: View {
    var text: String

    var body: some View {
        ScrollView(.vertical) {
            Text(text)
                .font(.semiBold(size: 12))
                .fontWeight(.medium)
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
                .foregroundColor(.mainBlue)
                .padding(.horizontal, 30)
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: ViewHeightKey.self, value: geometry.size.height)
                })
        }
        .frame(minHeight: 20, maxHeight: min(calculateTextHeight(), 80))
    }

    private func calculateTextHeight() -> CGFloat {
        // Estimate the height based on the text length
        let textHeight = (text as NSString).boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 60, height: .infinity),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 10)],
            context: nil
        ).height

        return textHeight + 20 // Add some padding to the estimated height
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 50
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
