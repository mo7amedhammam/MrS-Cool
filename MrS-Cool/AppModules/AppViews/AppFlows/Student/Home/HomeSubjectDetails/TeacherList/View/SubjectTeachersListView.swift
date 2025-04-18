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
    @State private var ScrollToTop = false
    
//    @State var isFiltering : Bool = false
    @State var subjectId : Int?
    @State var lessonId : Int?
    @State var rate : Int = 0
    @State var priceFrom : String = ""
    @State var priceTo : String = ""
    @State private var showPriceHint: Bool = false

    @State var genderCase : teachersGenders?{
        didSet{
            switch genderCase {
            case .Male:
                genderId = 1
            case .Female:
                genderId = 2
            case nil:
                genderId = nil
            }
        }
    }
    @State var genderId : Int?
    @State var teacherName : String = ""

    @State var sortCase : teachersSortCases? = .MostBooked
    
    fileprivate func clearFilter() {
        if
        rate != 0 ||
        priceFrom != "" ||
        priceTo != "" ||
        genderId != nil ||
        genderCase != nil ||
            teacherName != "" {
            rate = 0
            priceFrom = ""
            priceTo = ""
            genderId = nil
            genderCase = nil
                teacherName = ""
            homesubjectteachersvm.clearFilter()
        }
    }
    fileprivate func initFilter() {
        rate = homesubjectteachersvm.rate
        priceFrom = homesubjectteachersvm.priceFrom
        priceTo = homesubjectteachersvm.priceTo
        genderId = homesubjectteachersvm.genderId
        genderCase = homesubjectteachersvm.genderCase
        teacherName = homesubjectteachersvm.teacherName
    }
    private func checkPrices()->Bool {
           if let from = Double(priceFrom), let to = Double(priceTo) {
               showPriceHint = to < from
               return to < from
           } else {
               showPriceHint = false
               return false
           }
        
       }
    
    @ViewBuilder
    fileprivate func FilterView() -> DynamicHeightSheet<some View> {
//        return // Adjust the blur radius as needed
        DynamicHeightSheet(isPresented: $showFilter){
            VStack {
                ColorConstants.Bluegray100
                    .frame(width:50,height:5)
                    .cornerRadius(2.5)
                    .padding(.top,2.5)
                HStack {
                    Text("Filter".localized())
                        .font(Font.bold(size: 18))
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
                                        .font(.bold(size: 13))
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
                                CustomTextField(iconName:"",placeholder: "Teacher Name", text: $teacherName)
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
                                        .font(.bold(size: 13))
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
                                    CustomTextField(iconName:"",placeholder: "Price From", text: $priceFrom,keyboardType: .decimalPad)
                                        .onChange(of: priceFrom) { newValue in
                                            priceFrom = newValue.filter { $0.isEnglish }
                                            //                                                        checkPrices()
                                        }
                                    
                                    CustomTextField(iconName:"",placeholder: "Price To", text: $priceTo,keyboardType: .decimalPad)
                                        .onChange(of: priceTo) { newValue in
                                            priceTo = newValue.filter { $0.isEnglish }
                                            //                                                        checkPrices()
                                        }
                                }
                                if showPriceHint{
                                    Text("The price to should be greater than or equal the price from".localized())
                                        .font(.regular(size: 12))
                                        .foregroundColor(ColorConstants.Red400)
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
                                        .font(.bold(size: 13))
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
                                            rate = num + 1
                                        }, label: {
                                            Image(systemName: rate > num ? "star.fill":"star")
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
                                        .font(.bold(size: 13))
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
                                        genderCase = .Male
                                    }, label: {
                                        HStack{
                                            Image(systemName:genderCase == .Male ? "largecircle.fill.circle":"circle")
                                                .frame(width: 20, height: 20, alignment: .center)
                                                .foregroundColor(ColorConstants.MainColor)
                                            Text("Male".localized())
                                                .font(Font.semiBold(size: 13))
                                                .foregroundColor(.mainBlue)
                                            Spacer()
                                        }
                                    })
                                    Button(action: {
                                        genderCase = .Female
                                    }, label: {
                                        HStack{
                                            Image(systemName:genderCase == .Female ? "largecircle.fill.circle":"circle")
                                                .frame(width: 20, height: 20, alignment: .center)
                                                .foregroundColor(ColorConstants.MainColor)
                                            Text("Female".localized())
                                                .font(Font.semiBold(size: 13))
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
                                guard !checkPrices() else {return}
                                
                                homesubjectteachersvm.rate = rate
                                homesubjectteachersvm.priceFrom = priceFrom
                                homesubjectteachersvm.priceTo = priceTo
                                homesubjectteachersvm.genderCase = genderCase
                                homesubjectteachersvm.teacherName = teacherName
                                
                                homesubjectteachersvm.skipCount = 0
                                homesubjectteachersvm.GetStudentSubjectTeachers()
                                ScrollToTop = true
                                showFilter = false
                            })
                            
                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                homesubjectteachersvm.skipCount = 0
                                clearFilter()
                                homesubjectteachersvm.GetStudentSubjectTeachers()
                                isNameVisible = false
                                isPriceVisible = false
                                isRateVisible = false
                                isGenderVisible = false
                                ScrollToTop = true
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
    
    @ViewBuilder
    fileprivate func SortView() -> DynamicHeightSheet<some View> {
//        return // Adjust the blur radius as needed
        DynamicHeightSheet(isPresented: $showSort){
            VStack {
                ColorConstants.Bluegray100
                    .frame(width:50,height:5)
                    .cornerRadius(2.5)
                    .padding(.top,2.5)
                HStack {
                    Text("Sort".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                    //                                            Spacer()
                }
                //                        ScrollView{
                VStack{
                    Group {
                        Button(action: {
                            sortCase = .MostBooked
                        }, label: {
                            HStack{
                                Image(systemName:sortCase == .MostBooked ? "largecircle.fill.circle":"circle")
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(ColorConstants.MainColor)
                                Text("Most Booked ".localized())
                                    .font(Font.semiBold(size: 13))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                        })
                        
                        Button(action: {
                            sortCase = .TopRated
                        }, label: {
                            HStack{
                                Image(systemName:sortCase == .TopRated ? "largecircle.fill.circle":"circle")
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(ColorConstants.MainColor)
                                Text("Top Rated".localized())
                                    .font(Font.semiBold(size: 13))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                        })
                        Button(action: {
                            sortCase = .PriceLowToHigh
                        }, label: {
                            HStack{
                                Image(systemName:sortCase == .PriceLowToHigh ? "largecircle.fill.circle":"circle")
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(ColorConstants.MainColor)
                                Text("Price Low To High".localized())
                                    .font(Font.semiBold(size: 13))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                        })
                        Button(action: {
                            sortCase = .PriceHighToLow
                        }, label: {
                            HStack{
                                Image(systemName:sortCase == .PriceHighToLow ? "largecircle.fill.circle":"circle")
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(ColorConstants.MainColor)
                                Text("Price High To Low".localized())
                                    .font(Font.semiBold(size: 13))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                        })
                        
                    }.padding(.top,15)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Apply Sort",IsDisabled: .constant(false), action: {
                                homesubjectteachersvm.skipCount = 0
                                homesubjectteachersvm.sortCase = sortCase
                                homesubjectteachersvm .GetStudentSubjectTeachers()
                                ScrollToTop = true
                                showSort = false
                            })
                            
                            CustomBorderedButton(Title:"Default",IsDisabled: .constant(false), action: {
                                homesubjectteachersvm.skipCount = 0
                                sortCase = .MostBooked
                                homesubjectteachersvm.clearSort()
                                homesubjectteachersvm .GetStudentSubjectTeachers()
                                ScrollToTop = true
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
    
    @ViewBuilder
    fileprivate func ListTeahers(teachers:StudentHomeSubjectTeachersListM) -> some View {
        if let items = teachers.items{
            ScrollViewReader { proxy in
                List(items,id:\.id){teacher in
                    //                                    if teacher == items.first{
                    //                                        ColorConstants.Bluegray20099.frame(maxHeight:0.3)
                    //                                            .id(1) // Assign unique ID to scoll to top
                    //                                        //                                        .padding(.vertical,-20)
                    //                                            .listRowSeparator(.hidden)
                    //                                        //                                        .listRowSpacing(-15)
                    //                                            .padding(.vertical,-15)
                    //                                    }
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
                    .tag(teacher.id)
                    .onAppear {
                        guard teacher == items.last else {return}
                        if let totalCount = homesubjectteachersvm.TeachersModel?.totalCount, items.count < totalCount {
                            // Load the next page if there are more items to fetch
                            homesubjectteachersvm.skipCount += homesubjectteachersvm.maxResultCount
                            homesubjectteachersvm.GetStudentSubjectTeachers()
                        }
                    }
                    .listRowSeparator(.hidden)
                    //                                    .listRowSpacing(-15)
                    .padding(.vertical,-10)
                    .onChange(of: ScrollToTop) { value in
                        if value == true {
                            withAnimation {
                                proxy.scrollTo(items.first?.id , anchor: .bottom)
                            }
                        }
                        ScrollToTop = false
                    }
                    
                }
                .listStyle(.plain)
                //                                Spacer()
                //                                    .frame(height:50)
            }
        }
    }
    
    var body: some View {
        VStack {
            CustomTitleBarView(title:bookingcase == .subject ? "Subject Info":"Lesson Info")
            
            VStack (alignment: .leading){

                if let subjectorLesson = homesubjectteachersvm.SubjectOrLessonDto{
                    HStack {
                        //                        AsyncImage(url: URL(string: Constants.baseURL+(teachers.items?.first?.getSubjectOrLessonDto?.image ?? "")  )){image in
                        //                            image
                        //                                .resizable()
                        //                        }placeholder: {
                        //                            Image("img_younghappysmi")
                        //                                .resizable()
                        //                        }
                        if let imgurl = subjectorLesson.image{
                        let imageURL : URL? = URL(string: Constants.baseURL+imgurl.reverseSlaches())
                        KFImageLoader(url: imageURL, placeholder: Image("homelessonoicon"))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60,height: 60)
                            .clipShape(Circle())
                    }else{
                        Image("homelessonoicon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50,height: 50)
                            .padding(15)
                            .background{Color.white.clipShape(Circle())}

                    }
                        VStack(alignment:.leading,spacing: 8){
                            Text(subjectorLesson.headerName ?? "" )
                                .font(.bold(size: 18))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)
                            Text(subjectorLesson.subjectName ?? "")
                                .font(.semiBold(size: 16))
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)

                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
//                    Text(subjectorLesson.systemBrief ?? "")
//                        .font(.regular(size: 10))
//                        .foregroundColor(.mainBlue)
//                        .multilineTextAlignment(.leading)
//                        .padding(.horizontal,30)
//                        .frame(minHeight: 20)
                    scrollableBriefText(text:subjectorLesson.systemBrief ?? "")

//                    ScrollView(.vertical){
//                                Text(subjectorLesson.systemBrief ?? "")
//                                .font(.regular(size: 10))
//                                .foregroundColor(.mainBlue)
//                                .lineSpacing(10)
//                                .multilineTextAlignment(.leading)
//                                .padding(.horizontal,30)
//                        }
//                    .frame(minHeight:20,idealHeight:50,maxHeight: 80)
                    
                    
                }
                    
                if let teachers = homesubjectteachersvm.TeachersModel{
                    GeometryReader { gr in
                        VStack(alignment:.leading){ // (Title - Data - Submit Button)
                            SignUpHeaderTitle(Title:"Teachers")
                                .padding([.top,.horizontal])
                                .foregroundColor(.mainBlue)
                            
                            HStack(){
                                Button(action: {
                                    sortCase = homesubjectteachersvm.sortCase
                                    showSort = true
                                }, label: {
                                    HStack(spacing:0){
                                        Image("sorticonup")
                                        Image("sorticondown")
                                        
                                        Text(homesubjectteachersvm.sortCase?.rawValue.localized() ?? "Sort".localized())
                                            .font(.bold(size: 12))
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
                                        initFilter()
                                        showFilter = true
                                    })
                            }
//                            .padding(.top)
                            .padding(.horizontal)
                            
                            ListTeahers(teachers:teachers)
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
        .localizeView()
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onAppear(perform: {
            guard homesubjectteachersvm.skipCount == 0 else {return}
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
        .overlay{
            if showFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                    .blur(radius: 4)
                FilterView()
            }
            if showSort{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showSort.toggle()
                    }
                    .blur(radius: 4)
                SortView()
            }
        }
        .showHud(isShowing: $homesubjectteachersvm.isLoading)
        .showAlert(hasAlert: $homesubjectteachersvm.isError, alertType: homesubjectteachersvm.error)

        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    SubjectTeachersListView(selectedsubjectorlessonid: 0, bookingcase: .subject)
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(CompletedLessonsVM())
    
}


struct TeacherCellView : View {
    var teacher : SubjectTeacherM
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
            
            VStack(alignment: .leading, spacing:5){
                HStack {
                    Text(teacher.teacherName ?? "")
                        .font(.bold(size: 13))
                    Spacer()
                    HStack{
                        StarsView(rating: teacher.teacherRate ?? 0.0)
//                        RatingsView(value: Double(teacher.teacherRate ?? 0.0))
//                        if let ratescount = teacher.teacherReview, ratescount > 0{
//                            Text(" \(ratescount)")
//                                .foregroundColor(ColorConstants.Bluegray30066)
//                                .font(Font.regular(size: 12))
//                        }
                    }
                }
                
                Text(teacher.teacherBrief ?? "")
                    .font(.semiBold(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                //                    .frame(minHeight: 20)
                    .frame(height:40)
                
                HStack{
                    HStack{
                        Image("img_maskgroup7cl")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        HStack (spacing:2){
//                            Text("Duration :".localized())
//                                .fontWeight(.medium)
                             Text("  \(teacher.duration?.formattedTime() ?? "1:33") ")
                                .font(Font.bold(size: 12))
                             Text("hrs".localized())
                                .font(Font.bold(size: 12))
                        }
                        .font(Font.regular(size: 10))
                        .foregroundColor(.mainBlue)
                    }
                    Spacer()
                    HStack{
                        Image("moneyicon")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        HStack (spacing:5){
                            if let minprice = teacher.minPrice{
                                Text("\(minprice ,specifier:"%.2f")")
                                Text("-")
                                 }
                            Text("\(teacher.maxPrice ?? 0,specifier:"%.2f")")

                            Text("EGP".localized())
                        }
                        .font(Font.bold(size: 12))
                        .foregroundColor(ColorConstants.MainColor)
                    }
                }
                
            }
            .foregroundColor(.mainBlue)
            
            Spacer()
        }
        .padding(.vertical)
//        .padding(.horizontal,20)
    }
}


