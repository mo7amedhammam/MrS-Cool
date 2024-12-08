//
//  TeacherRatesView.swift
//  MrS-Cool
//
//  Created by wecancity on 09/03/2024.
//

import SwiftUI

struct TeacherRatesView: View {
    @EnvironmentObject var studenthometabbarvm : StudentTabBarVM
//    @EnvironmentObject var lookupsvm : LookUpsVM
    @StateObject var ratesvm = TeacherRatesVM()
        
//    @State var showFilter : Bool = false
//    @State private var searchQuery = ""

//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
//    @State var selectedChatId : Int?
//    @State var selectedLessonId : Int = 0
//    var hasNavBar : Bool? = true

    var body: some View {
        VStack {
                CustomTitleBarView(title: "Rates and Reviews")
            GeometryReader { gr in
                VStack(alignment:.leading) {
                    HStack (alignment:.top,spacing:15){
                        Image("rates_icon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.mainBlue)
                            .frame(width: 35, height: 35, alignment: .center)
                        
                        VStack(alignment:.leading,spacing:10){ // (Title - Data - Submit Button)
                            
                            SignUpHeaderTitle(Title: "Rates and Reviews")
                                .foregroundStyle(Color.mainBlue)
                            
                            Group{
                                Text("\(ratesvm.Rate?.teacherRate ?? 0,specifier: "%.1f")")
                                    .font(.bold(size: 30))
                                + Text( " of 5 ".localized())
                                    .font(.bold(size: 30))
                                
                                + Text(" /   ")
                                + Text("\(ratesvm.RatesM?.totalCount ?? Int(0))  ")
                                    .font(.bold(size: 16))
                                + Text("Rate".localized())
                                    .font(.regular(size: 13))
                            }
                            .foregroundStyle(Color.mainBlue)
                        }
                    }
//                    ScrollView{
//                        LazyVStack{
                                             
//                    List{
                        List(ratesvm.RatesArr ?? [], id:\.self){rate in
                            RateCellView(rate: rate)
                                .onAppear {
                                    guard rate == ratesvm.RatesArr?.last else {return}
                                    if let totalCount = ratesvm.RatesM?.totalCount ,ratesvm.RatesArr?.count ?? 0 < totalCount{
                                        // Load the next page if there are more items to fetch
                                        ratesvm.skipCount += ratesvm.maxResultCount
                                        ratesvm.GetRates()
                                    }
                                }
//                        }
                    }.listStyle(.plain)
//
//                    }
                    }
                     
                    .frame(minHeight:gr.size.height)
                
            }
            .padding(.top)
            .padding(.horizontal)
            
        }
        
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onAppear(perform: {
            ratesvm.GetRates()
        })

//        .onDisappear {
////            chatlistvm.isLoading = false
//
////            chatlistvm.cleanup()
//        }
        .showHud(isShowing: $ratesvm.isLoading)
        .showAlert(hasAlert: $ratesvm.isError, alertType: ratesvm.error)
//        if hasNavBar == true{
//            NavigationLink(destination: destination, isActive: $isPush, label: {})
//        }
    }

    
}

#Preview {
    TeacherRatesView()
        .environmentObject(StudentTabBarVM())
//        .environmentObject(ChatListVM())
    
}

struct RateCellView: View {
     var rate:RateItem
    var body: some View {
        VStack(alignment:.leading){
            HStack{
//                if let rate = rate.teacherLessonRate{
                    StarsView(rating: rate.teacherLessonRate ?? 0)
//                }
                Text(rate.creationDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", FormatTo:"dd  MMM  yyyy") ?? "2024-03-11T10:53:14.468Z")
                    .font(.regular(size: 14))
                    .foregroundStyle(ColorConstants.Bluegray40099)
            }
            Text(rate.teacherLessonName ?? "")
                .font(.bold(size: 14))
                .foregroundStyle(Color.mainBlue)
            
//            Text(rate.teacherLessonComment ?? "")
//                .font(.bold(size: 16))
//                .foregroundStyle(Color.mainBlue)
//                .padding(.vertical,6)
            
            CustomDivider()
        }
        .listRowSpacing(0)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
