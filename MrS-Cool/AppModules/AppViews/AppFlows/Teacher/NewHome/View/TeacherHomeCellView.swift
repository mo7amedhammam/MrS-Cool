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
                
                /// ---- join was here -------//
                
                //                if model.isCancel != true && isEventNotStartedYet(){
                if model.canCancel == true{
                    Button(action: {
                        cancelBtnAction?()
                    }, label: {
                        HStack{
                            Text("Cancel & Edit".localized())
                                .font(Font.bold(size: 12.0))
                                .foregroundColor(ColorConstants.Red400)
                            
                            Image("img_group")
                                .resizable()
                                .frame(width: 15,height: 20)
                                .aspectRatio(contentMode: .fill)
                        }
                    })
                    .buttonStyle(.plain)
                }
                
                if model.isCancel == true{
                    ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                }else{
                    //                    if isEventNotStartedYet(){
                    ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                    //                    }
                }
            }
            
            HStack{
                VStack (alignment:.leading,spacing: 10){
                    Text(model.subjectName ?? "المنهج المصري العربي,المرحلة الثانوية,أولي ثانوي,الفيزياء,الترم الأول 2023")
                        .font(Font.semiBold(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
                    //                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                    
                    Text(model.sessionName ?? "session 1")
                        .font(Font.semiBold(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
                    //                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                    
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
                        
                        Spacer()
                        //                if model.isCancel == false && isCurrentTimeWithinEventTime(){
                        if model.teamMeetingLink != nil {
                            Button(action: {
                                joinBtnAction?()
                            }, label: {
                                HStack {
                                    Text("Join Now".localized())
                                        .fontWeight(.bold)
                                        .foregroundColor(ColorConstants.LightGreen800)
                                        .font(Font.semiBold(size: 16))
                                    
                                    Image("microsoftteams")
                                        .resizable()
                                        .frame(width: 35,height: 35)
                                        .aspectRatio(contentMode: .fill)
                                }
                            })
                            .buttonStyle(.plain)
                        }
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


//------------- Student ----------------
struct StudentHomeCellView: View {
    var model = StudentHomeItemM()
    var isDetailCell = false
    var detailsBtnAction : (()->Void)?
    var cancelBtnAction : (()->())?
    var joinBtnAction : (()->())?
    
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .center,spacing: 20) {
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
                
                if model.isAlternate == true && !isDetailCell{
                    Button(action: {
                        detailsBtnAction?()
                    }, label: {
                        Image("img_group8733_gray_908")
                            .resizable()
                            .frame(width:20,height: 15,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                }
                
                //                if model.isCancel != true && isEventNotStartedYet(){
                if model.canCancel == true{
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
                if model.isCancel == true{
                    ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                }else{
                    //                    if isEventNotStartedYet(){
                    ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                    //                    }
                }
            }
            HStack{
                VStack (alignment:.leading,spacing: 10){
                    Text(model.subjectName ?? "المنهج المصري العربي,المرحلة الثانوية,أولي ثانوي,الفيزياء,الترم الأول 2023")
                        .font(Font.semiBold(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
                    //                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                    
                    Text(model.lessonName ?? "lesson 1")
                        .font(Font.semiBold(size: 12.0))
                        .fontWeight(.medium)
                        .foregroundColor(ColorConstants.Black900)
                    //                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                    
                    HStack{
                        Text("Teacher :".localized())
                        
                        Text(model.teacherName ?? "")
                            .fontWeight(.medium)
                    }
                    .font(Font.semiBold(size: 12.0))
                    //                        .foregroundColor(ColorConstants.Black900)
                    
                    HStack {
                        Group{
                            Text( "Alternate Session :".localized())
                            if model.isAlternate == true {
                                Circle().fill(ColorConstants.LightGreen800).frame(width: 12,height: 12)
                                
//                                ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())
                            }else {
                                Circle().fill(ColorConstants.Red400).frame(width: 12,height: 12)

//                                ColorConstants.Red400.frame(width: 12,height: 12).clipShape(Circle())
                            }
                        }
                        .font(Font.bold(size:12))
                        .foregroundColor(model.isAlternate == true ? ColorConstants.LightGreen800 : ColorConstants.Red400)
                        
                        Spacer()
                    }
                    .padding(.top,5)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
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
                    
                    Spacer()
                    //                if model.isCancel == false && isCurrentTimeWithinEventTime(){
                    if model.teamMeetingLink != nil {
                        Button(action: {
                            joinBtnAction?()
                        }, label: {
                            HStack {
                                Text("Join Now".localized())
                                    .fontWeight(.bold)
                                    .foregroundColor(ColorConstants.LightGreen800)
                                    .font(Font.semiBold(size: 16))
                                
                                Image("microsoftteams")
                                    .resizable()
                                    .frame(width: 35,height: 35)
                                    .aspectRatio(contentMode: .fill)
                            }
                        })
                        .buttonStyle(.plain)
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
    StudentHomeCellView()
}
