//
//  ManageSubjectCell.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//


import SwiftUI

struct ManageSubjectCell: View {
    var model = TeacherSubjectM()
    var editSubjectBtnAction : (()->())?
    var editLessonsBtnAction : (()->())?
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
                    Text(model.subjectSemesterYearName ?? "")
                        .font(Font.bold(size:13.0))
                        .foregroundColor(.mainBlue)
                        .lineSpacing(8)
                }
                
                Spacer()
                HStack(spacing: 15){
                    Rectangle().frame(width: 15, height: 15)
                        .foregroundColor(model.statusID == 1 ? .green:model.statusID == 2 ? .red:.yellow)
                    Button(action: {
                        editSubjectBtnAction?()
                    }, label: {
                        Image("img_vector_black_900_14x14")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
               
                    Button(action: {
                        editLessonsBtnAction?()
                    }, label: {
                        Image("img_group512375")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    .disabled(model.statusID == 2) // inactive
                    .opacity(model.statusID == 2 ? 0.6 : 1) // inactive
                    
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
            
            HStack (alignment:.bottom){
                VStack (alignment:.leading,spacing: 10){
                    Text(model.academicYearName ?? "")
                        .font(Font.regular(size: 12.0))
                        .lineSpacing(8)
                        .foregroundColor(.mainBlue)
                    
                        Text(model.educationLevelName ?? "")
                            .font(Font.regular(size: 12.0))
                            .foregroundColor(ColorConstants.Bluegray402)
                        
                        Text(model.educationTypeName ?? "")
                            .font(Font.regular(size: 12.0))
                            .foregroundColor(ColorConstants.Bluegray402)
                }
                .padding(.leading,30)
                
                Spacer()
                HStack (alignment:.bottom,spacing:25){
                    VStack(alignment:.leading,spacing: 5){
    //                    Spacer()
                                
                        Text("Session Price".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        Group{
                            Text("\(model.groupSessionCost ?? 0,specifier:"%.2f") ")+Text("EGP".localized())
                        }
                    .font(Font.bold(size: 10))
                    .foregroundColor(.mainBlue)
                        
                          
//                        HStack(alignment:.bottom,spacing: 4) {
//                            Text("\(model.minGroup ?? 5) - \(model.maxGroup ?? 50)")
//                        .font(Font.regular(size: 12))
//                    .foregroundColor(.mainBlue)
//                            Text("Student".localized())
//                        .font(Font.regular(size: 9))
//                    .foregroundColor(.mainBlue)
//
//                        }
                    }
                    
//                    VStack(alignment:.leading){
//    //                    Spacer()
//                        Text("Individual Info".localized())
//                            .font(Font.semiBold(size: 9))
//                            .foregroundColor(.grayBtnText)
//                        Group{
//                            Text("\(model.individualCost  ?? 0,specifier:"%.2f") ")+Text("EGP".localized())
//                        }
//                    .font(Font.regular(size: 12))
//                    .foregroundColor(.mainBlue)
//                    }
                }
            }
        }
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
        .frame(height: 160)
    }
}

#Preview {
    ManageSubjectCell(model: .init(subjectSemesterYearID: 1, minGroup: 2, groupCost: 1, individualCost: 4, maxGroup: 4, statusID: 4, id: 4, educationTypeName: "education Type Name", educationLevelName: "education Level Name", academicYearName: "academic Year Name", subjectSemesterYearName: "subject Semester Year Name", subjectDisplayName: "subject Display Name", educationTypeID: 0, educationLevelID: 0, academicYearID: 1, statusIDName: "ff", brief: "fsdg", teacherBrief: "f", teacherBriefEn: "fff", groupCostFrom: 2, groupCostTo: 4, individualCostFrom: 4, individualCostTo: 4, groupSessionCost: 55))
}
