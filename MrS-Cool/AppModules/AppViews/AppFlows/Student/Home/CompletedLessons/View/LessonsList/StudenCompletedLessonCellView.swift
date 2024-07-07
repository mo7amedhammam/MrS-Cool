//
//  StudenCompletedLessonCellView.swift
//  MrS-Cool
//
//  Created by wecancity on 20/02/2024.
//

import SwiftUI

struct StudenCompletedLessonCellView: View {
    var model = StudentCompletedLessonItemM()
    var reviewBtnAction : (()->())?
    var chatBtnAction : (()->())?
    var rateBtnAction : (()->())?

    var body: some View {
//        Button(action: {
//            reviewBtnAction?()
//        }){
            VStack(alignment:.leading,spacing: 10){
                
                HStack(spacing: 12) {
                    Image("img_group512382")
                        .scaleEffect(1.2, anchor: .center)
                        .background(
                            ColorConstants.MainColor.clipShape(Circle())
                                .frame(width: 30 ,height: 30)
                        )
                    
                    Text(model.subject ?? "")
                        .font(Font.SoraSemiBold(size:13.0))
                        .foregroundColor(.mainBlue)

                    Spacer()
                    
                    Rectangle().fill(model.attendance ?? true ? ColorConstants.LightGreen800:ColorConstants.Red400)
                        .frame(width: 10, height: 10, alignment: .center)
                    
                    Button(action: {
                        guard model.isRated == false else {return}
                        rateBtnAction?()
                    }, label: {
                        Image(systemName: model.isRated ?? false ? "star.fill" : "star")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(ColorConstants.MainColor)
                            .frame(width: 18, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fit)
                    })
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        chatBtnAction?()
                    }, label: {
                        Image("img_message2")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(ColorConstants.MainColor)
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        reviewBtnAction?()
                    }, label: {
                        Image("img_book22243953")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(ColorConstants.MainColor)
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    
//                    Button(action: {
//                        reviewBtnAction?()
//                    }, label: {
//                        Image("img_group8733_gray_908")
//    //                        .resizable()
//    //                        .frame(width: 15, height: 18,alignment: .leading)
//                            .aspectRatio(contentMode: .fill)
//                    })
//                    .buttonStyle(.plain)
                }
                HStack{
                    VStack (alignment:.leading,spacing: 10){
                        Text(model.teacherName ?? "")
                            .font(Font.SoraSemiBold(size:13.0))
                            .foregroundColor(.mainBlue)

                        Text(model.groupName ?? "")
                            .font(Font.SoraRegular(size: 12.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Black900)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                        
                        Text(model.lessonname ?? "")
                            .font(Font.SoraRegular(size: 12.0))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Black900)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    Spacer()
                    
                    VStack(alignment:.trailing){
                        VStack(alignment:.leading,spacing: 2.5){
                            Text("Date".localized())
                                .font(Font.SoraSemiBold(size: 6))
                                .foregroundColor(.grayBtnText)
                            
                            Text("\(model.date ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                                .font(Font.SoraRegular(size: 12))
                                .foregroundColor(.mainBlue)
                            
                            Spacer().frame(height:3)
                            
                            Text("Time".localized())
                                .font(Font.SoraSemiBold(size: 6))
                                .foregroundColor(.grayBtnText)
                            
                            Group{
                                Text("\(model.startTime ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))+Text(" - \("\(model.endTime ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))")
                            }                            .font(Font.SoraRegular(size: 12))
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
//        }
    }
}

#Preview {
    StudenCompletedLessonCellView()
}
