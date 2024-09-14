//
//  TeacherFinanceCellView.swift
//  MrS-Cool
//
//  Created by wecancity on 14/09/2024.
//

import SwiftUI

struct TeacherFinanceCellView: View {
    var financese:StudentFinanceCases = .Lessons
    var model = TeacherFinanceItem()

    var body: some View {
            HStack{
                let subjectOrLessonName = model.subjectOrLessonName ?? ""
                let name = subjectOrLessonName.split(separator: ",").map{ String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                let Part1 = name.indices.contains(0) ? name[0] : ""
                let Part2 = name.indices.contains(1) ? name[1] : ""
                let Part3 = name.indices.contains(2) ? name[2] : ""
                let Part4 = name.indices.contains(3) ? name[3] : ""
                let Part5 = name.indices.contains(4) ? name[4] : ""
                let Part6 = name.indices.contains(5) ? name[5] : ""

//                HStack(spacing: 20) {
                    Image(.dollarIcon)

                Text(model.profit ?? 0,format: .number)
                    .font(Font.SoraRegular(size:13.0))
                    .foregroundColor(.mainBlue)
                    
                Spacer()
                
                    switch financese {
                    case .Subjects:
                        HStack(spacing:0){
                            Text("\(Part4)").font(Font.SoraSemiBold(size:13.0))
                            Text(", ").font(Font.SoraSemiBold(size:13.0))

                            Text("\(Part5)").font(Font.SoraRegular(size:13.0))
                        }
                        .foregroundColor(.mainBlue)

                    case .Lessons:
                        Text("\(Part1)").font(Font.SoraSemiBold(size:13.0))
                            .lineLimit(2)
//                        + Text("\(Part5)").font(Font.SoraRegular(size:13.0))
//                            .foregroundColor(.mainBlue)

                    }


//                    VStack (alignment: .leading,spacing:financese == .Lessons ? 5 : 10){
//                        switch financese {
//                        case .Subjects:
//                            Text(Part3)
//                                .foregroundColor(.mainBlue)
//                            Text(Part2)
//                            Text(Part1)
//
//                        case .Lessons:
//                             Text("\(Part5), ").font(Font.SoraRegular(size:13.0))
//                                .foregroundColor(.mainBlue) + Text(Part6)
//                                .foregroundColor(.mainBlue)
//                            Text(Part4)
//                            Text(Part3)
//                            Text(Part2)
//
//                        }
//                    }
//                    .font(Font.SoraRegular(size:12))
//                    .foregroundColor(.grayBtnText)
//                    .multilineTextAlignment(.leading)
                }
            
//            .frame(height:110)
            .padding()
//            .padding(.vertical,8)
            .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .stroke(ColorConstants.Bluegray100,
                        lineWidth: 1))
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    TeacherFinanceCellView()
}
