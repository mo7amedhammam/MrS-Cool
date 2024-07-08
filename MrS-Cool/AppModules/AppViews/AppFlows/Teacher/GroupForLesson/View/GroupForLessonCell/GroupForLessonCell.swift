//
//  GroupForLessonCell.swift
//  MrS-Cool
//
//  Created by wecancity on 02/12/2023.
//
import SwiftUI

struct GroupForLessonCell: View {
    var model = GroupForLessonM()
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
                
                Text(model.teacherSubjectAcademicSemesterYearName ?? "day name dau name dau one")
                    .font(Font.SoraSemiBold(size:13.0))
                    .foregroundColor(.mainBlue)
                
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
            HStack{
                VStack (alignment:.leading,spacing: 10){
                    Text(model.groupName ?? "Group 1")
                        .font(Font.SoraRegular(size: 12.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Black900)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
                    Text(model.lessonName ?? "Lesson 1")
                        .font(Font.SoraRegular(size: 12.0))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Black900)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment:.trailing){
                    
                    VStack(alignment:.leading,spacing: 2.5){
                        Text("End".localized())
                            .font(Font.SoraSemiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.date ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.SoraRegular(size: 12))
                            .foregroundColor(.mainBlue)
                        
                        Spacer().frame(height:3)
                        
                        Text("Time".localized())
                            .font(Font.SoraSemiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Group{
                            Text("\(model.timeFrom ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))+Text(" - \("\(model.timeTo ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))")
                        }                         
                        .font(Font.SoraRegular(size: 12))
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
    GroupForLessonCell()
}
