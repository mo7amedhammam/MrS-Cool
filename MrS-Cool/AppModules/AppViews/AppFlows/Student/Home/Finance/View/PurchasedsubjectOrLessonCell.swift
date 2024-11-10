//
//  PurchasedsubjectOrLessonCell.swift
//  MrS-Cool
//
//  Created by wecancity on 07/07/2024.
//

import SwiftUI

struct PurchasedsubjectOrLessonCell: View {
    var financese:StudentFinanceCases = .Lessons
    var model = FinanceItem()

    var body: some View {
            VStack(alignment:.leading,spacing: 10){
                let subjectOrLessonName = model.subjectOrLessonName ?? ""
                let name = subjectOrLessonName.split(separator: ",").map{ String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                let Part1 = name.indices.contains(0) ? name[0] : ""
                let Part2 = name.indices.contains(1) ? name[1] : ""
                let Part3 = name.indices.contains(2) ? name[2] : ""
                let Part4 = name.indices.contains(3) ? name[3] : ""
                let Part5 = name.indices.contains(4) ? name[4] : ""
                let Part6 = name.indices.contains(5) ? name[5] : ""

                HStack(spacing: 20) {
                    Image("img_group512382")
                        .scaleEffect(1.2, anchor: .center)
                        .background(
                            ColorConstants.MainColor.clipShape(Circle())
                                .frame(width: 30 ,height: 30)
                        )
                    
                    switch financese {
                    case .Subjects:
                        HStack(spacing:0){
                            Text("\(Part4)").font(Font.bold(size:13.0))
                            Text(", ").font(Font.bold(size:13.0))

                            Text("\(Part5)").font(Font.regular(size:13.0)) .fontWeight(.medium)

                        }
                        .foregroundColor(.mainBlue)
                        .lineSpacing(5)
                        
                    case .Lessons:
                        Text("\(Part1)").font(Font.bold(size:13.0))
                            .lineLimit(2)
//                        + Text("\(Part5)").font(Font.regular(size:13.0))
//                            .foregroundColor(.mainBlue)
                            .lineSpacing(5)
                    }

                    Spacer()

                }
                HStack(alignment:.firstTextBaseline){
                    VStack (alignment: .leading,spacing:financese == .Lessons ? 5 : 10){
                        switch financese {
                        case .Subjects:
                            Text(Part3).fontWeight(.medium)
                                .foregroundColor(.mainBlue)
                            Text(Part2).fontWeight(.medium)
                            Text(Part1).fontWeight(.medium)

                        case .Lessons:
                             Text("\(Part5), ").font(Font.regular(size:13.0)).fontWeight(.medium)
                                .foregroundColor(.mainBlue) + Text(Part6).fontWeight(.medium)
                                .foregroundColor(.mainBlue)
                            Text(Part4).fontWeight(.medium)
                            Text(Part3).fontWeight(.medium)
                            Text(Part2).fontWeight(.medium)

                        }
                        

                    }
                    .font(Font.regular(size:12))
                    .foregroundColor(.grayBtnText)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                    
                    Spacer()

                    VStack (alignment:.leading,spacing: 2.5){
                        Text("Teacher".localized())
                            .font(Font.semiBold(size: 9))
                            .fontWeight(.medium)
                            .foregroundColor(.grayBtnText)

                        Text(model.teacherName ?? "")
                            .font(Font.regular(size: 12.0))
                            .fontWeight(.medium)
                            .foregroundColor(.mainBlue)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    VStack(alignment:.trailing){
                        VStack(alignment:.leading,spacing: 2.5){
                            Text("Date".localized())
                                .font(Font.semiBold(size: 9))
                                .fontWeight(.medium)
                                .foregroundColor(.grayBtnText)
                            
                            Text("\(model.date ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                                .font(Font.regular(size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(.mainBlue)
                            
                            Spacer().frame(height:3)
                            
                            Text("Amount".localized())
                                .font(Font.semiBold(size: 9))
                                .fontWeight(.medium)
                                .foregroundColor(.grayBtnText)
                            
                                Text("\(model.amount ?? 0,specifier:"%.2f")")
                            .font(Font.regular(size: 12))
                            .fontWeight(.medium)
                                .foregroundColor(.mainBlue)
//                            Spacer()
                        }
                        .padding(.top,8)
                    }
                }
                .frame(maxWidth:.infinity,alignment: .center)
                .padding(.leading,30)
            }
//            .frame(height:110)
            .padding(.horizontal)
            .padding(.vertical,8)

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
