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
    @StateObject var teacherdocumentsvm = TeacherDocumentsVM()

    @State var isPush = false
    @State var destination = EmptyView()
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        HStack(alignment:.top){
                            SignUpHeaderTitle(Title: "Subjects Information")
                            Spacer()
                            Text("(3 / 3)")
                                .font(.SoraRegular(size: 14))
                                .foregroundColor(.black)
                        }
                        
                        // -- inputs --
                        Group {
                            CustomDropDownField(iconName:"img_group_512390",placeholder: "Document Type *", selectedOption: $teacherdocumentsvm.documentType,options:lookupsvm.documentTypesList)

                            CustomTextField(iconName:"img_group_512388",placeholder: "Documents Title *", text: $teacherdocumentsvm.documentTitle)

                            CustomTextField(iconName:"img_group_512386",placeholder: "Order *", text: $teacherdocumentsvm.documentOrder,keyboardType: .asciiCapableNumberPad)
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
                                teacherdocumentsvm.CreateTeacherDocument()
                            })
                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                teacherdocumentsvm.clearTeachersDocument()
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
        .onAppear(perform: {
            lookupsvm.GetDocumentTypes()
        })
        .onChange(of: teacherdocumentsvm.isTeacherHasDocuments, perform: { value in
            teacherdocumentsvm.isTeacherHasDocuments = value
        })
    }
}

#Preview{
    TeacherDocumentDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
