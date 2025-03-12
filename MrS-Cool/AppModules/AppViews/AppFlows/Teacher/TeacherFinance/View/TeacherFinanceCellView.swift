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
    var reviewBtnAction : (()->())?
    var isshowinglessonssheet : Bool = false

    var body: some View {
        VStack {
            HStack(){
                let subjectOrLessonName = model.subjectOrLessonName ?? ""
                //            let name = subjectOrLessonName.split(separator: ",").map{ String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                
                //            let Part1 = name.indices.contains(0) ? name[0] : ""
                //            let Part2 = name.indices.contains(1) ? name[1] : ""
                //            let Part3 = name.indices.contains(2) ? name[2] : ""
                //            let Part4 = name.indices.contains(3) ? name[3] : ""
                //            let Part5 = name.indices.contains(4) ? name[4] : ""
                //            let Part6 = name.indices.contains(5) ? name[5] : ""
                
                //                HStack(spacing: 20) {
                
//                if financese == .Lessons{
//                    Button(action: {
//                        reviewBtnAction?()
//                    }, label: {
//                        Image("img_group8733_gray_908")
//                            .resizable()
//                            .frame(width: 20, height: 15,alignment: .leading)
//                            .aspectRatio(contentMode: .fill)
//                    })
//                    .buttonStyle(.plain)
//                }
                
                VStack(alignment: .leading){
                    switch financese {
                    case .Subjects:
                        HStack {
                            
                         
                            
                            Text(subjectOrLessonName)
                                .font(Font.bold(size:12))
                                .lineLimit(2)
                                .lineSpacing(8)
                                .multilineTextAlignment(.leading)
                            //                        HStack(spacing:0){
                            //                            Text("\(Part4)").font(Font.semiBold(size:13.0))
                            //                            Text(", ").font(Font.semiBold(size:13.0))
                            //
                            //                            Text("\(Part5)").font(Font.regular(size:13.0))
                            //                        }
                            .foregroundColor(.mainBlue)
                            
                        }
                        
                    case .Lessons:
                        
                        Text(subjectOrLessonName)
                            .font(Font.bold(size:12))
                            .foregroundColor(.mainBlue)
                            .lineLimit(2)
                            .lineSpacing(8)
                            .multilineTextAlignment(.leading)

                        
                        //                        Text("\(Part1)").font(Font.semiBold(size:13.0))
                        //                            .lineLimit(2)
                        //                        + Text("\(Part5)").font(Font.regular(size:13.0))
                        //                            .foregroundColor(.mainBlue)
                        
                        
                    }
                    
                    HStack(spacing:2) {
                        Text("(".localized())
                        
                        Text(model.count ?? 0,format: .number)
                        Text("Reservations".localized())
                        
                        Text(")".localized())
                    }
                    .foregroundColor(.mainBlue)
                    .font(Font.regular(size:13.0))
                    .padding(.top,5)
                    

                }
                
                Spacer()
                
                Text(model.profit ?? 0,format: .number)
                    .font(Font.bold(size:13.0))
                    .foregroundColor(.mainBlue)
                    .frame(minWidth: 40,alignment: .trailing)
                
                Image(.dollarIcon)

                if financese == .Subjects{
                    Button(action: {
                        reviewBtnAction?()
                    }, label: {
                        Image("img_group8733_gray_908")
                            .resizable()
                            .frame(width: 20, height: 15,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
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
                //                             Text("\(Part5), ").font(Font.regular(size:13.0))
                //                                .foregroundColor(.mainBlue) + Text(Part6)
                //                                .foregroundColor(.mainBlue)
                //                            Text(Part4)
                //                            Text(Part3)
                //                            Text(Part2)
                //
                //                        }
                //                    }
                //                    .font(Font.regular(size:12))
                //                    .foregroundColor(.grayBtnText)
                //                    .multilineTextAlignment(.leading)
            }
            
            switch financese {
            case .Subjects:
                
                HStack {
                Group{
                    Text("Teacher Cancelled :".localized())
                    Text(model.teacherCanceled ?? 0,format: .number)
                }
                .font(Font.bold(size:12))
                .foregroundColor(.mainBlue)
            }
//                .padding(.horizontal)
                .padding(.vertical,2)
            .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack {
                    Group{
                        Text("Student Attended :".localized())
                        Text(model.studentAttend ?? 0,format: .number)
                    }
                    .font(Font.bold(size:12))
                    .foregroundColor(.mainBlue)
                    
                    Spacer()
                    
                    Group{
                        Text("student Didn't Attend :".localized())
                        Text(model.studentNotAttend ?? 0,format: .number)
                    }
                    .font(Font.bold(size:12))
                    .foregroundColor(.mainBlue)
                }
//                .padding(.horizontal)
                .padding(.vertical,2)
                .frame(maxWidth: .infinity,alignment: .leading)
        
                HStack {
                Group{
                    Text("student Cancelled :".localized())
                    Text(model.studentCanceled ?? 0,format: .number)
                }
                .font(Font.bold(size:12))
                .foregroundColor(.mainBlue)
            }
//                .padding(.horizontal)
                .padding(.top,2)
            .frame(maxWidth: .infinity,alignment: .leading)

            case .Lessons:
                HStack {
                    Group{
                        Text( "Teacher Attended :".localized())
//                        Text(model.teacherAttended == true ? "Yes".localized() : "No".localized())
                        
                        if model.teacherAttended == true {
                            ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                        }else {
                            ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                        }
                        
                    }
                    .font(Font.bold(size:12))
                    .foregroundColor(model.teacherAttended == true ? ColorConstants.LightGreen800 : ColorConstants.Red400)
                   
                    Spacer()
                    
                    Group{
                        Text("Teacher Cancelled :".localized())
//                        Text(model.teacherCanceled == 1 ? "Yes".localized() : "No".localized())
                        
                        if model.teacherCanceled == 1 {
                            ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                        }else {
                            ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                        }
                    }
                    .font(Font.bold(size:12))
                    .foregroundColor(model.teacherCanceled == 1 ? ColorConstants.LightGreen800 : ColorConstants.Red400)
                    
                }
//                .padding(.horizontal)
                .padding(.vertical,2)
                .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack {
                    Group{
                        Text("Student Attended :".localized())
                        Text(model.studentAttend ?? 0,format: .number)
                    }
                    .font(Font.bold(size:12))
                    .foregroundColor(.mainBlue)
                    
                    Spacer()
                    
                    Group{
                        Text("student Didn't Attend :".localized())
                        Text(model.studentNotAttend ?? 0,format: .number)
                    }
                    .font(Font.bold(size:12))
                    .foregroundColor(.mainBlue)
                }
//                .padding(.horizontal)
                .padding(.vertical,2)
                .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack {
                Group{
                    Text("student Cancelled :".localized())
                    Text(model.studentCanceled ?? 0,format: .number)
                }
                .font(Font.bold(size:12))
                .foregroundColor(.mainBlue)
                    
                    Spacer()

                    if let extraSession = model.extraSession{
                        Group{
                            Text("Extra Session :".localized())
                            
                            if extraSession {
                                ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                            }else{
                                ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                            }
                            
                        }
                        .font(Font.bold(size:12))
                        .foregroundColor(extraSession ? ColorConstants.LightGreen800 : ColorConstants.Red400)

                    }
            }
//                .padding(.horizontal)
                .padding(.top,2)
            .frame(maxWidth: .infinity,alignment: .leading)
                
                if isshowinglessonssheet{
                    HStack {
                        Group{
                            Text( "Alternate Session :".localized())
                            
                            if model.alternateSession == true {
                                ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                            }else {
                                ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                            }
                            
                        }
                        .font(Font.bold(size:12))
                        .foregroundColor(model.alternateSession == true ? ColorConstants.LightGreen800 : ColorConstants.Red400)
                        
                        Spacer()
                        
                    }
                    .padding(.top,5)
                    .frame(maxWidth: .infinity,alignment: .leading)
                }

            }
                
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
