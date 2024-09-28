//
//  TeacherHomeCellView.swift
//  MrS-Cool
//
//  Created by wecancity on 28/09/2024.
//

import SwiftUI

struct TeacherHomeCellView: View {
    var model = TeacherHomeItemM()
    var cancelBtnAction : (()->())?
    var joinBtnAction : (()->())?
    
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .top,spacing: 20) {
                Image("img_group512382")
                    .scaleEffect(1.2, anchor: .center)
                    .background(
                        Color.black.clipShape(Circle())
                            .frame(width: 30 ,height: 30)
                    )
                
                Text(model.groupName ?? "sun & wed group")
                    .font(Font.bold(size:13.0))
                    .foregroundColor(.mainBlue)
                
                Spacer()
                
                Button(action: {
                    joinBtnAction?()
                }, label: {
                    Image("microsoftteams")
                        .resizable()
                        .frame(width: 30,height: 30)
                        .aspectRatio(contentMode: .fill)
                })
                .buttonStyle(.plain)
                
                Button(action: {
                    cancelBtnAction?()
                }, label: {
                    Image("img_group")
                        .resizable()
                        .frame(width: 20,height: 25)
                        .aspectRatio(contentMode: .fill)
                })
                .buttonStyle(.plain)
            }
            HStack{
                VStack (alignment:.leading,spacing: 10){
                    Text(model.subjectName ?? "المنهج المصري العربي,المرحلة الثانوية,أولي ثانوي,الفيزياء,الترم الأول 2023")
                        .font(Font.semiBold(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
                    //                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    
                    Text(model.sessionName ?? "session 1")
                        .font(Font.semiBold(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
                    //                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                    HStack{
                        Text("Students :".localized())
                            .fontWeight(.medium)

                        Text(model.students ?? 0,format: .number)
                            .fontWeight(.semibold)

                    }
                    .font(Font.semiBold(size: 12.0))
                        .foregroundColor(ColorConstants.Black900)
                    
                }
                
                Spacer()
                
                VStack(alignment:.trailing){
                    
                    VStack(alignment:.leading,spacing: 2.5){
                        Text("Date".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.date ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.semiBold(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.mainBlue)
                        
                        Spacer().frame(height:3)
                        
                        Text("Time".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Group{
                            Text("\(model.timeFrom ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))+Text(" - \("\(model.timeTo ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))")
                                .fontWeight(.medium)

                        }
                        .font(Font.semiBold(size: 12))
                        .foregroundColor(.mainBlue)
                    }
                    .padding(.top,8)
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
    TeacherHomeCellView()
}
