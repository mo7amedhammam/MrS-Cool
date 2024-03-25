//
//  TeacherInfoView.swift
//  MrS-Cool
//
//  Created by wecancity on 25/03/2024.
//


import SwiftUI

struct TeacherInfoView: View {
    var teacherid : Int
    @StateObject var teacherinfovm = TeacherInfoVM()

    //    @State var isPush = false
    //    @State var destination = AnyView(EmptyView())
    //    var bookingcase:BookingCases
    
 
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Teacher Info")
            
            VStack (alignment: .leading){
                
                if let teacher = teacherinfovm.Teacher{
                    HStack {
                        let imageURL : URL? = URL(string: Constants.baseURL+(teacher.teacherImage ?? ""))
                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                        
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60,height: 60)
                            .clipShape(Circle())
                        
                        VStack(alignment:.leading){
                            Text(teacher.teacherName ?? "Teacher Name")
                                .font(.SoraBold(size: 18))
                            
                            //                            if let rate = teacher.teacherRate{
                            HStack{
                                StarsView(rating: teacher.teacherRate ?? 0)
                                //                                    Text("\(rate ,specifier: "%.1f")")
                                //                                        .foregroundColor(ColorConstants.Black900)
                                //                                        .font(.SoraSemiBold(size: 13))
                            }
                            //                            }
                            
                            //                if let ratescount = teacher.teacherReview, ratescount > 0{
                            Group{
                                Text("\(teacher.totalReviews ?? 0) ")
                                + Text("Reviews")
                            }
                            .foregroundColor(Color.mainBlue)
                            .font(.SoraRegular(size: 12))
                            
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
                    Text(teacher.teacherBIO ?? "briefbriefb riefb riefbrief briefbr iefbriefbr iefbri efbriefbr iefbriefbri efbriefbriefbrief briefbriefbriefbrief briefbrie fbrief briefb riefbrief briefbrief briefbriefbrief briefbrief brief briefbrief brief brief brief brief brief brief brief brief brief")
                        .font(.SoraRegular(size: 10))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal,30)
                        .frame(minHeight: 20)
                    
                    GeometryReader { gr in
                        VStack(alignment:.leading){ // Title - Data - Submit Button)
                            
                            ScrollView(.vertical,showsIndicators: false){
                                Spacer().frame(height:20)
                                
                                SignUpHeaderTitle(Title: "Student feedback", subTitle: "")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
                                
                                HStack{
                                    //                            if let rate = teacher.teacherRate{
                                    VStack{
                                        Text("\(teacher.teacherRate ?? 0 ,specifier: "%.1f")")
                                            .foregroundColor(Color.mainBlue)
                                            .font(.SoraBold(size: 18))
                                        StarsView(rating: teacher.teacherRate ?? 0)
                                    }
                                    .frame(width:110)
                                    //                            }
                                    
                                    VStack{
                                        ForEach(teacher.teacherRatePercents ?? [TeacherRatePercent.init(rateNumber:5,ratePercents: 90),TeacherRatePercent.init(rateNumber:4,ratePercents: 9),TeacherRatePercent.init(rateNumber:3,ratePercents: 40),TeacherRatePercent.init(rateNumber:2.5,ratePercents: 25)],id:\.self){percent in
                                            
                                            HStack {
                                                Slider(value:.constant(percent.ratePercents ?? 20),in:0...100)
                                                    .tint(Color.orange)
                                                
                                                StarsView(rating: percent.rateNumber ?? 0)
                                                
                                                Text("\(percent.ratePercents ?? 20,specifier: "%.1f") %")
                                                    .foregroundColor(Color.mainBlue)
                                                    .font(.SoraRegular(size: 10))
                                            }
                                        }
                                    }
                                    .onAppear {
                                        UISlider
                                            .appearance().thumbTintColor = .clear
                                    }
                                }
                                
                                SignUpHeaderTitle(Title: "Subjects", subTitle: "")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
                                
                                LazyVGrid(columns: [.init(), .init(),.init()]) {
                                    
                                    let studentSubjects: [StudentSubjectsM] = teacher.subjects?.convertToStudentSubjectsM() ?? []
                                    ForEach(studentSubjects,id:\.self){subject in
                                        StudentHomeSubjectCell(subject:subject,selectedSubject:.constant(StudentSubjectsM(id: -132, name: "", image: ""))){
                                            //                                            destination = AnyView(HomeSubjectDetailsView(selectedsubjectid: subject.id ?? 0))
                                            //                                            isPush = true
                                        }
                                        //                                    .frame(width: gr.size.width/2.7, height: 160)
                                    }
                                }
                                //                            .frame(height: 160)
//                                .padding(.horizontal)
                                .padding(.bottom,10)
                                
                                Spacer()
                                    .frame(height:50)
                            }
                            .padding(.horizontal)
                            .frame(minHeight: gr.size.height)
                        }
                    }
                    .background{
                        ColorConstants.WhiteA700
                            .clipShape(RoundedCorners(topLeft: 25, topRight: 25, bottomLeft: 0, bottomRight: 0))
                            .ignoresSafeArea()
                    }
                }else{
                    Spacer()
                }
                
            }
            .background{
                ColorConstants.ParentDisableBg
                    .ignoresSafeArea()
            }
            
            Spacer()
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onAppear(perform: {
            teacherinfovm.GetTeacherInfo(TeacherId: teacherid)
        })
        //        .onDisappear {
        //            lessondetailsvm.cleanup()
        //        }
        
        //        .showHud(isShowing: $homesubjectdetailsvm.isLoading)
        //        .showAlert(hasAlert: $homesubjectdetailsvm.isError, alertType: homesubjectdetailsvm.error)
        
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
}

#Preview {
    TeacherInfoView(teacherid: 0)
}


