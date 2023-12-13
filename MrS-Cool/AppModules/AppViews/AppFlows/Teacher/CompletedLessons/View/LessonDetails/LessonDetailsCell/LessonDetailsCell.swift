//
//  LessonDetailsCell.swift
//  MrS-Cool
//
//  Created by wecancity on 13/12/2023.
//

import SwiftUI

struct LessonDetailsCell: View {
    var model = TeacherCompletedLessonStudentList()
    var studentchatBtnAction : (()->())?
    var parentchatBtnAction : (()->())?

    var body: some View {
        VStack(spacing: 10){
            
            AsyncImage(url: URL(string: Constants.baseURL+(model.studentImageURL ?? "")  )){image in
                image
                    .resizable()
            }placeholder: {
                Image("img_younghappysmi")
                    .resizable()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 100,height: 100)
            .clipShape(Circle())
            HStack(alignment: .top,spacing: 20) {
                Text("Attendance".localized())
                    .font(Font.SoraRegular(size:7))
                    .foregroundColor(.mainBlue)

                Spacer()

                Color.black.clipShape(Rectangle())
                    .frame(width: 10 ,height: 10)
            }
            
            HStack(){
                Text(model.studentName ?? "student name ")
                    .font(Font.SoraSemiBold(size: 12.0))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    studentchatBtnAction?()
                }, label: {
                    Image("img_message2")
                        .resizable()
                        .frame(width: 16, height: 14,alignment: .leading)
                        .aspectRatio(contentMode: .fill)
                })
                .buttonStyle(.plain)
            }
            ColorConstants.Bluegray20099
                .frame(height:4)
                .cornerRadius(8)
            
            HStack(){
                Text( "parent ".localized())
                    .font(Font.SoraRegular(size:7))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.leading)

                Text(model.parentName ?? "parent name ")
                    .font(Font.SoraSemiBold(size: 10))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
                
                Button(action: {
                    parentchatBtnAction?()
                }, label: {
                    Image("img_message2")
                        .resizable()
                        .frame(width: 14, height: 13,alignment: .leading)
                        .aspectRatio(contentMode: .fill)
                })
                .buttonStyle(.plain)
            }

        }
        .padding(5)
    //        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
    //            .stroke(ColorConstants.Bluegray100,
    //                    lineWidth: 1))
    //        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
    //            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    LessonDetailsCell()
}
