//
//  ManageSubjectCell.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//


import SwiftUI

struct ManageSubjectCell: View {
    var model = TeacherSubjectM()
    var editBtnAction : (()->())?
    var deleteBtnAction : (()->())?

    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .center,spacing: 20) {
                
                Image("img_group512382")
                    .scaleEffect(1.2, anchor: .center)
                    .background(
                        Color.black.clipShape(Circle())
                            .frame(width: 30 ,height: 30)
                    )
                
                VStack{
                    Text(model.subjectDisplayName ?? "English")
                        .font(Font.SoraSemiBold(size:13.0))
                        .foregroundColor(ColorConstants.Black900)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                HStack {
                    Rectangle().frame(width: 20, height: 20)
                        .foregroundColor(model.statusID == 1 ? .green:model.statusID == 2 ? .yellow:.red)
                    Button(action: {
                        editBtnAction?()
                    }, label: {
                        Image("img_vector_black_900_14x14")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        deleteBtnAction?()
                    }, label: {
                        Image("img_group")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                }
            }
            
            VStack (alignment:.leading,spacing: 10){
                Text(model.academicYearName ?? "Grade 1")
                    .font(Font.SoraRegular(size: 12.0))
                    .fontWeight(.regular)
                    .foregroundColor(ColorConstants.Black900)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                
//                HStack (spacing:45){
                    Text(model.educationLevelName ?? "Primary")
                        .font(Font.SoraRegular(size: 12.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Bluegray402)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
                    Text(model.educationTypeName ?? "Egyption")
                        .font(Font.SoraRegular(size: 12.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Bluegray402)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
//                }
            }
            .padding(.leading,30)
            
            
            
        }
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,
                                   bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    ManageSubjectCell()
}