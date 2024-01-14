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
    var action:(()->())?

    var body: some View {
        Button(action: {
            selectedlesson = lesson
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
                
                Text(lesson.lessonName ?? "Grammar And Reading")
                    .font(Font.SoraSemiBold(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 :.mainBlue)
                    .multilineTextAlignment(.center)
                    .padding(.top, 19.0)
                
                Text(lesson.subjectName ?? "Arabic")
                    .font(Font.SoraRegular(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(ColorConstants.MainColor)
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
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                           Text("\(lesson.availableTeacher ?? 25)  ")
                                .font(Font.SoraSemiBold(size: 7))
                            + Text("Available Teachers".localized())
                        }
                        .font(Font.SoraRegular(size: 7))
                        
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 : .mainBlue)
                        Spacer()
                    }
                    
                    HStack{
                        Image("img_group_black_900")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                            Text("Min Price :".localized())
                            + Text("  \(lesson.minPrice ?? 222) ")
                                .font(Font.SoraSemiBold(size: 7))
                            + Text("EGP".localized())
                        }
                        .font(Font.SoraRegular(size: 7))
                        
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 : .mainBlue)
                        Spacer()
                    }
                    
                    HStack{
                        Image("img_group_black_900")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                            Text("Max Price :".localized())
                            + Text("  \(lesson.maxPrice ?? 444) ")
                                .font(Font.SoraSemiBold(size: 7))
                            + Text("EGP".localized())
                        }
                        .font(Font.SoraRegular(size: 7))
                        
                        .foregroundColor(lesson.id == selectedlesson.id ? ColorConstants.WhiteA700 : .mainBlue)
                        Spacer()
                    }
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
    StudentHomeLessonCell(selectedlesson: .constant(StudentMostViewedLessonsM.init()))
}
