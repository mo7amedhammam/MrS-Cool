//
//  TeacherSubjectsDataView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct TeacherSubjectsDataView: View {
//        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    
    
    @State var isPush = false
    @State var destination = AnyView(OTPVerificationView())
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        SignUpHeaderTitle(Title: "Subjects Information")
                        // -- inputs --
                        Group {
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $signupvm.educationType,options:lookupsvm.GendersList)
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $signupvm.educationLevel,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $signupvm.academicYear,options:lookupsvm.GendersList)
                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject *", selectedOption: $signupvm.subject,options:lookupsvm.GendersList)
                        }
                        .padding([.top])
                    }.padding(.top,20)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                            })
                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                signupvm.clearTeachersSubject()
                            })
                        }
                        .frame(width:120,height: 40)
                        
                    }.padding(.vertical)
                    HStack {
                        Text("* Note: Must be enter one item at least")
                            .font(Font.SoraRegular(size: 14))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(ColorConstants.Black900)

                        Spacer()
                        
                    }
                    Spacer()
                }
                .frame(minHeight: gr.size.height)
                .padding(.horizontal)
            }
        }.onAppear(perform: {
            signupvm.isUserChangagble = false
        })
    }
}

#Preview {
    TeacherSubjectsDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
