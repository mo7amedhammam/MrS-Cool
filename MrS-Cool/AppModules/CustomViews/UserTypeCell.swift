//
//  UserTypeCell.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

struct UserType {
    var id:Int = 1
    var title:String = "Student"
    var imgName:String = "img_group141_9"
}

import SwiftUI

struct UserTypeCell: View {
    var user:UserType = UserType.init()
    @Binding var selectedUser:UserType
    
    var body: some View {
        Button(action: {
            selectedUser = user
        }, label: {
            VStack {
                Image(user.imgName)
                    .resizable()
                    .renderingMode(.template)
                    .background(user.id == selectedUser.id ? ColorConstants.WhiteA700 :ColorConstants.Bluegray100)
                    .foregroundColor(user.id == selectedUser.id ? ColorConstants.Black900 :ColorConstants.Gray600)
                    .frame(width: 55,
                           height: 55, alignment: .center)
                    .scaledToFit()
                    .clipped()
                    .clipShape(.circle)
                    .padding(.top, 27.0)
//                    .padding(.horizontal, 31.0)
                Text(user.title.localized())
                    .font(Font.SoraSemiBold(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(user.id == selectedUser.id ? ColorConstants.WhiteA700 :ColorConstants.Gray600)
//                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
//                    .frame(width: 33.0,
//                           height: 11.0, alignment: .topLeading)
                    .padding(.vertical, 19.0)
//                    .padding(.horizontal, 33.0)
            }
            .frame(minWidth: 0,maxWidth: .infinity)
//            .frame(width: getRelativeWidth(107.0), height: getRelativeHeight(128.0),
//                   alignment: .center)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,
                                       bottomRight: 10.0)
                .fill(user.id == selectedUser.id ? ColorConstants.Black900 :ColorConstants.Bluegray100))
        })
    }
}

#Preview {
    UserTypeCell(selectedUser: .constant(UserType.init()))
}


