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
    var hasNavBar : Bool? = true

    var body: some View {
        VStack {
//            if hasNavBar ?? true{
                CustomTitleBarView(title: "Rates and Reviews")
//            }
            GeometryReader { gr in
                if let array = ratesvm.Rates{
                    
                    VStack(alignment:.leading) {
                        HStack (alignment:.top,spacing:15){
                            Image("MenuSt_rates")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.mainBlue)
                                .frame(width: 35, height: 35, alignment: .center)
                            
                            VStack(alignment:.leading,spacing:10){ // (Title - Data - Submit Button)
                                
                                SignUpHeaderTitle(Title: "Rates and Reviews")
                                    .foregroundStyle(Color.mainBlue)
                                
                                Group{
                                    Text("\(array.items?.first?.teacherRate ?? 4.3,specifier: "%.1f")")
                                        .font(.SoraBold(size: 30))
                                    + Text( " of 5 ".localized())
                                        .font(.SoraBold(size: 30))
                                    
                                    + Text(" /   ")
                                    + Text("\(array.items?.count ?? Int(112))  ")
                                        .font(.SoraBold(size: 16))
                                    + Text("Rate".localized())
                                        .font(.SoraRegular(size: 13))
                                }
                                .foregroundStyle(Color.mainBlue)
                            }
                        } 
//                        .redacted(reason: .placeholder)

                        List(array.items ?? [],id:\.self){rate in
                            RateCellView(rate: rate)
//                                .redacted(reason: .placeholder)
                                .onAppear {
                                    if let totalCount = ratesvm.Rates?.totalCount, let itemsCount = ratesvm.Rates?.items?.count, itemsCount < totalCount {
                                        // Load the next page if there are more items to fetch
                                        ratesvm.skipCount += ratesvm.maxResultCount
                                        ratesvm.GetRates()
                                    }
                                }
                        }.listStyle(.plain)
                    }
                     
                    .frame(minHeight:gr.size.height)
                    .onAppear(perform: {
                        ratesvm.GetRates()
                    })
                }
                
            }
            .padding(.top)
            .padding(.horizontal)
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
//        .onDisappear {
////            chatlistvm.isLoading = false
//
////            chatlistvm.cleanup()
//        }
//        .showHud(isShowing: $ratesvm.isLoading)
//        .showAlert(hasAlert: $ratesvm.isError, alertType: chatlistvm.error)
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
                Text(rate.creationDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", FormatTo:"dd  MMM  yyyy") ?? "2024-03-11T10:53:14.468Z")
                    .font(.SoraRegular(size: 14))
                    .foregroundStyle(ColorConstants.Bluegray40099)
            }
            Text(rate.teacherLessonName ?? "lesson name")
                .font(.SoraSemiBold(size: 13))
                .foregroundStyle(Color.mainBlue)
            
            Text(rate.teacherLessonComment ?? "lesson comment")
                .font(.SoraRegular(size: 14))
                .foregroundStyle(Color.mainBlue)
                .padding(.vertical,6)
            
            CustomDivider()
        }
        .listRowSpacing(0)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
