//
//  BookingCheckoutView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/02/2024.
//

import SwiftUI
//import SafariServices

struct selectedDataToBook {
//    var TLessonId:Int?
//    var TLessonSessionId:Int?
    var selectedId: Int?
    var Date,DayName,FromTime,ToTime:String?
}
struct BookingCheckoutView: View {
    @Environment(\.dismiss) var dismiss

    var selectedgroupid : selectedDataToBook
    var bookingcase:LessonCases?
    @StateObject var checkoutvm = BookingCheckoutVM()
    
    //    @State var showFilter : Bool = false
    //    @State var showSort : Bool = false
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    //    @State private var currentPage = 0
    //    @State private var forwards = false
    @State private var isPaymentSuccessful: Bool? = nil
//    @State private var showWebView = false

    
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
                            let imageURL : URL? = URL(string: Constants.baseURL+(details.image ?? "").reverseSlaches())
                            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60,height: 60)
                            .clipShape(Circle())
                            
                            VStack(alignment:.leading){
                                if let headerName = details.headerName{
                                    Text(headerName)
                                        .font(.SoraBold(size: 18))
                                }
                                if let subjectSemesterName = details.subjectSemesterName{
                                    Text(subjectSemesterName)
                                        .font(.SoraBold(size: 18))
                                }
                                Text(details.academicYearName ?? "")
                                    .font(.SoraSemiBold(size: 16))
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
                        
                        Text(details.lessonOrSubjectBrief ?? "")
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
                        Image("money_checkout")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 82,height: 71, alignment: .center)

                        Text("Total Payment".localized())
                            .foregroundColor(.mainBlue)

                    .font(Font.SoraBold(size: 18))
                        HStack(spacing: 0){
                            Group {
                                Text(String(format: "%.2f",details.paymentAmount ?? 0))
                                Text(" EGP".localized())
                            }
                            .foregroundColor(ColorConstants.MainColor)
                            .font(Font.SoraBold(size: 18))
                        }.padding(7)
                        
                        CustomButton(Title: "Confirm Payment", IsDisabled: .constant(false), action: {
//                            if Helper.shared.CheckIfLoggedIn(){
                                checkoutvm.CreateBookCheckout(Id: selectedgroupid.selectedId ?? 0)
//                                showWebView = true

//                            }else{
//                                checkoutvm.error = .error(image:"img_subtract", message: "You have to login first",buttonTitle:"OK",secondButtonTitle:"Cancel",mainBtnAction:{
////                                    destination = AnyView(SignInView())
////                                    isPush = true
//                                    Helper.shared.changeRoot(toView: SignInView())
//                                })
//                                checkoutvm.isError = true
//                            }
                        })
                        .frame(height:40)
                        
                        CustomBorderedButton(Title:"Cancel",IsDisabled: .constant(false), action: {
                          dismiss()
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
            checkoutvm.selectedDataToBook = selectedgroupid
            checkoutvm.GetBookCheckout(Id: selectedgroupid.selectedId ?? 0)
        })
        .onDisappear {
            checkoutvm.cleanup()
        }
        .onChange(of: checkoutvm.isCheckoutSuccess, perform: { value in
            guard checkoutvm.CreatedBooking?.paymentURL == nil else{return}
            destination = AnyView(PaymentStatusView(paymentsuccess: value))
            isPush = true
        })
//        .sheet(isPresented: $checkoutvm.isCheckoutSuccess) {
//            if let strurl = checkoutvm.CreatedBooking?.paymentURL{
//                SafariView(url: URL(string: strurl)!)
//            }
//        }
        
        .fullScreenCover(isPresented: .constant(checkoutvm.isCheckoutSuccess && checkoutvm.CreatedBooking?.paymentURL != nil),onDismiss: {
            guard isPaymentSuccessful != nil, let isSuccess = isPaymentSuccessful else {return}
            destination = AnyView(PaymentStatusView(paymentsuccess: isSuccess))
            isPush = true
        }) {
                  if let strurl = checkoutvm.CreatedBooking?.paymentURL, let url = URL(string: strurl) {
                      WebView(url: url, onResponseCodeReceived: { responseCode in
                          print("Response Code:", responseCode)
                          // Handle the response code here
                          if responseCode == "000" {
                              // Payment successful
                              isPaymentSuccessful = true
                              
                          } else if responseCode == "010"{
                              // Payment Cancelled
                              isPaymentSuccessful = nil
                              
                          }else {
                              // Payment failed
                              isPaymentSuccessful = false
                          }
                      checkoutvm.isCheckoutSuccess = false // to dismiss
                      })

                  }
              }
        
        
//        .sheet(isPresented: $checkoutvm.isCheckoutSuccess,onDismiss: {
//            if let isSuccess = isPaymentSuccessful {
//                print("Payment Done: \(isSuccess)")
//                // Perform any additional actions based on payment success or failure
//                destination = AnyView(PaymentStatusView(paymentsuccess: isSuccess))
//                isPush = true
//
//            }
//        }) {
//                 if let strurl = checkoutvm.CreatedBooking?.paymentURL, let url = URL(string: strurl) {
//                     PaymentWebView(url: url, isPaymentSuccessful: $isPaymentSuccessful)
//                 }
//        }
        
//        .onChange(of: isPaymentSuccessful ?? nil, perform: { value in
//            checkoutvm.isCheckoutSuccess = false // to dismiss
//            print("payment done :",value ?? false)
//        })
        
        .showHud(isShowing: $checkoutvm.isLoading)
        .showAlert(hasAlert: $checkoutvm.isError, alertType: checkoutvm.error)
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
          
    }
}

#Preview {
    BookingCheckoutView(selectedgroupid: .init(), bookingcase: .Group)
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
                Text(details.teacherName ?? "")
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
                Text("\(details.startDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "EEEE d, MMMM yyyy"))
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
                Text("\(details.endDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "EEEE d, MMMM yyyy"))
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
                    ForEach(details.bookSchedules ?? [],id:\.self){sched in
                        Group{
                            Text("\(sched.dayName ?? "") ")+Text("\(sched.fromTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
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
//                Text("\(Int(details.duration ?? "")?.formattedHrsMins() ?? "0")")
                HStack(spacing:0){
                    Text("\(Int(details.duration ?? "")?.hours ?? 0) ") + Text("hrs".localized()) + Text(", ".localized()) + Text("\(Int(details.duration ?? "")?.minutes ?? 0) ") + Text("mins".localized())
                }
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
                    Text("\(String(format: "%.2f", details.price ?? 0)) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
            HStack(spacing: 10){
                Image("moneyicon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Tax Amoun".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(String(format: "%.2f", details.taxAmount ?? 0)) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
            HStack(spacing: 10){
                Image("moneyicon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Total Price With Taxs".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(String(format: "%.2f", details.totalPriceWithTax ?? 0)) ")+Text("EGP".localized())
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
                    Text("\(String(format: "%.2f",details.currentBalance ?? 0)) ")+Text("EGP".localized())
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
                Text(details.teacherName ?? "")
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
                Text(details.bookType ?? "")
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
                Text("\(details.startDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "EEEE d, MMMM yyyy"))
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
                Text("\(details.fromTime ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a"))
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
                    Text("\(String(format: "%.2f",details.price ?? 0)) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
            HStack(spacing: 10){
                Image("taxIcon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Tax".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(String(format: "%.2f", details.taxAmount ?? 0)) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
            HStack(spacing: 10){
                Image("moneyicon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorConstants.MainColor )
                    .frame(width: 18,height: 18, alignment: .center)
                
                Text("Total Price With Tax".localized())
                    .foregroundColor(.mainBlue)
                    .font(Font.SoraBold(size: 12))
                
                Spacer()
                Group{
                    Text("\(String(format: "%.2f", details.totalPriceWithTax ?? 0)) ")+Text("EGP".localized())
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
                    Text("\(String(format: "%.2f",details.currentBalance ?? 0)) ")+Text("EGP".localized())
                }.foregroundColor(ColorConstants.MainColor)
                    .font(Font.SoraBold(size: 12))
            }
        }
    }
}


//struct SafariView: UIViewControllerRepresentable {
//    let url: URL
//
//    func makeUIViewController(context: Context) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//
//    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
//    }
//}


import SwiftUI
import WebKit

//struct WebView: UIViewRepresentable {
//    let url: URL
//    @Binding var isPaymentSuccessful: Bool?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        let request = URLRequest(url: url)
//        webView.load(request)
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {}
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            // Check the final URL after navigation
//            if let url = webView.url?.absoluteString {
//                print("url",url)
//                if url.contains("responseCode=000") {
//                    parent.isPaymentSuccessful = true
//                    print("didFinish success","responseCode=000")
//                } else if url.contains("responseCode=") {
//                    parent.isPaymentSuccessful = false
//                    print("didFinish fail","responseCode=300")
//                }
//            }
//        }
//
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if let url = navigationAction.request.url?.absoluteString {
//                print("url",url)
//                if url.contains("responseCode=000") {
//                    parent.isPaymentSuccessful = true
//                    print("decidePolicyFor success","responseCode=000")
//                } else if url.contains("responseCode=") {
//                    parent.isPaymentSuccessful = false
//                    print("decidePolicyFor fail","responseCode=300")
//
//                }
//            }
//            decisionHandler(.allow)
//        }
//
//    }
//}


struct WebView: UIViewRepresentable {
    let url: URL
//    @Binding var isPaymentSuccessful: Bool?
    var onResponseCodeReceived: ((String) -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onResponseCodeReceived: onResponseCodeReceived)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var onResponseCodeReceived: ((String) -> Void)?

        init(_ parent: WebView, onResponseCodeReceived: ((String) -> Void)?) {
            self.parent = parent
            self.onResponseCodeReceived = onResponseCodeReceived
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                print("url",url)
                if let responseCode = extractResponseCode(from: url) {
                    onResponseCodeReceived?(responseCode)
//                    parent.isPaymentSuccessful = responseCode == "000"
                }
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                print("url",url)

                if let responseCode = extractResponseCode(from: url) {
                    onResponseCodeReceived?(responseCode)
//                    parent.isPaymentSuccessful = responseCode == "000"
                }
            }
            decisionHandler(.allow)
        }

        private func extractResponseCode(from url: String) -> String? {
            if let range = url.range(of: "responseCode=") {
                let start = range.upperBound
                let end = url.index(start, offsetBy: 3, limitedBy: url.endIndex) ?? url.endIndex
                return String(url[start..<end])
            }
            return nil
        }
    }
}





//struct PaymentWebView: UIViewControllerRepresentable {
//    let url: URL
//    @Binding var isPaymentSuccessful: Bool?
//
//    func makeUIViewController(context: Context) -> WebViewController {
//        let webViewController = WebViewController()
//        webViewController.url = url
//        webViewController.isPaymentSuccessful = $isPaymentSuccessful
//        return webViewController
//    }
//
//    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {}
//
//    class WebViewController: UIViewController, WKNavigationDelegate {
//        var url: URL!
//        var webView: WKWebView!
//        var isPaymentSuccessful: Binding<Bool?>!
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            webView = WKWebView()
//            webView.navigationDelegate = self
//            view.addSubview(webView)
//
//            webView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                webView.topAnchor.constraint(equalTo: view.topAnchor),
//                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//            ])
//
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            if let url = navigationAction.request.url, url.absoluteString.contains("responseCode=000") {
//                isPaymentSuccessful.wrappedValue = true
//                dismiss(animated: true)
//            } else if let url = navigationAction.request.url, url.absoluteString.contains("responseCode=") {
//                isPaymentSuccessful.wrappedValue = false
//                dismiss(animated: true)
//            }
//            decisionHandler(.allow)
//        }
//
//        override func viewDidDisappear(_ animated: Bool) {
//            super.viewDidDisappear(animated)
//            if isBeingDismissed {
//                isPaymentSuccessful.wrappedValue = false
//            }
//        }
//
//        func dismiss(animated: Bool) {
//            self.presentingViewController?.dismiss(animated: animated)
//        }
//    }
//}
