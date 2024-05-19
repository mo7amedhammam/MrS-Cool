//
//  StudentMostViewedSubjectCell.swift
//  MrS-Cool
//
//  Created by wecancity on 14/01/2024.
//

import Foundation
//
//  StudentHomeLessonCell.swift
//  MrS-Cool
//
//  Created by wecancity on 10/01/2024.
//

import SwiftUI

struct StudentMostViewedSubjectCell: View {
    var subject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM.init()
    @Binding var selectedsubject:StudentMostViewedSubjectsM
    var action:(()->())?

    var body: some View {
        Button(action: {
            selectedsubject = subject
            action?()

        }, label: {
            VStack(spacing:0) {
//                AsyncImage(url: URL(string: Constants.baseURL+(subject.image ?? "")  )){image in
//                    image
//                        .resizable()
//                }placeholder: {
//                    Image("img_younghappysmi")
////                        .resizable()
//                }
                let imageURL : URL? = URL(string: Constants.baseURL+(subject.image ?? "").reverseSlaches())
                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                .aspectRatio(contentMode: .fill)
                .frame(height: 126)
                .clipShape(RoundedCorners(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0))
                .clipped()
//                .padding(.top, 10)
                
                Text(subject.subjectName ?? "")
                    .font(Font.SoraSemiBold(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(subject.id == selectedsubject.id ? ColorConstants.WhiteA700 :.mainBlue)
                    .multilineTextAlignment(.center)
                    .padding(.top, 19.0)
                
//                Text(subject.image ?? "")
//                    .font(Font.SoraRegular(size: 13))
//                    .fontWeight(.semibold)
//                    .foregroundColor(ColorConstants.MainColor)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(3)
//                    .padding(.top, 5)
                
                Group{
                    if subject.id == selectedsubject.id {
                        ColorConstants.WhiteA700
                    }else{
                        ColorConstants.Gray600
                    }
                }
                .frame(height:1.1)
                .padding()
                
                VStack(spacing:12){
                    HStack{
                        Image("img_vector_black_900_20x20")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                            Text("\(subject.teacherCount ?? 0)  ")
                                .font(Font.SoraSemiBold(size: 7))
                            + Text("Available Teachers".localized())
                        }
                        .font(Font.SoraRegular(size: 7))
                        
                        .foregroundColor(subject.id == selectedsubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                        Spacer()
                    }
//                    Spacer()
                    HStack{
                        Image("img_group_512390")
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor )
                            .frame(width: 12,height: 12, alignment: .center)
                        Group {
                            Text("\(subject.lessonsCount ?? 0)  ")
                                .font(Font.SoraSemiBold(size: 7))
                            + Text("Lessons".localized())
                        }
                        .font(Font.SoraRegular(size: 7))
                        
                        .foregroundColor(subject.id == selectedsubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                        Spacer()
                    }
                    
                }.padding(.horizontal)
            
            }
            .padding(.bottom)
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0).fill(subject.id == selectedsubject.id ? .mainBlue :ColorConstants.Bluegray100.opacity(0.5))
//                .border(ColorConstants.MainColor, width: 1).cornerRadius(10)
            )
        })
    }
}

#Preview {
    StudentMostViewedSubjectCell(selectedsubject: .constant(StudentMostViewedSubjectsM.init()))
}
