//
//  UserTypeView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

var users:[UserType] = [
    UserType(id: 0, imgName: "student-vector",user: .Student,tintColor: .studentTint),
    UserType(id: 1, imgName: "parent-vector",user: .Parent,tintColor: .parentTint),
    UserType(id: 2, imgName: "teacher-vector",user: .Teacher,tintColor: .teacherTint)
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
