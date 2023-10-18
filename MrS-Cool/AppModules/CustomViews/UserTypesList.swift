//
//  UserTypeView.swift
//  MrS-Cool
//
//  Created by wecancity on 17/10/2023.
//

import SwiftUI

var users:[UserType] = [
    UserType(id: 1, title: "Student", imgName: "img_group141_9"),
    UserType(id: 2, title: "Parent", imgName: "img_group142_14"),
    UserType(id: 3, title: "Teacher", imgName: "img_group140_19")
]
struct UserTypesList: View {
    @Binding var selectedUser:UserType
    var body: some View {
        HStack{
            ForEach(users,id: \.id){user in
                UserTypeCell(user: user, selectedUser: $selectedUser)
            }
        }
        .padding(.top)
    }
}

#Preview {
    UserTypesList(selectedUser: .constant(UserType.init()))
}
