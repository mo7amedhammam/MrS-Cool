//
//  CustomAlert.swift
//  MrS-Cool
//
//  Created by wecancity on 22/10/2023.
//

import Combine
import SwiftUI

/// Alert type
enum AlertType {
    
    case success(title: String = "Success",image: String = "iconSuccess", message: String = "",lefttext:String="Done",righttext:String="")
    case error(title: String,image:String = "img_subtract" , message: String = "",lefttext:String,righttext:String)
    case question(title: String,image:String = "img_group" , message: String = "",lefttext:String,righttext:String)
    
    func title() -> String {
        switch self {
        case .success(title: let title,_ ,_, _, _):
            return title
        case .error(title: let title,_ ,_, _, _):
            return title
        case .question(title: let title,_ ,_, _, _):
            return title
        }
    }
    func image() -> String{
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
    var leftActionText: String {
        switch self {
        case .success(_,_,_,lefttext:let text,_):
            return text
        case .error(_, _,_,lefttext:let text,_):
            return text
        case .question(_, _,_,lefttext:let text,_):
            return text

        }
    }
    
    /// Right button action text for the alert view
    var rightActionText: String {
        switch self {
        case .success(_, _,_, _, righttext:let text):
            return text
        case .error(_, _,_, _, righttext:let text):
            return text
        case .question(_, _,_, _, righttext:let text):
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
struct CustomAlert: View {
    
    /// Flag used to dismiss the alert on the presenting view
    @Binding var presentAlert: Bool
    
    /// The alert type being shown
    @State var alertType: AlertType = .success()
    
    /// based on this value alert buttons will show vertically
    var haveTwoButtons = false

    var leftButtonText = ""
    var rightButtonText = ""
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

                
//                if alertType.title() != "" {
//
//                    // alert title
//                    Text(alertType.title())
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .frame(height: 25)
////                        .padding(.top, 16)
////                        .padding(.bottom, 8)
//                        .padding(.horizontal, 16)
//                }
                }
                
                if alertType.image() != ""{
                    ZStack {
                        
//                        Image("img_group")
//                            .renderingMode(.template)
//                            .foregroundColor(Color(#colorLiteral(red: 0.3697291017, green: 0.2442134917, blue: 0.5784509778, alpha: 1)))
////                        .padding(.bottom, 8)
                            
                        Image(alertType.image())
                                .resizable()
//                                .renderingMode(.template)
//                                .foregroundColor(Color("Second_Color"))
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 50, height: 50, alignment: .center)
                    }
                    .padding(.top)
                }
                
                // alert message
                Text(alertType.message())
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
//                        if (!alertType.leftActionText.isEmpty) {
                            CustomButton(Title:alertType.leftActionText,IsDisabled: .constant(false), action: {
                                leftButtonAction?()
                            })
                            .frame(width:100)

                        if haveTwoButtons{
                            Spacer().frame(width:haveTwoButtons ? 50:0)
                            // right button (default)
                            CustomBorderedButton(Title: alertType.rightActionText, IsDisabled: .constant(false), action: {
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
    
        CustomAlert(presentAlert: .constant(true),alertType:.success(title: "Title", message: "succeeded",lefttext: "Done",righttext: "OK"),haveTwoButtons:false)

}
