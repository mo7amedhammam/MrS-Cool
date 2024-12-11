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
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        formatter.timeZone = TimeZone(identifier: "GMT")
//        formatter.locale = Locale(identifier: "en")

//        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure GMT or appropriate time zone
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
    // Function to check if the event is in the past
    func isEventInPast() -> Bool {
        guard let eventDateStr = model.timeFrom , let timeToStr = model.timeTo else {
            return false
        }

        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
        print("toDateTimestr: \(toDateTimeStr)")
        
        guard let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse toDateTime: \(toDateTimeStr)")
            return false
        }
        print("toDateTime: \(toDateTime)")
        
        // Convert current time to local time zone
         let currentTime = Date()

        return toDateTime < currentTime
    }

    func isCurrentTimeWithinEventTime() -> Bool {
        guard let eventDateStr = model.date, let timeFromStr = model.timeFrom, let timeToStr = model.timeTo else {
            print("One of the required date/time components is nil.")
            return false
        }

        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
        
//        print("From Date Time String: \(fromDateTimeStr)")
//        print("To Date Time String: \(toDateTimeStr)")
//
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr),
              let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse fromDateTime or toDateTime.")
            return false
        }
        
        // Convert current time to local time zone
        let currentTime = Date()
//         let datestr = dateFormatter.string(from: Date())
//        else{return false}
//        guard let currentTime = dateFormatter.date(from: datestr)else{return false}
        
//        print("Current Time: \(currentTime)")
//        print("Event From Time: \(fromDateTime)")
//        print("Event To Time: \(toDateTime)")
        
        return currentTime >= fromDateTime && currentTime <= toDateTime
    }
    
    // Function to check if the event is not started yet
    func isEventNotStartedYet() -> Bool {
        guard let eventDateStr = model.date, let timeFromStr = model.timeFrom else {
            return false
        }
        
        // Create full date string with event date and timeFrom
        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
        
        // Parse the date string into Date object
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr) else {
            return false
        }
        
        // Convert current time to local time zone
         let currentTime = Date()

        return currentTime < fromDateTime
    }
    
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
                if model.isCancel == false && isCurrentTimeWithinEventTime(){
                    Button(action: {
                        joinBtnAction?()
                    }, label: {
                        Image("microsoftteams")
                            .resizable()
                            .frame(width: 40,height: 40)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                }
                
                if model.isCancel != true && isEventNotStartedYet(){
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
                    if isEventNotStartedYet(){
                        ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())

                    }
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
    var cancelBtnAction : (()->())?
    var joinBtnAction : (()->())?
    
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        formatter.timeZone = TimeZone(identifier: "GMT")
//        formatter.locale = Locale(identifier: "en")

//        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure GMT or appropriate time zone
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    
    // Function to check if the event is in the past
    func isEventInPast() -> Bool {
        guard let eventDateStr = model.timeFrom , let timeToStr = model.timeTo else {
            return false
        }

        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
        print("toDateTimestr: \(toDateTimeStr)")
        
        guard let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse toDateTime: \(toDateTimeStr)")
            return false
        }
        print("toDateTime: \(toDateTime)")
        
        // Convert current time to local time zone
         let currentTime = Date()

        return toDateTime < currentTime
    }

    func isCurrentTimeWithinEventTime() -> Bool {
        guard let eventDateStr = model.date, let timeFromStr = model.timeFrom, let timeToStr = model.timeTo else {
            print("One of the required date/time components is nil.")
            return false
        }

        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
        let toDateTimeStr = "\(eventDateStr.prefix(10))T\(timeToStr)"
        
//        print("From Date Time String: \(fromDateTimeStr)")
//        print("To Date Time String: \(toDateTimeStr)")
//
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr),
              let toDateTime = dateFormatter.date(from: toDateTimeStr) else {
            print("Failed to parse fromDateTime or toDateTime.")
            return false
        }
        
        // Convert current time to local time zone
        let currentTime = Date()
//         let datestr = dateFormatter.string(from: Date())
//        else{return false}
//        guard let currentTime = dateFormatter.date(from: datestr)else{return false}
        
//        print("Current Time: \(currentTime)")
//        print("Event From Time: \(fromDateTime)")
//        print("Event To Time: \(toDateTime)")
        
        return currentTime >= fromDateTime && currentTime <= toDateTime
    }
    
    // Function to check if the event is not started yet
    func isEventNotStartedYet() -> Bool {
        guard let eventDateStr = model.date, let timeFromStr = model.timeFrom else {
            return false
        }
        
        // Create full date string with event date and timeFrom
        let fromDateTimeStr = "\(eventDateStr.prefix(10))T\(timeFromStr)"
        
        // Parse the date string into Date object
        guard let fromDateTime = dateFormatter.date(from: fromDateTimeStr) else {
            return false
        }
        
        // Convert current time to local time zone
         let currentTime = Date()

        return currentTime < fromDateTime
    }
    
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
                if model.isCancel == false && isCurrentTimeWithinEventTime(){
                    Button(action: {
                        joinBtnAction?()
                    }, label: {
                        Image("microsoftteams")
                            .resizable()
                            .frame(width: 40,height: 40)
                            .aspectRatio(contentMode: .fill)
                    })
                    .buttonStyle(.plain)
                }
                
                if model.isCancel != true && isEventNotStartedYet(){
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
                    if isEventNotStartedYet(){
                        ColorConstants.LightGreen800.frame(width: 12,height: 12).clipShape(Circle())

                    }
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
    StudentHomeCellView()
}
