//
//  HomeSubjectDetailsView.swift
//  MrS-Cool
//
//  Created by wecancity on 15/01/2024.
//

enum BookingCases{
    case subject, lesson
}
import SwiftUI

struct HomeSubjectDetailsView: View {
    var selectedsubjectid : Int
    @StateObject var homesubjectdetailsvm = HomeSubjectDetailsVM()
    
    @State var showFilter : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @State var bookingcase:BookingCases = .subject
 
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Subject Info")
            
            VStack (alignment: .leading){
                
                if let details = homesubjectdetailsvm.StudentSubjectDetails{
                    HStack {
//                        AsyncImage(url: URL(string: Constants.baseURL+(details.image ?? "")  )){image in
//                            image
//                                .resizable()
//                        }placeholder: {
//                            Image("img_younghappysmi")
//                                .resizable()
//                        }
                        let imageURL : URL? = URL(string: Constants.baseURL+(details.image ?? "").reverseSlaches())
                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60,height: 60)
                        .clipShape(Circle())
                        
                        VStack{
                            Text(details.name ?? "")
                                .font(.SoraBold(size: 18))
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
//                    Text(details.systemBrief ?? "")
//                        .font(.SoraRegular(size: 10))
//                        .foregroundColor(.mainBlue)
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal,30)
//                        .frame(minHeight: 20)
                    
                    scrollableBriedText(text:details.systemBrief ?? "")

//                    ScrollView(.vertical){
//                                Text(details.systemBrief ?? "")
//                                .font(.SoraRegular(size: 10))
//                                .foregroundColor(.mainBlue)
//                                .lineSpacing(10)
//                                .multilineTextAlignment(.leading)
//                                .padding(.horizontal,30)
//                        }
//                    .frame(minHeight:20,idealHeight:50,maxHeight: 80)

                    
                    GeometryReader { gr in
                        VStack{ // (Title - Data - Submit Button)
                            
                            HStack(){
                                SignUpHeaderTitle(Title:"Subject Content",subTitleView: AnyView(
                                    Text("\(details.getSubjectLessonsDetailsDtoList?.count ?? 0)") +
                                    Text(" units .".localized()) +
                                    Text(" \(details.lessonsCount ?? 0) ") +
                                    Text("Lessons".localized())))
                                .foregroundColor(.mainBlue)
                                .font(.SoraRegular(size: 12))
                                
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
                                Spacer().frame(height:20)
                                ForEach(details.getSubjectLessonsDetailsDtoList ?? [],id:\.self){unit in
                                    UnitListCell(unit: unit){lesson in
                                        print("lesson is ", lesson)
                                        guard lesson.availableTeacherCount ?? 0 > 0 else{return}
                                        destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: lesson.lessonID ?? 0, bookingcase: .lesson))
                                        isPush = true
                                    }
                                                    
//                                    Spacer()
//                                        .frame(height:50)
                                }

                                
                                VStack(spacing:15){
                                    HStack {
                                        Text("Booking Full Subject".localized())
                                            .font(.SoraBold(size: 18))
                                            .foregroundColor(ColorConstants.WhiteA700)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(content: {
                                        ColorConstants.MainColor.clipShape(CornersRadious(radius: 12, corners: [.topLeft,.topRight]))
                                    })
                                    
                                    HStack(){
                                        Group {
                                            Text("\(details.availableTeacherCount ?? 0)  ")
                                                .font(Font.SoraSemiBold(size: 12))
                                            + Text("Available Teachers".localized())
                                        }
                                        .font(Font.SoraRegular(size: 12))
                                        .foregroundColor(.mainBlue)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    HStack(){
//                                        Group {
                                        Text("Standard listing submission, active for 30 days".localized())
//                                                .font(Font.SoraSemiBold(size: 12))
//                                            + Text("Available Teachers".localized())
//                                        }
                                        .font(Font.SoraRegular(size: 12))
                                        .foregroundColor(.mainBlue)
                                        Spacer()
                                    }                                    .padding(.horizontal)

                                    HStack{
                                        Image("openningBookicon")
                                            .renderingMode(.template)
                                            .foregroundColor(ColorConstants.MainColor )
                                            .frame(width: 14,height: 14, alignment: .center)
                                        Group {
                                             Text("  \(details.lessonsCount ?? 0) ")
                                                .font(Font.SoraSemiBold(size: 12))
                                            + Text("Lessons".localized())
                                        }
                                        .font(Font.SoraRegular(size: 12))
                                        .foregroundColor(.mainBlue)
                                        Spacer()
                                    }                                    .padding(.horizontal)

                                    HStack{
                                        Image("moneyicon")
                                            .renderingMode(.template)
                                            .foregroundColor(ColorConstants.MainColor )
                                            .frame(width: 14,height: 14, alignment: .center)
                                        Group {
                                            Text("Highest Price :".localized())
                                            + Text("  \(details.maxPrice ?? 0,specifier: "%.1f") ")
                                                .font(Font.SoraSemiBold(size: 12))
                                            + Text("EGP".localized())
                                        }
                                        .font(Font.SoraRegular(size: 12))
                                        .foregroundColor(.mainBlue)
                                        Spacer()
                                    }                                    .padding(.horizontal)

                                    HStack{
                                        Image("moneyicon")
                                            .renderingMode(.template)
                                            .foregroundColor(ColorConstants.MainColor )
                                            .frame(width: 14,height: 14, alignment: .center)
                                        Group {
                                            Text("Lowest Price :".localized())
                                            + Text("  \(details.minPrice ?? 0,specifier: "%.1f") ")
                                                .font(Font.SoraSemiBold(size: 12))
                                            + Text("EGP".localized())
                                        }
                                        .font(Font.SoraRegular(size: 12))
                                        .foregroundColor(.mainBlue)
                                        Spacer()
                                    }                                    .padding(.horizontal)

                                    CustomButton(Title:"View Details",IsDisabled:.constant(false) , action: {
                                        guard details.availableTeacherCount ?? 0 > 0 else {return}
                                        destination = AnyView(SubjectTeachersListView(selectedsubjectorlessonid: selectedsubjectid, bookingcase: .subject))
                                        isPush = true
                                        
                                    })
                                    .frame(height: 45)
                                    .padding(.top,10)
                                    .padding(.horizontal)
                                }
                                .padding()
                                
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
            homesubjectdetailsvm.SelectedStudentSubjectId = selectedsubjectid
            homesubjectdetailsvm.GetStudentSubjectDetails()
        })
        .onDisappear {
            homesubjectdetailsvm.cleanup()
        }
        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    HomeSubjectDetailsView(selectedsubjectid: 0)
}

struct UnitListCell: View {
    var unit : GetSubjectLessonsDetailsDtoList
    @State var isLessonsVisible = false
    var lessonSelectionAction: ((UnitLessonDtoList) -> Void)? // Callback closure
    
    var body: some View {
        VStack {
            Button(action: {
                isLessonsVisible.toggle()
            }, label: {
                HStack {
                    Image("img_group_512388")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32,height: 32)
                        .background{
                            ColorConstants.MainColor.clipShape(Circle())
                        }
                    
                    Text(unit.unitName ?? "")
                        .font(.SoraSemiBold(size: 13))
                        .foregroundColor(.mainBlue)
                    Spacer()
                    Image(isLessonsVisible ? "img_arrowup":"img_arrowdown")
                        .frame(width: 30, height: 30, alignment: .center)
                    //                    .foregroundColor(iconColor == .clear ? .clear:iconColor)
                        .font(.system(size: 15))
                        .padding(.horizontal,10)
                }
            })
            
            if isLessonsVisible{
                ForEach(unit.unitLessonDtoList ?? [],id:\.self){lesson in
                    ColorConstants.Bluegray30066.opacity(0.5).frame(height: 1).padding(8)
                    Button(action: {
                        //                        selectedLesson = lesson
                        lessonSelectionAction?(lesson)
                    }, label: {
                        HStack() {
                            Image("img_book22243953")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35,height: 35)
                                .padding(10)
                                .background{
                                    ColorConstants.ParentDisableBg.opacity(0.5).clipShape(CornersRadious(radius: 12, corners: [.allCorners]))
                                }
                            
                            VStack(alignment: .leading,spacing:10){
                                Text("\(lesson.lessonName ?? "")")
                                    .font(.SoraSemiBold(size: 13))
                                    .foregroundColor(.mainBlue)
                                
                                
                                HStack{
                                    Image("moneyicon")
                                        .renderingMode(.template)
                                        .foregroundColor(ColorConstants.MainColor )
                                        .frame(width: 12,height: 12, alignment: .center)
                                    Group {
                                        Text("Min Price :".localized())
                                        + Text("  \(lesson.minPrice ?? 0,specifier: "%.1f") ")
                                            .font(Font.SoraSemiBold(size: 9))
                                        + Text("EGP".localized())
                                    }
                                    .font(Font.SoraRegular(size: 9))
                                    
                                    .foregroundColor(.mainBlue)
                                    Spacer()
                                }
                                
                                HStack{
                                    Image("moneyicon")
                                        .renderingMode(.template)
                                        .foregroundColor(ColorConstants.MainColor )
                                        .frame(width: 12,height: 12, alignment: .center)
                                    Group {
                                        Text("Max Price :".localized())
                                        + Text("  \(lesson.maxPrice ?? 0,specifier: "%.1f") ")
                                            .font(Font.SoraSemiBold(size: 9))
                                        + Text("EGP".localized())
                                    }
                                    .font(Font.SoraRegular(size: 9))
                                    
                                    .foregroundColor(.mainBlue)
                                    Spacer()
                                    
                                    HStack{
                                        Image("img_vector_black_900_20x20")
                                            .renderingMode(.template)
                                            .foregroundColor(ColorConstants.MainColor )
                                            .frame(width: 12,height: 12, alignment: .center)
                                        Group {
                                            Text("\(lesson.availableTeacherCount ?? 0)  ")
                                                .font(Font.SoraSemiBold(size: 7))
                                            + Text(" Teachers".localized())
                                        }
                                        .font(Font.SoraRegular(size: 7))
                                        
                                        .foregroundColor(.mainBlue)
//                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                    })
                }
            }
        }
        .padding()
    }
}

#Preview{
    UnitListCell(unit: GetSubjectLessonsDetailsDtoList.init())
}
