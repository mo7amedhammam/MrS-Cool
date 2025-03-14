//
//  SubjectGroupDetailsCell.swift
//  MrS-Cool
//
//  Created by wecancity on 10/12/2023.
//


import SwiftUI

struct SubjectGroupDetailsCell: View {
    var number : Int = 0
    var model = ScheduleSlot()
    
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .top,spacing: 20) {
                Text("\(number)")
                    .font(Font.semiBold(size:16))
                    .foregroundColor(ColorConstants.Bluegray40099)
                
                Text(model.lessonName ?? "day name dau name dau one")
                    .font(Font.bold(size:13.0))
                    .lineSpacing(8)
                    .foregroundColor(.mainBlue)
                
                Spacer()
                
            }
            HStack(alignment:.center){
                Text(model.dayName ?? "day 1")
                    .font(Font.regular(size: 12.0))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.Black900)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                VStack(alignment:.leading,spacing: 5){
                    
                    VStack(alignment:.leading,spacing: 2.5){
                        
                        Text("Date".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.date ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.regular(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.mainBlue)
                    }
                    
                    HStack(){
                        VStack(alignment:.leading,spacing: 2.5){
                            Text("Start Time".localized())
                                .font(Font.semiBold(size: 9))
                                .foregroundColor(.grayBtnText)
                            
                            Text("\(model.timeFrom ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "HH:mm", FormatTo: "hh:mm aa"))
                                .font(Font.regular(size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(.mainBlue)
                        }
                        Spacer().frame(width:20)
                        VStack(alignment:.leading,spacing: 2.5){
                            Text("End Time".localized())
                                .font(Font.semiBold(size: 9))
                                .foregroundColor(.grayBtnText)
                            
                            Text("\(model.timeTo ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "HH:mm", FormatTo: "hh:mm aa"))
                                .font(Font.regular(size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(.mainBlue)
                        }
                    }
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
    SubjectGroupDetailsCell()
}
