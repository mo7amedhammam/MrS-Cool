//
//  LessonTeacherInfoView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/02/2024.
//

import SwiftUI

struct LessonTeacherInfoView : View {
    var teacher : TeacherLessonDetailsM = TeacherLessonDetailsM.init()
    var body: some View {
        VStack {
//            AsyncImage(url: URL(string: Constants.baseURL+(teacher.teacherImage ?? "")  )){image in
//                image
//                    .resizable()
//            }placeholder: {
//                Image("img_younghappysmi")
//                    .resizable()
//            }
            let imageURL : URL? = URL(string: Constants.baseURL+(teacher.teacherImage ?? "").reverseSlaches())
            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

            .aspectRatio(contentMode: .fill)
            .frame(width: 115,height: 115)
            .clipShape(Circle())
            
            VStack(alignment: .center, spacing:0){
                //                VStack {
                Text(teacher.teacherName ?? "")
                    .font(.SoraBold(size: 20))
                //                    Spacer()
                
                Text(teacher.teacherBIO ?? "")
                    .font(.SoraRegular(size: 9))
                    .foregroundColor(.mainBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,30)
                    .frame(minHeight:40)
                    .padding(8)
                
                if let rate = teacher.teacherRate{
                    HStack{
                        StarsView(rating: rate )
                        Text("\(rate ,specifier: "%.1f")")
                            .foregroundColor(ColorConstants.Black900)
                            .font(.SoraSemiBold(size: 13))
                    }
                }
                
                //                if let ratescount = teacher.teacherReview, ratescount > 0{
                Group{
                    Text("\(teacher.teacherReview ?? 0) ")
                    + Text("Reviews".localized())
                }
                .foregroundColor(ColorConstants.Black900)
                .font(.SoraRegular(size: 12))
                //                }
                
                HStack(spacing: 0){
                    Image("moneyicon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(ColorConstants.MainColor )
                        .frame(width: 20,height: 20, alignment: .center)
                    Group {
                        Text("  \(teacher.price ?? 0,specifier: "%.2f") ")
                        + Text("EGP".localized())
                    }
                    .font(Font.SoraBold(size: 18))
                    .foregroundColor(ColorConstants.MainColor)
                }.padding(7)
                
                ColorConstants.Bluegray30066.frame(height: 0.5).padding(.vertical,8)
                
                VStack(alignment:.leading){
                    Text("Lesson Breif:".localized())
                        .font(Font.SoraSemiBold(size: 13))
                        .foregroundColor(.mainBlue)
                    
                    if let teacherbrief = teacher.teacherBrief{
                        
                        Text(teacherbrief)
                            .font(.SoraRegular(size: 9))
                            .foregroundColor(.mainBlue)
                            .multilineTextAlignment(.leading)
                            .frame(minHeight:40)
                            .padding(.bottom,8)
                    }else{
                        
                        Text(teacher.SubjectOrLessonDto?.systemBrief ?? "")
                            .font(.SoraRegular(size: 9))
                            .foregroundColor(.mainBlue)
                            .multilineTextAlignment(.leading)
                            .frame(minHeight:40)
                            .padding(.bottom,8)
                    }
                    HStack{
                        HStack(){
                            Image("img_maskgroup7cl")
                                .renderingMode(.template)
                                .foregroundColor(ColorConstants.MainColor)
                                .frame(width: 12,height: 12, alignment: .center)
                            Group {
                                Text("Duration :".localized())
                                + Text("  \(teacher.duration?.formattedTime() ?? "1:33") ")
                                    .font(Font.SoraSemiBold(size: 11))
                                + Text("hrs".localized())
                                    .font(Font.SoraSemiBold(size: 11))
                            }
                            .font(Font.SoraRegular(size: 10))
                            .foregroundColor(.mainBlue)
//                            Spacer()
                            
//                            Image("minmaxstu")
//                                .renderingMode(.template)
//                                .foregroundColor(ColorConstants.MainColor)
//                                .frame(width: 12,height: 12, alignment: .center)
//                            Group {
//                                Text("Minimum :".localized())
//                                + Text("  \(teacher.minGroup ?? 0) ")
//                                    .font(Font.SoraSemiBold(size: 11))
//                            }
//                            .font(Font.SoraRegular(size: 10))
//                            .foregroundColor(.mainBlue)
//                            
//                            Image("minmaxstu")
//                                .renderingMode(.template)
//                                .foregroundColor(ColorConstants.MainColor)
//                                .frame(width: 12,height: 12, alignment: .center)
//                            Group {
//                                Text("Maximum :".localized())
//                                + Text("  \(teacher.maxGroup ?? 0) ")
//                                    .font(Font.SoraSemiBold(size: 11))
//                            }
//                            .font(Font.SoraRegular(size: 10))
//                            .foregroundColor(.mainBlue)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
                        
                    }
               
                }
                .padding()
            }
            .foregroundColor(.mainBlue)
        }
        .padding(.vertical)
    }
}

#Preview {
    LessonTeacherInfoView(teacher: TeacherLessonDetailsM.init())
}


