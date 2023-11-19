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
                    Text(model.subjectSemesterYearName ?? "English")
                        .font(Font.SoraSemiBold(size:13.0))
                        .foregroundColor(.mainBlue)
                }
                
                Spacer()
                HStack(spacing: 15){
                    Rectangle().frame(width: 15, height: 15)
                        .foregroundColor(model.statusID == 1 ? .green:model.statusID == 2 ? .yellow:.red)
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
                    Text(model.academicYearName ?? "Grade 1")
                        .font(Font.SoraRegular(size: 12.0))
                        .foregroundColor(.mainBlue)
                    
                        Text(model.educationLevelName ?? "Primary")
                            .font(Font.SoraRegular(size: 12.0))
                            .foregroundColor(ColorConstants.Bluegray402)
                        
                        Text(model.educationTypeName ?? "Egyption")
                            .font(Font.SoraRegular(size: 12.0))
                            .foregroundColor(ColorConstants.Bluegray402)
                }
                .padding(.leading,30)
                
                Spacer()
                HStack (alignment:.bottom,spacing:25){
                    VStack(alignment:.leading){
    //                    Spacer()
                                
                        Text("Group Info".localized())
                            .font(Font.SoraSemiBold(size: 6))
                            .foregroundColor(.grayBtnText)
                        Group{
                            Text("\(model.groupCost ?? 0) ")+Text("EGP".localized())
                        }
                    .font(Font.SoraRegular(size: 12))
                    .foregroundColor(.mainBlue)
                        
                          
                        HStack(alignment:.bottom,spacing: 4) {
                            Text("\(model.minGroup ?? 5) - \(model.maxGroup ?? 50)")
                        .font(Font.SoraRegular(size: 12))
                    .foregroundColor(.mainBlue)
                            Text("Student".localized())
                        .font(Font.SoraRegular(size: 8))
                    .foregroundColor(.mainBlue)

                        }

                    }
                    
                    VStack(alignment:.leading){
    //                    Spacer()
                        Text("Individual Info".localized())
                            .font(Font.SoraSemiBold(size: 6))
                            .foregroundColor(.grayBtnText)
                        Group{
                            Text("\(model.individualCost  ?? 0) ")+Text("EGP".localized())
                        }
                    .font(Font.SoraRegular(size: 12))
                    .foregroundColor(.mainBlue)
                    }
                }
            }
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
