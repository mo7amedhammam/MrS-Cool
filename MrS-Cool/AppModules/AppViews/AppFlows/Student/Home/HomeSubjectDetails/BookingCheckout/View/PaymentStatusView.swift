//
//  PaymentStatusView.swift
//  MrS-Cool
//
//  Created by wecancity on 11/02/2024.
//

import SwiftUI
enum paymentstatus {
    case success
    case pending
    case failed
}
struct PaymentStatusView: View {

    var paymentsuccess : paymentstatus
    
    var title: String {
        switch paymentsuccess {
        case .success:
            "Payment Approved"
        case .pending:
            "payment_pending_title"
        case .failed:
            "Payment Failed"
        }
    }
    
    var imageName: String {
        switch paymentsuccess {
        case .success:
            "payment_approved"
        case .pending:
            "correct_green"
        case .failed:
            "payment_failed"
        }
    }
    
    var headTitle: String {
        switch paymentsuccess {
        case .success:
            "Your Payment Approve\n Successfully"
        case .pending:
            "payment_pending_headtitle"
        case .failed:
            "Your Payment Failed"
        }
    }
    var headTitleColor: Color {
        switch paymentsuccess {
        case .success:
            ColorConstants.MainColor
        case .pending:
            ColorConstants.MainColor
        case .failed:
                .red
        }
    }
    
    var subTitle1: String {
        switch paymentsuccess {
        case .success:
            "Your payment had been done \nsuccessfully"
        case .pending:
            "payment_pending_subtitle1"
        case .failed:
            "Your payment had beed Failed"
        }
    }
    var subTitle2: String {
        switch paymentsuccess {
        case .success:
            "Please back to your account and \nenjoy"
        case .pending:
            ""
        case .failed:
            "Please back to your account and try \nagain"
        }
    }
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    
    var body: some View {
        VStack {
            CustomTitleBarView(title:title)

            ScrollView {
                
                Image(imageName)
                    .padding(.vertical)
                
                VStack{
                    Text(headTitle.localized())
                        .multilineTextAlignment(.center)
                        .font(.bold(size: 18))
                        .foregroundColor(headTitleColor)
                        .padding(.vertical)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity)
                    
                    Text(subTitle1.localized())
                        .multilineTextAlignment(.center)
                        .font(.regular(size: 14))
                        .foregroundColor(ColorConstants.Bluegray400)
                        .padding(.vertical,5)
                        .lineSpacing(5)
                    
                    Text(subTitle2.localized())
                        .multilineTextAlignment(.center)
                        .font(.regular(size: 14))
                        .foregroundColor(ColorConstants.Bluegray400)
                        .lineSpacing(5)

                }
                .padding()
                .background{ColorConstants.WhiteA700.cornerRadius(10)}
                
            }.padding()

            Spacer()
            CustomButton(Title: "Go To Home", IsDisabled: .constant(false), action: {
                Helper.shared.getSelectedUserType() == .Parent ? Helper.shared.changeRoot(toView:ParentTabBarView(homeIndex:2)) : Helper.shared.changeRoot(toView:StudentTabBarView(homeIndex: 2))

//                destination = Helper.shared.getSelectedUserType() == .Parent ? AnyView(ParentTabBarView()):AnyView(StudentTabBarView())
//                isPush = true
            })
            .frame(height:40)
            .padding()
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
    
        //        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        //        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
//        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}
#Preview {
    PaymentStatusView(paymentsuccess: .pending)
}
