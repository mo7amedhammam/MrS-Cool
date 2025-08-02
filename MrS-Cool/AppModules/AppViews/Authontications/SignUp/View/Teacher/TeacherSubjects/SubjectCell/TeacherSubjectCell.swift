//
//  TeacherSubjectCell.swift
//  MrS-Cool
//
//  Created by wecancity on 27/10/2023.
//

import SwiftUI

struct TeacherSubjectCell: View {
    var model = TeacherSubjectM()
    var deleteBtnAction : (()->Void)?
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
                    Text(model.subjectSemesterYearName ?? "English")
                        .font(Font.semiBold(size:13.0))
                        .foregroundColor(ColorConstants.Black900)
                        .fontWeight(.semibold)
                }
                
                Spacer()
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
            
            HStack(alignment: .bottom){
            VStack (alignment:.leading,spacing: 10){
                Text(model.academicYearName ?? "")
                    .font(Font.regular(size: 12.0))
                    .fontWeight(.regular)
                    .foregroundColor(ColorConstants.Black900)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                
                    Text(model.educationLevelName ?? "")
                        .font(Font.regular(size: 12.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Bluegray402)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
//                HStack (spacing:45){
                    Text(model.educationTypeName ?? "")
                        .font(Font.regular(size: 12.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Bluegray402)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
                }
                Spacer()
                VStack(alignment:.leading,spacing: 5){
                    Text("Session Price".localized())
                        .font(Font.semiBold(size: 9))
                        .foregroundColor(.grayBtnText)
                    Group{
                        Text("\(model.groupSessionCost ?? 0,specifier:"%.2f") ")+Text(appCurrency ?? "EGP".localized())
                    }
                    .font(Font.bold(size: 10))
                    .foregroundColor(.mainBlue)
                }
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
    TeacherSubjectCell(model: .init(subjectSemesterYearID: 1, minGroup: 2, groupCost: 1, individualCost: 4, maxGroup: 4, statusID: 4, id: 4, educationTypeName: "education Type Name", educationLevelName: "education Level Name", academicYearName: "academic Year Name", subjectSemesterYearName: "subject Semester Year Name", subjectDisplayName: "subject Display Name", educationTypeID: 0, educationLevelID: 0, academicYearID: 1, statusIDName: "ff", brief: "fsdg", teacherBrief: "f", teacherBriefEn: "fff", groupCostFrom: 2, groupCostTo: 4, individualCostFrom: 4, individualCostTo: 4, groupSessionCost: 55))
}
