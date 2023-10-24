//
//  TeacherDocumentDataView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct TeacherDocumentDataView: View {
//       @Environment(\.dismiss) var dismiss
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
                            CustomDropDownField(iconName:"img_group_512390",placeholder: "Document Type *", selectedOption: $signupvm.educationType,options:lookupsvm.GendersList)

                            CustomDropDownField(iconName:"img_group_512388",placeholder: "Documents Title *", selectedOption: $signupvm.educationLevel,options:lookupsvm.GendersList)

                            CustomTextField(iconName:"img_group_512386",placeholder: "Order *", text: $signupvm.name,keyboardType: .asciiCapableNumberPad)
                        }
                        .padding([.top])

                        CustomButton(imageName:"img_group_512394",Title: "Choose Files",IsDisabled: .constant(false)){
                        }
                        .frame(height: 50)
                        .padding(.top)
                        .padding(.horizontal,80)
                        
                        Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB")
                            .lineSpacing(4)
                            .frame(minWidth: 0,maxWidth: .infinity)
                            .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                            .foregroundColor(ColorConstants.Gray901)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                        
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
        }
    }
}

#Preview{
    TeacherDocumentDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
