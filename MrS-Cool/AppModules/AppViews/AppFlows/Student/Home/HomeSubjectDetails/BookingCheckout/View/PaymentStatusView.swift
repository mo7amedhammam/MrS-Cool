//
//  PaymentStatusView.swift
//  MrS-Cool
//
//  Created by wecancity on 11/02/2024.
//

import SwiftUI
struct PaymentStatusView: View {

    var paymentsuccess : Bool
    
//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())
    
    var body: some View {
        VStack {
            CustomTitleBarView(title:paymentsuccess ? "Payment Approved" : "Payment Failed")

            ScrollView {
                
                Image(paymentsuccess ? "payment_approved":"payment_failed")
                    .padding(.vertical)

                Text(paymentsuccess ? "Your Payment Approve\n Successfully".localized():"Your Payment Failed".localized())
                    .multilineTextAlignment(.center)
                    .font(.bold(size: 18))
                    .foregroundColor(paymentsuccess ? ColorConstants.MainColor : .red)
                    .padding(.vertical)
                    
                Text(paymentsuccess ? "Your payment had been done \nsuccessfully.".localized():"Your payment had beed Failed.".localized())
                    .multilineTextAlignment(.center)
                    .font(.regular(size: 14))
                    .foregroundColor(ColorConstants.Bluegray400)
                    .padding(.vertical,5)
  
                Text(paymentsuccess ? "Please back to your account and \nenjoy".localized():"Please back to your account and try \nagain".localized())
                    .multilineTextAlignment(.center)
                    .font(.regular(size: 14))
                    .foregroundColor(ColorConstants.Bluegray400)
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
    PaymentStatusView(paymentsuccess: true)
}
