//
//  StudentHomeLessonCell.swift
//  MrS-Cool
//
//  Created by wecancity on 10/01/2024.
//

import SwiftUI

struct StudentHomeLessonCell: View {
    var lesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM.init()
    @Binding var selectedlesson:StudentMostViewedLessonsM
    var action:(()->Void)?

    var body: some View {
        Button(action: {
//            selectedlesson = lesson
            action?()

        }, label: {
            VStack(spacing:0) {
                Image("homelessonoicon")
                //                    .resizable()
                //                    .renderingMode(.template)
                    .background(Circle().fill(ColorConstants.WhiteA700)
                        .frame(width: 60,
                               height: 60, alignment: .center))
                    .aspectRatio(contentMode: .fill)
                    .padding(.top, 10)
                
                Text(lesson.lessonName ?? "")
                    .font(Font.bold(size: 13))
//                    .fontWeight(.semibold)
                    .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 :.mainBlue)
                    .multilineTextAlignment(.center)
                    .padding(.top, 19.0)
                    .lineSpacing(5)
                
                let subjectName = lesson.subjectName ?? ""
                let name = subjectName.split(separator: ",").map{ String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                let Part1 = name.indices.contains(0) ? name[0] : ""
                let remaining = name.dropFirst().joined(separator: ", ")
                Group{
                    Text(Part1)
                        .foregroundColor(lesson.id == selectedlesson.id ? .studentBtnBg : ColorConstants.MainColor)
                        .fontWeight(.medium)
                        
                    Text(remaining)
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 :.mainBlue)
                        .fontWeight(.medium)
                }
                    .font(Font.semiBold(size: 13))
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.top, 5)
                
                Group{
                    if lesson.id == selectedlesson.id {
                        ColorConstants.WhiteA700
                    }else{
                        ColorConstants.Gray600
                    }
                }
                .frame(height:1.1)
                .padding()
                
                VStack(spacing:10){
                    HStack{
                        Image("img_vector_black_900_20x20")
                            .renderingMode(.template)
//                            .foregroundColor(ColorConstants.MainColor )
                            .foregroundColor(lesson.id == selectedlesson.id ? .studentBtnBg : ColorConstants.MainColor)

                            .frame(width: 12,height: 12, alignment: .center)
                        HStack (spacing:2){
                           Text("\(lesson.availableTeacher ?? 0)  ")
                                .font(Font.bold(size: 9))
                             Text("Available Teachers".localized())
                                .fontWeight(.medium)
                        }
                        .font(Font.semiBold(size: 9))
                        
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 : .mainBlue)
//                        Spacer()
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                    HStack{
                        Image("img_group_black_900")
                            .renderingMode(.template)
//                            .foregroundColor(ColorConstants.MainColor )
                            .foregroundColor(lesson.id == selectedlesson.id ? .studentBtnBg : ColorConstants.MainColor)

                            .frame(width: 12,height: 12, alignment: .center)
                        HStack (spacing:2){
                            Text("Min Price :".localized())
                                .fontWeight(.medium)
                            Text("\(lesson.minPrice ?? 0,specifier: "%.2f")")
                                .font(Font.bold(size: 9))
                             Text("EGP".localized())
                                .font(Font.bold(size: 9))
                        }
                        .font(Font.semiBold(size: 9))
                        
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 : .mainBlue)
//                        Spacer()
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                    HStack{
                        Image("img_group_black_900")
                            .renderingMode(.template)
//                            .foregroundColor(ColorConstants.MainColor )
                            .foregroundColor(lesson.id == selectedlesson.id ? .studentBtnBg : ColorConstants.MainColor)

                            .frame(width: 12,height: 12, alignment: .center)
                        HStack (spacing:2){
                            Text("Max Price :".localized())
                                .fontWeight(.medium)
                             Text("  \(lesson.maxPrice ?? 250,specifier: "%.2f") ")
                                .font(Font.bold(size: 9))
                             Text("EGP".localized())
                                .font(Font.bold(size: 9))
                        }
                        .font(Font.semiBold(size: 9))
                        
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 : .mainBlue)
//                        Spacer()
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                }.padding(.horizontal)
            
            }
            .padding(.vertical)
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0).fill(lesson.id == selectedlesson.id ? .mainBlue :ColorConstants.Bluegray100.opacity(0.5))
//                .border(ColorConstants.MainColor, width: 1).cornerRadius(10)
            )
        })
    }
}

#Preview {
    StudentHomeLessonCell(selectedlesson: .constant(StudentMostViewedLessonsM.init(id: 0, lessonName: "less name", subjectName: "phisics,1st term 2023, G11", lessonBrief: "", availableTeacher: 2, minPrice: 220, maxPrice: 333)))
}
