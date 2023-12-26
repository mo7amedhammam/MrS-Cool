//
//  ChatListCell.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//

import SwiftUI

struct ChatListCell: View {
    var model = ChatListM()
    var selectLessonBtnAction : (()->())?
    
    @State var isExpanded = false
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .center,spacing: 20) {
                AsyncImage(url: URL(string: Constants.baseURL+(model.studentName ?? "")  )){image in
                    image
                        .resizable()
                }placeholder: {
                    Image("img_younghappysmi")
                        .resizable()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 40,height: 40)
                .clipShape(Circle())
                
//                Image("img_younghappysmi")
//                    .scaleEffect(1.2, anchor: .center)
//                    .background(
//                        Color.black.clipShape(Circle())
//                            .frame(width: 30 ,height: 30)
//                    )
                
                Text(model.studentName ?? "Student Name")
                    .font(Font.SoraSemiBold(size:13.0))
                    .foregroundColor(.mainBlue)
                
                Spacer()
                if let lessonNum = model.lessonNum,lessonNum >= 0{
                    Text("\(lessonNum)")
                        .font(Font.SoraRegular(size:11))
                        .foregroundColor(.whiteA700)
                        .background{
                            ColorConstants.LightGreen800
                                .frame(width: 20, height: 20, alignment: .center)
                                .clipShape(Circle())
                        }
                }
                Image(isExpanded ? "img_arrowup":"img_arrowdown")
//                        .resizable()
//                        .frame(width: 15, height: 18,alignment: .leading)
                    .aspectRatio(contentMode: .fill)

                
                
//                Button(action: {
//                    selectLessonBtnAction?()
//                }, label: {
//                    Image("img_group8733_gray_908")
////                        .resizable()
////                        .frame(width: 15, height: 18,alignment: .leading)
//                        .aspectRatio(contentMode: .fill)
//                })
//                .buttonStyle(.plain)
            }
    
//            HStack{
//                VStack (alignment:.leading,spacing: 10){
//                    Text(model.groupName ?? "Group 1")
//                        .font(Font.SoraRegular(size: 12.0))
//                        .fontWeight(.regular)
//                        .foregroundColor(ColorConstants.Black900)
//                        .minimumScaleFactor(0.5)
//                        .multilineTextAlignment(.leading)
//
//                    Text(model.lessonName ?? "Lesson 1")
//                        .font(Font.SoraRegular(size: 12.0))
//                        .fontWeight(.regular)
//                        .foregroundColor(ColorConstants.Black900)
//                        .minimumScaleFactor(0.5)
//                        .multilineTextAlignment(.leading)
//                }
//
//                Spacer()
//
//                VStack(alignment:.trailing){
//
//                    VStack(alignment:.leading,spacing: 2.5){
//                        Text("End".localized())
//                            .font(Font.SoraSemiBold(size: 6))
//                            .foregroundColor(.grayBtnText)
//
//                        Text("\(model.date ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
//                            .font(Font.SoraRegular(size: 12))
//                            .foregroundColor(.mainBlue)
//
//                        Spacer().frame(height:3)
//
//                        Text("Time".localized())
//                            .font(Font.SoraSemiBold(size: 6))
//                            .foregroundColor(.grayBtnText)
//
//                        Group{
//                            Text("\(model.timeFrom ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))+Text(" - \("\(model.timeTo ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))")
//                        }                            .font(Font.SoraRegular(size: 12))
//                            .foregroundColor(.mainBlue)
//                    }
//                    .padding(.top,8)
//                }
//            }
//            .padding(.leading,30)

        }
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
        .onTapGesture(perform: {
            isExpanded.toggle()
        })
    }
}

#Preview {
    ChatListCell()
}
