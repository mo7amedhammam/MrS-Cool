//
//  UserTypeView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

var users:[UserType] = [
    UserType(id: 0, imgName: "img_group141_9",user: .Student),
    UserType(id: 1, imgName: "img_group142_14",user: .Parent),
    UserType(id: 2, imgName: "img_group140_19",user: .Teacher)
]
struct UserTypesList: View {
    @Binding var selectedUser:UserType
    var action:(()->())?
    var body: some View {
        HStack{
            ForEach(users,id: \.id){user in
                UserTypeCell(user: user, selectedUser: $selectedUser){
                    action?()
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    UserTypesList(selectedUser: .constant(UserType.init()))
}
