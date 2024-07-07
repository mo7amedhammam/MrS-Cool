//
//  PurchasedsubjectOrLessonCell.swift
//  MrS-Cool
//
//  Created by wecancity on 07/07/2024.
//

import SwiftUI

struct PurchasedsubjectOrLessonCell: View {
    var model = FinanceItem()

    var body: some View {
            VStack(alignment:.leading,spacing: 10){
                HStack(spacing: 20) {
                    Image("img_group512382")
                        .scaleEffect(1.2, anchor: .center)
                        .background(
                            ColorConstants.MainColor.clipShape(Circle())
                                .frame(width: 30 ,height: 30)
                        )
                    
                    Text(model.subjectOrLessonName ?? "")
                        .font(Font.SoraSemiBold(size:13.0))
                        .foregroundColor(.mainBlue)

                    Spacer()

                }
                HStack(alignment:.firstTextBaseline){
                    Text(model.subjectOrLessonName ?? "")
                        .font(Font.SoraSemiBold(size:13.0))
                        .foregroundColor(.mainBlue)
                    
                    Spacer()

                    VStack (alignment:.leading,spacing: 2.5){
                        Text("Teacher".localized())
                            .font(Font.SoraSemiBold(size: 9))
                            .foregroundColor(.grayBtnText)

                        Text(model.teacherName ?? "")
                            .font(Font.SoraRegular(size: 12.0))
                            .foregroundColor(.mainBlue)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(alignment:.trailing){
                        VStack(alignment:.leading,spacing: 2.5){
                            Text("Date".localized())
                                .font(Font.SoraSemiBold(size: 9))
                                .foregroundColor(.grayBtnText)
                            
                            Text("\(model.date ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                                .font(Font.SoraRegular(size: 12))
                                .foregroundColor(.mainBlue)
                            
                            Spacer().frame(height:3)
                            
                            Text("Amount".localized())
                                .font(Font.SoraSemiBold(size: 9))
                                .foregroundColor(.grayBtnText)
                            
                                Text("\(model.amount ?? 0,specifier:"%.2f")")
                            .font(Font.SoraRegular(size: 12))
                                .foregroundColor(.mainBlue)
//                            Spacer()
                        }
                        .padding(.top,8)
                    }
                }
                .frame(maxWidth:.infinity,alignment: .center)
                .padding(.leading,30)
            }
            .frame(height:110)
            .padding()
            .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .stroke(ColorConstants.Bluegray100,
                        lineWidth: 1))
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    PurchasedsubjectOrLessonCell()
}
