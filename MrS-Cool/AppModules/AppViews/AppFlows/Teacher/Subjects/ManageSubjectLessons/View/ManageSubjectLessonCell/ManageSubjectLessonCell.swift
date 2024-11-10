//
//  ManageSubjectLessonCell.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import SwiftUI

struct ManageSubjectLessonCell: View {
    var model : TeacherUnitLesson
    var editBtnAction : (()->())?
    var addBriefBtnAction : (()->())?
    var addMaterialBtnAction : (()->())?

    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .center,spacing: 20) {
                
                Image("img_group512382")
                    .scaleEffect(1.2, anchor: .center)
                    .background(
                        Color.mainBlue.clipShape(Circle())
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
//                    Rectangle().frame(width: 15, height: 15)
//                        .foregroundColor(model.statusID == 1 ? .green:model.statusID == 2 ? .yellow:.red)
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
                        addBriefBtnAction?()
                    }, label: {
                        Image("img_group512375")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    .disabled(model.id == 0)
                    .opacity(model.id == 0 ? 0.5 : 1.0)
                    
                    Button(action: {
                        addMaterialBtnAction?()
                    }, label: {
                        Image("img_book22243953")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    .disabled(model.id == 0)
                    .opacity(model.id == 0 ? 0.5 : 1.0)
                }
            }
            
            HStack (alignment:.bottom){
                VStack (alignment:.leading){
                    Text(model.lessonName ?? "")
                        .font(Font.semiBold(size: 13))
                        .foregroundColor(.mainBlue)
                    
//                        Text(model.educationLevelName ?? "Primary")
//                            .font(Font.regular(size: 12.0))
//                            .foregroundColor(ColorConstants.Bluegray402)
                        
                    Text((model.teacherBrief == nil && model.teacherBriefEn == nil ) ? "Lesson brief not added".localized():"Lesson brief added".localized())
                            .font(Font.regular(size: 9))
                            .foregroundColor((model.teacherBrief == nil && model.teacherBriefEn == nil ) ? ColorConstants.Red400:ColorConstants.LightGreen800)
                }
                .padding(.leading,30)
                
                Spacer()
                HStack (alignment:.bottom,spacing:25){
                    VStack(alignment:.leading){
    //                    Spacer()
                                
                        Text("Group Info".localized())
                            .font(Font.bold(size: 9))
                            .foregroundColor(.grayBtnText)
                        Group{
                            Text("\(model.groupDuration?.formattedTime() ?? "00:00")")
                                .font(Font.bold(size: 13))
                            Text(String(format: "%.2f",(model.groupCost ?? 0)))+Text("EGP".localized())
                        }
                    .font(Font.semiBold(size: 12))
                    .foregroundColor(.mainBlue)
                        
//                        HStack(alignment:.bottom,spacing: 4) {
//                            Text("\(model.minGroup ?? 0) - \(model.maxGroup ?? 0)")
//                                .font(Font.regular(size: 12))
//                                .foregroundColor(.mainBlue)
//                            Text("Student".localized())
//                                .font(Font.regular(size: 9))
//                                .foregroundColor(.mainBlue)
//                            
//                        }

                    }
                    
                    VStack(alignment:.leading){
    //                    Spacer()
                        Text("Individual Info".localized())
                            .font(Font.bold(size: 9))
                            .foregroundColor(.grayBtnText)
                        Group{
                            Text("\(model.individualDuration?.formattedTime() ?? "00:00")")
                                .font(Font.bold(size: 13))

                            Text(String(format: "%.2f",(model.individualCost  ?? 0)))+Text("EGP".localized())
                        }
                    .font(Font.semiBold(size: 12))
                    .foregroundColor(.mainBlue)
                    }
                }

            }
            
        }
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    ManageSubjectLessonCell(model: TeacherUnitLesson())
}
