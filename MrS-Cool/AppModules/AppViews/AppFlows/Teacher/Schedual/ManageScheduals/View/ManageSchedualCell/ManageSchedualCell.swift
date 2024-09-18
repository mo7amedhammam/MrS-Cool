//
//  ManageSchedualCell.swift
//  MrS-Cool
//
//  Created by wecancity on 29/11/2023.
//

import SwiftUI

struct ManageSchedualCell: View {
    var model = TeacherSchedualM()
//    {
//        didSet{
//            model.fromStartDate = model.fromStartDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy")
//            model.fromTime = model.toTime?.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa")
//
//            model.toEndDate = model.toEndDate?.ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy")
//            model.toTime = model.toTime?.ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa")
//        }
//    }
//    var editSubjectBtnAction : (()->())?
//    var editLessonsBtnAction : (()->())?
    var deleteBtnAction : (()->())?

    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .top,spacing: 20) {
                
                Image("img_group148")
                    .scaleEffect(1.2, anchor: .center)
//                    .background(
//                        Color.black.clipShape(Circle())
//                            .frame(width: 30 ,height: 30)
//                    )
                
                VStack(alignment: .leading){
                    Text(model.dayName ?? "day name")
                        .font(Font.semiBold(size:13.0))
                        .foregroundColor(.mainBlue)
                    
                    VStack(alignment:.leading,spacing: 2.5){
    //                    Spacer()
                                
                        Text("Start Date".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)

                        Text("\(model.fromStartDate ?? "10 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.regular(size: 12))
                            .foregroundColor(.mainBlue)
                        Spacer().frame(height:3)
                        
                        Text("Start Time".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)

                        Text("\(model.fromTime ?? "03:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))
                            .font(Font.regular(size: 12))
                            .foregroundColor(.mainBlue)
                    }
                    .padding(.top,8)

                }
                
                Spacer()
                VStack(alignment:.trailing){
                    
                    Button(action: {
                        deleteBtnAction?()
                    }, label: {
                        Image("img_group")
                            .resizable()
                            .frame(width: 15, height: 18,alignment: .leading)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                    
                    //                }
                    VStack(alignment:.leading,spacing: 2.5){
                        Text("End Date".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.toEndDate ?? "30 Apr 2023")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                            .font(Font.regular(size: 12))
                            .foregroundColor(.mainBlue)
                        
                        Spacer().frame(height:3)

                        Text("End Time".localized())
                            .font(Font.semiBold(size: 9))
                            .foregroundColor(.grayBtnText)
                        
                        Text("\(model.toTime ?? "07:30")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm aa"))
                            .font(Font.regular(size: 12))
                            .foregroundColor(.mainBlue)
                        
                    }
                    .padding(.top,8)
                }
            }
            
//            HStack (alignment:.bottom){
//
//                
//                Spacer()
//                HStack (alignment:.bottom,spacing:25){
////                    VStack(alignment:.leading){
////    //                    Spacer()
////                                
////                        Text("Start Date".localized())
////                            .font(Font.semiBold(size: 6))
////                            .foregroundColor(.grayBtnText)
////
////                        Text("\(model.fromStartDate ?? "") ")
////                            .font(Font.regular(size: 12))
////                            .foregroundColor(.mainBlue)
////
////                        Text("Start Time".localized())
////                            .font(Font.semiBold(size: 6))
////                            .foregroundColor(.grayBtnText)
////
////                        Text("\(model.fromTime ?? "") ")
////                            .font(Font.regular(size: 12))
////                            .foregroundColor(.mainBlue)
////
////
////                    }
//                
////                    Spacer()
////                    VStack(alignment:.leading){
////                        Text("End Date".localized())
////                            .font(Font.semiBold(size: 6))
////                            .foregroundColor(.grayBtnText)
////
////                        Text("\(model.toEndDate ?? "") ")
////                            .font(Font.regular(size: 12))
////                            .foregroundColor(.mainBlue)
////
////                        Text("End Time".localized())
////                            .font(Font.semiBold(size: 6))
////                            .foregroundColor(.grayBtnText)
////
////                        Text("\(model.toTime ?? "") ")
////                            .font(Font.regular(size: 12))
////                            .foregroundColor(.mainBlue)
////
////                    }
//                }
//            }
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
    ManageSchedualCell()
}
