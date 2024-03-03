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
    
    //    @State var showFilter : Bool = false
    //    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    //    @State private var currentPage = 0
    //    @State private var forwards = false
    
    
    var body: some View {
        VStack {
            CustomTitleBarView(title:checkoutvm.bookingcase == nil ? "Booking Full Subject" : checkoutvm.bookingcase == .Group ? "Booking Group Lesson":"Booking Individual Lesson")
            
            //            VStack (alignment: .leading){
            if let details = checkoutvm.Checkout{
                
                ScrollView {
                    VStack{
                        HStack {
//                            AsyncImage(url: URL(string: Constants.baseURL+(details.headerName ?? "")  )){image in
//                                image
//                                    .resizable()
//                            }placeholder: {
//                                Image("img_younghappysmi")
//                                    .resizable()
//                            }
                            let imageURL : URL? = URL(string: Constants.baseURL+(details.headerName ?? ""))
                            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60,height: 60)
                            .clipShape(Circle())
                            
                            VStack{
                                Text(details.headerName ?? "Header Name")
                                    .font(.SoraBold(size: 18))
                            }
                            .foregroundColor(.mainBlue)
                            
                            Spacer()
                        }
                        .background{
                            HStack {
                                Spacer()
                                Image("done_checkout")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 88,height: 88)
                                    .padding(.trailing,-12)
                            }
                            
                        }
                        
                        Text(details.lessonOrSubjectBrief ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
                            .font(.SoraRegular(size: 10))
                            .foregroundColor(.mainBlue)
                            .multilineTextAlignment(.leading)
                        //                        .padding(.horizontal,30)
                            .frame(minHeight: 20)
                            .padding(.bottom)
                        
                        if bookingcase == nil{
                            CheckOutFullSubjectInfo(details: details)
                        }else{
                            CheckOutLessonInfo(details: details)
                            
                        }
                        
                        
                    }
                    
                    .padding()
                    .background{
                        Color.clear.borderRadius(ColorConstants.Gray300, width: 1.5, cornerRadius: 15, corners: [.allCorners])
                    }
                    .padding()
                    
                    
                    VStack{
                        VStack(spacing: 10){
                            Image("money_checkout")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor )
                                .frame(width: 82,height: 71, alignment: .center)
                            Group {
                                Text("\(details.price ?? 222) ")
                                    .foregroundColor(.mainBlue)
                                
                                Text("EGP".localized())
                                    .foregroundColor(ColorConstants.MainColor)
                            }
                            .font(Font.SoraBold(size: 18))
                        }.padding(7)
                        
                        
                        CustomButton(Title: "Confirm Payment", IsDisabled: .constant(false), action: {
                            checkoutvm.CreateBookCheckout(Id: selectedid)
                            
                        })
                        .frame(height:40)
                        
                        CustomBorderedButton(Title:"Cancel",IsDisabled: .constant(false), action: {
                            
                        })
                        .frame(height:40)
                        
                    }
                    .padding()
                    .background{
                        Color.clear.borderRadius(ColorConstants.Gray300, width: 1.5, cornerRadius: 15, corners: [.allCorners])
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onAppear(perform: {
            checkoutvm.bookingcase =  bookingcase
            checkoutvm.GetBookCheckout(Id: selectedid)
        })
        .onDisappear {
            checkoutvm.cleanup()
        }
        .onChange(of: checkoutvm.isCheckoutSuccess, perform: { value in
            guard let value = value else{return}
            destination = AnyView(PaymentStatusView(paymentsuccess: value))
            isPush = true
        })
        .showHud(isShowing: $checkoutvm.isLoading)
        .showAlert(hasAlert: $checkoutvm.isError, alertType: checkoutvm.error)
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    BookingCheckoutView(selectedid: 0, bookingcase: .Group)
}


struct CheckOutFullSubjectInfo: View {
    let details : BookingCheckoutM
    var body: some View {
        VStack {
            HStack(spacing: 10){
                Image("teacher_nameFiltericon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Teacher".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.teacherName ?? "Teacher Name")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            CustomDivider()
            
            HStack(spacing: 10){
                Image("checkoutcal")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Start Date".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.startDate ?? "startDate")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            CustomDivider()
            
            HStack(spacing: 10){
                Image("checkoutcal")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("End Date".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.endDate ?? "startDate")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            CustomDivider()
            
            HStack(alignment: .top, spacing: 10){
                Image("checkoutcaltime")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Schedule".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                VStack{
                    ForEach(details.bookSchedules ?? [bookSchedules()],id:\.self){sched in
                        Group{
                            Text("\(sched.dayName ?? "dayname") ")+Text(sched.fromTime ?? "01:20")
                        }
                        .foregroundColor(.mainBlue)
                        .font(Font.SoraRegular(size: 10))
                    }
                }
            }
            
            CustomDivider()
            HStack(spacing: 10){
                Image("clockcheckout")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Duration".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.endDate ?? "startDate")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            
            CustomDivider()
            HStack(spacing: 10){
                Image("moneyicon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Price".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(details.price ?? 120) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
            
            CustomDivider()
            HStack(spacing: 10){
                Image("wallet_checkout")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Current Wallet Balance".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(details.price ?? 120) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
        }
    }
}

struct CheckOutLessonInfo: View {
    let details : BookingCheckoutM
    var body: some View {
        VStack {
            HStack(spacing: 10){
                Image("teacher_nameFiltericon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Teacher".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.teacherName ?? "Teacher Name")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            CustomDivider()
            
            HStack(spacing: 10){
                Image("booktypecheckout")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Booking Type".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.bookType ?? "Booking Type")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            CustomDivider()
            
            HStack(spacing: 10){
                Image("checkoutcal")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Date".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.endDate ?? "startDate")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            
            CustomDivider()
            HStack(spacing: 10){
                Image("clockcheckout")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Time".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Text(details.startDate ?? "startDate")
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraRegular(size: 10))
            }
            
            CustomDivider()
            HStack(spacing: 10){
                Image("moneyicon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Price".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(details.price ?? 120) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
            
            CustomDivider()
            HStack(spacing: 10){
                Image("wallet_checkout")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Current Wallet Balance".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(details.price ?? 120) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
        }
    }
}
