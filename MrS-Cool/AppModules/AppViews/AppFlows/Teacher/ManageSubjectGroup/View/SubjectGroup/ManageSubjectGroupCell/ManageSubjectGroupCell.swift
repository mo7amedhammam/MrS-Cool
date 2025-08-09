//
//  ManageSubjectGroupCell.swift
//  MrS-Cool
//
//  Created by wecancity on 09/12/2023.
//

import SwiftUI

struct ManageSubjectGroupCell: View {
    var model = SubjectGroupM()
    var reviewBtnAction : (()->())?
    var extraTimetnAction : (()->())?
    var deleteBtnAction : (()->())?

    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .top,spacing: 20) {
                Image("img_group512382")
                    .scaleEffect(1.2, anchor: .center)
                    .background(
                        Color.black.clipShape(Circle())
                            .frame(width: 30 ,height: 30)
                    )
                
                Text(model.teacherSubjectAcademicSemesterYearName ?? "")
                    .font(Font.bold(size:13.0))
                    .lineSpacing(5)
                    .foregroundColor(.mainBlue)
                
                Spacer()
                
                HStack(){
                    Button(action: {
                        reviewBtnAction?()
                    }, label: {
                        Image("img_group8733_gray_908")
                            .resizable()
                            .frame(width: 20, height: 15,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        extraTimetnAction?()
                    }, label: {
                        Image(.clockadd)
                            .resizable()
                            .frame(width: 20, height: 20,alignment: .leading)
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
            HStack{
                VStack (alignment:.leading,spacing: 5){
                    Text(model.groupName ?? "Group 1")
                        .font(Font.regular(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
//                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
//                    Text(model.groupName ?? "Lesson 1")
//                        .font(Font.regular(size: 12.0))
//                        .fontWeight(.regular)
//                        .foregroundColor(ColorConstants.Black900)
//                        .minimumScaleFactor(0.5)
//                        .multilineTextAlignment(.leading)
//                    Spacer()
                    
                    VStack(alignment:.leading,spacing: 5){
                                
                        Text("Group Price".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        Group{
                            Text("\(model.groupCost ?? 0,specifier:"%.2f") ")+Text(model.currency ?? "EGP".localized())
                        }
                    .font(Font.bold(size: 12))
                    .foregroundColor(.mainBlue)
 
                    }
                    .padding(.top,5)
                }
                
                Spacer()
                
                VStack(alignment:.trailing){
                    
                    VStack(alignment:.leading,spacing: 2.5){
                        Text("Start Date".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.startDate ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.regular(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.mainBlue)
                        
                        Spacer().frame(height:3)
                        
                        Text("End Date".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.endDate ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.regular(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.mainBlue)
                    }
                    .padding(.top,8)
                }
            }
            .padding(.leading,30)

        }
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    ManageSubjectGroupCell()
}
