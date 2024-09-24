//
//  UserTypeCell.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

enum UserTypeEnum:String{
    case Student = "Student"
    case Parent = "Parent"
    case Teacher = "Teacher"
}
struct UserType {
    var id : Int = 0
    //    var title : String = "Student"
    var imgName : String = "student-vector"
    var user : UserTypeEnum = .Student
    var tintColor : Color = .studentTint
}

import SwiftUI

struct UserTypeCell: View {
    var user:UserType 
//    = UserType.init(id: 0, imgName: "student-vector", user: .Student,tintColor: .studentTint)
    @Binding var selectedUser:UserType
    var action:(()->())?

    var body: some View {
        Button(action: {
            selectedUser = user
            action?()
//            if selectedUser.user == .Student{
//                Helper.shared.setSelectedUserType(userType: .Student)
//                
//            }else if selectedUser.user == .Parent{
//                Helper.shared.setSelectedUserType(userType: .Parent)
//
//            }else {
//                Helper.shared.setSelectedUserType(userType: .Teacher)
//            }
        }, label: {
            VStack {
                Image(user.imgName)
                    .resizable()
//                    .renderingMode(.template)
                    .background(user.id == selectedUser.id ? ColorConstants.WhiteA700 :ColorConstants.Bluegray100)
                    .foregroundColor(user.id == selectedUser.id ? ColorConstants.Black900 :ColorConstants.Gray600)
                    .frame(width: 77,
                           height: 77, alignment: .center)
                    .scaledToFit()
//                    .clipped()
                    .clipShape(.circle)
                    .padding(.top, 27.0)
                Text(user.user.rawValue.localized())
                    .font(Font.bold(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(user.id == selectedUser.id ? ColorConstants.WhiteA700 :ColorConstants.Gray600)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 19.0)
            }
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .fill(user.id == selectedUser.id ? ColorConstants.MainColor : user.tintColor))
        })
    }
}

#Preview {
    UserTypeCell(user: UserType.init(), selectedUser: .constant(UserType.init(id: 0, imgName: "student-vector", user: .Parent,tintColor: .studentTint)))
}


