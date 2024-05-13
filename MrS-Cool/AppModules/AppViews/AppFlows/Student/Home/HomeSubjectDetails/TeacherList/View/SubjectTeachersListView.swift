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
//                        AsyncImage(url: URL(string: Constants.baseURL+(teachers.items?.first?.getSubjectOrLessonDto?.image ?? "")  )){image in
//                            image
//                                .resizable()
//                        }placeholder: {
//                            Image("img_younghappysmi")
//                                .resizable()
//                        }
                        let imageURL : URL? = URL(string: Constants.baseURL+(teachers.items?.first?.getSubjectOrLessonDto?.image ?? "").reverseSlaches())
                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

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
                                    Button(action: {
                                        switch bookingcase {
                                        case .subject:
                                            destination = AnyView(SubjectDetailsView(selectedsubjectid: teacher.teacherSubjectID ?? 0))
                                        case .lesson:
                                            destination = AnyView(LessonDetailsView(selectedlessonid: teacher.teacherLessonID ?? 0))
                                        }
                                            
                                        isPush = true
                                    }, label: {
                                        TeacherCellView(teacher: teacher)
                                    })
                                    
                                        .onAppear {
                                            if let totalCount = homesubjectteachersvm.TeachersModel?.totalCount, let itemsCount = homesubjectteachersvm.TeachersModel?.items?.count, itemsCount < totalCount {
                                                // Load the next page if there are more items to fetch
                                                homesubjectteachersvm.skipCount += homesubjectteachersvm.maxResultCount
                                                homesubjectteachersvm.GetStudentSubjectTeachers()
                                            }
                                        }
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
                            VStack{
                                Group {
                                    
                                    VStack{
                                        Button(action: {
                                            isNameVisible.toggle()
                                        }, label: {
                                            HStack {
                                                Image("teacher_nameFiltericon")
                                                    .renderingMode(.template)
                                                    .foregroundColor(ColorConstants.MainColor)
                                                
                                                Text("Teacher Name".localized())
                                                    .font(.SoraBold(size: 13))
                                                    .foregroundColor(.mainBlue)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                                Image(isGenderVisible ? "img_arrowdownblue":"img_arrowright")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 15, height: 15, alignment: .center)
                                                    .foregroundColor(ColorConstants.Bluegray20099)
                                            }
                                        })
                                        .padding(.vertical)
                                        
                                        if isNameVisible{
                                            CustomTextField(iconName:"",placeholder: "Teacher Name", text: $homesubjectteachersvm.teacherName)
                                        }
                                    }
                                    
                                    VStack {
                                        Button(action: {
                                            isPriceVisible.toggle()
                                        }, label: {
                                            HStack {
                                                Image("moneyicon")
                                                    .renderingMode(.template)
                                                    .foregroundColor(ColorConstants.MainColor)
                                                
                                                Text("Price".localized())
                                                    .font(.SoraBold(size: 13))
                                                    .foregroundColor(.mainBlue)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                                Image(isGenderVisible ? "img_arrowdownblue":"img_arrowright")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 15, height: 15, alignment: .center)
                                                    .foregroundColor(ColorConstants.Bluegray20099)
                                            }
                                        })
                                        .padding(.vertical)
                                        if isPriceVisible{
                                            HStack{
                                                CustomTextField(iconName:"",placeholder: "Price From", text: $homesubjectteachersvm.teacherName)
                                                
                                                CustomTextField(iconName:"",placeholder: "Price To", text: $homesubjectteachersvm.teacherName)
                                            }
                                        }
                                    }
                                    
                                    VStack{
                                        Button(action: {
                                            isRateVisible.toggle()
                                        }, label: {
                                            HStack {
                                                Image("rate_iconfilter")
                                                    .renderingMode(.template)
                                                    .foregroundColor(ColorConstants.MainColor)
                                                
                                                Text("Rating".localized())
                                                    .font(.SoraBold(size: 13))
                                                    .foregroundColor(.mainBlue)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                                Image(isGenderVisible ? "img_arrowdownblue":"img_arrowright")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 15, height: 15, alignment: .center)
                                                    .foregroundColor(ColorConstants.Bluegray20099)
                                            }
                                        })
                                        .padding(.vertical)
                                     
                                        if isRateVisible{
                                        HStack(spacing:20){
                                            ForEach(0..<5){ num in
                                                Button(action: {
                                                    homesubjectteachersvm.rate = num + 1
                                                }, label: {
                                                    Image(systemName: homesubjectteachersvm.rate > num ? "star.fill":"star")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 35, height: 35, alignment: .center)
                                                        .foregroundColor(ColorConstants.MainColor)
                                                })
                                            }
                                        }
                                        .background(.white)
                                    }
                                    }

                                    VStack{
                                        Button(action: {
                                            isGenderVisible.toggle()
                                        }, label: {
                                        HStack {
                                            Image("img_toilet1")
                                                .renderingMode(.template)
                                                .foregroundColor(ColorConstants.MainColor)

                                            Text("Gender".localized())
                                                .font(.SoraBold(size: 13))
                                                .foregroundColor(.mainBlue)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Image(isGenderVisible ? "img_arrowdownblue":"img_arrowright")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 15, height: 15, alignment: .center)
                                                .foregroundColor(ColorConstants.Bluegray20099)
//                                                .font(.system(size: 20))
                                        }
                                        })
                                        .padding(.vertical)
                                        if isGenderVisible{
                                            HStack{
                                                Button(action: {
                                                    homesubjectteachersvm.genderCase = .Male
                                                }, label: {
                                                    HStack{
                                                        Image(systemName:homesubjectteachersvm.genderCase == .Male ? "largecircle.fill.circle":"circle")
                                                            .frame(width: 20, height: 20, alignment: .center)
                                                            .foregroundColor(ColorConstants.MainColor)
                                                        Text("Male".localized())
                                                            .font(Font.SoraSemiBold(size: 13))
                                                            .foregroundColor(.mainBlue)
                                                        Spacer()
                                                    }
                                                })
                                                Button(action: {
                                                    homesubjectteachersvm.genderCase = .Female
                                                }, label: {
                                                    HStack{
                                                        Image(systemName:homesubjectteachersvm.genderCase == .Female ? "largecircle.fill.circle":"circle")
                                                            .frame(width: 20, height: 20, alignment: .center)
                                                            .foregroundColor(ColorConstants.MainColor)
                                                        Text("Female".localized())
                                                            .font(Font.SoraSemiBold(size: 13))
                                                            .foregroundColor(.mainBlue)
                                                        Spacer()
                                                    }
                                                })
                                            }
                                            .padding()
                                        }
                                    }
                                }.padding(.top,5)
                                
//                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            homesubjectteachersvm .GetStudentSubjectTeachers()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            homesubjectteachersvm.clearFilter()
                                            homesubjectteachersvm .GetStudentSubjectTeachers()
                                            showFilter = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                            }
                            .padding(.horizontal,3)
                            .padding(.top)
//                        }
                    }
                    .padding()
//                    .frame(height:430)
                    .frame(minHeight:120)
                    .frame(maxWidth:.infinity)
                    .keyboardAdaptive()
                }
            }
            if showSort{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showSort.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showSort){
                    VStack {
                        ColorConstants.Bluegray100
                            .frame(width:50,height:5)
                            .cornerRadius(2.5)
                            .padding(.top,2.5)
                        HStack {
                            Text("Sort".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        //                        ScrollView{
                        VStack{
                            Group {
                                
                                Button(action: {
                                    homesubjectteachersvm.sortCase = .MostBooked
                                }, label: {
                                    HStack{
                                        Image(systemName:homesubjectteachersvm.sortCase == .MostBooked ? "largecircle.fill.circle":"circle")
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(ColorConstants.MainColor)
                                        Text("Most Booked ")
                                            .font(Font.SoraSemiBold(size: 13))
                                            .foregroundColor(.mainBlue)
                                        Spacer()
                                    }
                                })
                                
                                Button(action: {
                                    homesubjectteachersvm.sortCase = .TopRated
                                }, label: {
                                    HStack{
                                        Image(systemName:homesubjectteachersvm.sortCase == .TopRated ? "largecircle.fill.circle":"circle")
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(ColorConstants.MainColor)
                                        Text("Top Rated".localized())
                                            .font(Font.SoraSemiBold(size: 13))
                                            .foregroundColor(.mainBlue)
                                        Spacer()
                                    }
                                })
                                Button(action: {
                                    homesubjectteachersvm.sortCase = .PriceLowToHigh
                                }, label: {
                                    HStack{
                                        Image(systemName:homesubjectteachersvm.sortCase == .PriceLowToHigh ? "largecircle.fill.circle":"circle")
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(ColorConstants.MainColor)
                                        Text("Price Low To High".localized())
                                            .font(Font.SoraSemiBold(size: 13))
                                            .foregroundColor(.mainBlue)
                                        Spacer()
                                    }
                                })
                                Button(action: {
                                    homesubjectteachersvm.sortCase = .PriceHighToLow
                                }, label: {
                                    HStack{
                                        Image(systemName:homesubjectteachersvm.sortCase == .PriceHighToLow ? "largecircle.fill.circle":"circle")
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .foregroundColor(ColorConstants.MainColor)
                                        Text("Price High To Low".localized())
                                            .font(Font.SoraSemiBold(size: 13))
                                            .foregroundColor(.mainBlue)
                                        Spacer()
                                    }
                                })
                                
                            }.padding(.top,15)
                            
                            HStack {
                                Group{
                                    CustomButton(Title:"Apply Sort",IsDisabled: .constant(false), action: {
                                        homesubjectteachersvm .GetStudentSubjectTeachers()
                                        showSort = false
                                    })
                                    
                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                        homesubjectteachersvm.clearSort()
                                        homesubjectteachersvm .GetStudentSubjectTeachers()
                                        showSort = false
                                    })
                                } .frame(width:130,height:40)
                                    .padding(.vertical)
                            }
                        }
                        .padding(.horizontal,3)
                        .padding(.top)
                        //                        }
                    }
                    .padding()
                    //                    .frame(height:430)
                    .frame(minHeight:50)
                    .frame(maxWidth:.infinity)
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
//            AsyncImage(url: URL(string: Constants.baseURL+(teacher.teacherImage ?? "")  )){image in
//                image
//                    .resizable()
//            }placeholder: {
//                Image("img_younghappysmi")
//                    .resizable()
//            }
            let imageURL : URL? = URL(string: Constants.baseURL+(teacher.teacherImage ?? "").reverseSlaches())
            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
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
