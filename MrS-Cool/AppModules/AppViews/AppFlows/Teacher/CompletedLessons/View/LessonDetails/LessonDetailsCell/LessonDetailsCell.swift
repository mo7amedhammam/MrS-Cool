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
            
//            AsyncImage(url: URL(string: Constants.baseURL+(model.studentImageURL ?? "")  )){image in
//                image
//                    .resizable()
//            }placeholder: {
//                Image("img_younghappysmi")
//                    .resizable()
//            }
            let imageURL : URL? = URL(string: Constants.baseURL+(model.studentImageURL ?? "").reverseSlaches())
            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
            .aspectRatio(contentMode: .fill)
            .frame(width: 100,height: 100)
            .clipShape(Circle())
            HStack(alignment: .top,spacing: 20) {
                Text("Attendance".localized())
                    .font(Font.SoraRegular(size:7))
                    .foregroundColor(.mainBlue)

                Spacer()

                Group{
                    if model.studentAttended ?? true { ColorConstants.LightGreen800
                    }else{
                        ColorConstants.Red400
                    }
                }
                    .clipShape(Rectangle())
                    .frame(width: 10 ,height: 10)
            }
            
            HStack(){
                Text(model.studentName ?? "")
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

                if model.parentName != "" || ((model.parentName?.isEmpty) == nil){
                    Text(model.parentName ?? "")
                        .font(Font.SoraSemiBold(size: 10))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }else{
                    ColorConstants.Bluegray20099
                        .frame(width:50,height:4)
                        .cornerRadius(8)
                }
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
            .disabled(model.parentName == "" || ((model.parentName?.isEmpty) == nil))
            .opacity(model.parentName == "" || ((model.parentName?.isEmpty) == nil) ? 0.7 : 1)

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
