//
//  AlternateSessionCell.swift
//  MrS-Cool
//
//  Created by wecancity on 23/02/2025.
//

import SwiftUI

struct AlternateSessionCell: View {
    var model = AlternateSessoinM()
    var addBtnAction : (()->())?
    //    var joinBtnAction : (()->())?
    
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .top,spacing: 20) {
                VStack(alignment: .leading,spacing: 15){
                    HStack(spacing:20){
                        Image("img_group512382")
                            .scaleEffect(1.2, anchor: .center)
                            .background(
                                Color.black.clipShape(Circle())
                                    .frame(width: 30 ,height: 30)
                            )
                        Text(model.groupName ?? "sun & wed group")
                            .font(Font.bold(size:13.0))
                            .foregroundColor(.mainBlue)
                    }
                    
                    HStack{
                        VStack (alignment:.leading,spacing: 10){
                            Text(model.subjectName ?? "المنهج المصري العربي,المرحلة الثانوية,أولي ثانوي,الفيزياء,الترم الأول 2023")
                                .font(Font.semiBold(size: 12.0))
                                .fontWeight(.medium)
                                .foregroundColor(ColorConstants.Black900)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)
                            
                            Text(model.lessonName ?? "session 1")
                                .font(Font.semiBold(size: 12.0))
                                .fontWeight(.medium)
                                .foregroundColor(ColorConstants.Black900)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)
                            
                            HStack{
                                Text("Students :".localized())
                                    .fontWeight(.medium)
                                
                                Text(model.absentStudentCount ?? 0,format: .number)
                                    .fontWeight(.semibold)
                            }
                            .font(Font.semiBold(size: 12.0))
                            .foregroundColor(ColorConstants.Black900)
                        }
                        //                        Spacer()
                        
                    }.padding(.leading,30)
                }
                //                Spacer()
                
                /// ---- join was here -------//
                
                Button(action: {
                    addBtnAction?()
                }, label: {
                    HStack{
                        Text("Add Alternate".localized())
                            .fontWeight(.bold)
                            .foregroundColor(ColorConstants.MainColor)
                            .font(Font.semiBold(size: 12))
                        //
                        Image("clockadd")
                            .resizable()
                            .frame(width: 20, height: 20,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    }
//                    .frame(maxWidth: .infinity,alignment: .trailing)

                })
                .buttonStyle(.plain)
            }
            //            .padding(.leading,30)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    AlternateSessionCell()
}
