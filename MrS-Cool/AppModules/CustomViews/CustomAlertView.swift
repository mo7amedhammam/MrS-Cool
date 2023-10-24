//
//  CustomAlert.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Combine
import SwiftUI

/// Alert type
public enum AlertType {
    
    case success(title: String? = nil,image: String? = "iconSuccess", message: String = "",buttonTitle:String = "Done",secondButtonTitle:String? = nil)
    case error(title: String? = nil,image:String? = "img_subtract" , message: String = "",buttonTitle:String,secondButtonTitle:String? = nil)
    case question(title: String? = nil,image:String? = "img_group" , message: String = "",buttonTitle:String,secondButtonTitle:String? = nil)
    
    func title() -> String? {
        switch self {
        case .success(title: let title,_ ,_, _, _):
            return title
        case .error(title: let title,_ ,_, _, _):
            return title
        case .question(title: let title,_ ,_, _, _):
            return title
        }
    }
    func image() -> String?{
        switch self {
        case .success(_, image:let image,_,_,_):
            return image
        case .error(_, image:let image, _, _, _):
            return image
        case .question(_, image:let image, _, _, _):
            return image
        }
    }

    func message() -> String {
        switch self {
        case .success(_,_ ,message: let message,_ ,_):
            return message
        case .error(_,_ ,message: let message,_ ,_):
            return message
            
        case .question(_,_,message:let message,_,_):
            return message
        }
    }
    
    /// Left button action text for the alert view
    var MainButtonTitle: String {
        switch self {
        case .success(_,_,_,buttonTitle:let text,_):
            return text
        case .error(_, _,_,buttonTitle:let text,_):
            return text
        case .question(_, _,_,buttonTitle:let text,_):
            return text

        }
    }
    
    /// Right button action text for the alert view
    var SecondButtonTitle: String? {
        switch self {
        case .success(_, _,_, _, secondButtonTitle:let text):
            return text
        case .error(_, _,_, _, secondButtonTitle:let text):
            return text
        case .question(_, _,_, _, secondButtonTitle:let text):
            return text

        }
    }
    
//    func height(isShowVerticalButtons: Bool = false) -> CGFloat {
//        switch self {
//        case .success:
//            return isShowVerticalButtons ? 220 : title() == "" ? 180:240
//        case .error(_,_, _, _, _):
//            return isShowVerticalButtons ? 220 : title() == "" ? 180:240
//        case .question:
//            return isShowVerticalButtons ? 220 : title() == "" ? 100:240
//
//        }
//    }
}

/// A boolean State variable is required in order to present the view.
struct CustomAlertView: View {
    
    /// Flag used to dismiss the alert on the presenting view
    @Binding var presentAlert: Bool
    
    /// The alert type being shown
    @State var alertType: AlertType = .success()
    
    /// based on this value alert buttons will show vertically
//    var haveTwoButtons:Bool? = false

//    var leftButtonText = ""
//    var rightButtonText = ""
    var leftButtonAction: (() -> ())?
    var rightButtonAction: (() -> ())?
    
//    let verticalButtonsHeight: CGFloat = 50
    
//    private let topcolor = UIColor(Color("Second_Color"))
//    private let bottomcolor =  UIColor( #colorLiteral(red: 0.4801040292, green: 0.2913792729, blue: 0.6648703814, alpha: 1) )

    var body: some View {
        
        ZStack {
            // faded background
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack(spacing: 0) {
                
                
                ZStack{
//                topcolor
//                Color(topcolor)
//                    .frame(height : 8)
//                    .frame(height: verticalButtonsHeight)

                
                if let title = alertType.title(){
                    // alert title
                    Text(title.localized())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(height: 25)
////                        .padding(.top, 16)
////                        .padding(.bottom, 8)
                        .padding(.horizontal, 16)
                }
                }
                
                if let imgStr = alertType.image(){
                    ZStack {
                            
                        Image(imgStr)
                                .resizable()
//                                .renderingMode(.template)
//                                .foregroundColor(Color("Second_Color"))
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 50, height: 50, alignment: .center)
                    }
                    .padding(.top)
                }
                
                // alert message
                Text(alertType.message().localized())
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .font(Font.SoraRegular(size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
//                    .padding(.bottom, 16)
                    .padding(.vertical)
                    .minimumScaleFactor(0.5)
                    
//                Divider()
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0.5)
//                    .padding(.all, 0)
                
                
                
                
//                if !isShowVerticalButtons {
                    HStack(spacing: 0) {
                        // left button
                        CustomButton(Title:alertType.MainButtonTitle,IsDisabled: .constant(false), action: {
                                leftButtonAction?()
                            })
                            .frame(width:100)

                        if let secondTitle = alertType.SecondButtonTitle{
                            Spacer().frame(width: 50)
                            // right button (default)
                            CustomBorderedButton(Title: secondTitle, IsDisabled: .constant(false), action: {
                                rightButtonAction?()
                            })
                            .frame(width:100)
                        }

                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 55)
                    .frame(height: 40)
                    .padding(.horizontal, 0)
                    .padding(.bottom, 20)

            }
            .background(
                Color.white
            )
            .cornerRadius(10)
            .padding(.horizontal)
        }
        
        .zIndex(2)
    }
}

#Preview {
//        CustomAlert(presentAlert: .constant(true), alertType:.error(title: "", message: "error message",lefttext: "Done",righttext: "Cancel"), haveTwoButtons:false)
    
//        CustomAlert(presentAlert: .constant(true),alertType:.question(title: "Title", message: "Are you sure you want to delete this item ?",lefttext: "Save",righttext: "Clear"),haveTwoButtons: true)
    
        CustomAlertView(presentAlert: .constant(true),alertType:.success(title: "Title", message: "succeeded",buttonTitle: "Done",secondButtonTitle: "OK"))

}


struct showAlertModifier: ViewModifier {
    @Binding var hasError: Bool
    var alertType: AlertType
    var leftAction: (() -> ())?
    var rightAction: (() -> ())?

    func body(content: Content) -> some View {
        content.overlay {
            if hasError {
                CustomAlertView(
                    presentAlert: $hasError,
                    alertType: alertType,
                    leftButtonAction: {
                        leftAction?()
                        hasError.toggle()
                    },
                    rightButtonAction: {
                        rightAction?()
                        hasError.toggle()
                    }
                )
            }
        }
    }
}

extension View {
    public func showAlert(hasAlert: Binding<Bool>, alertType: AlertType, leftAction: (() -> ())? = nil, rightAction: (() -> ())? = nil) -> some View {
        modifier(showAlertModifier(hasError: hasAlert, alertType: alertType, leftAction: leftAction, rightAction: rightAction))
    }
}
