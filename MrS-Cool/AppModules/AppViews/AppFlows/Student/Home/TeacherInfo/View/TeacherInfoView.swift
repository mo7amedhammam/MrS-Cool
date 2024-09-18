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

        @State var isPush = false
        @State var destination = AnyView(EmptyView())
    //    var bookingcase:BookingCases
    
 
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Teacher Info")
            
            VStack (alignment: .leading){
                
                if let teacher = teacherinfovm.Teacher{
                    HStack {
                        let imageURL : URL? = URL(string: Constants.baseURL+(teacher.teacherImage ?? "").reverseSlaches())
                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                        
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60,height: 60)
                            .clipShape(Circle())
                        
                        VStack(alignment:.leading){
                            Text(teacher.teacherName ?? "")
                                .font(.bold(size: 18))
                            
                                if let rate = teacher.teacherRate{
                                    StarsView(rating:rate)
                            }

                            Group{
                                Text("\(teacher.totalReviews ?? 0) ")
                                + Text("Reviews".localized())
                            }
                            .foregroundColor(Color.mainBlue)
                            .font(.semiBold(size: 12))
                            
                        }
                        .foregroundColor(.mainBlue)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal,30)
                    
                    Text(teacher.teacherBIO ?? "")
                        .font(.regular(size: 10))
                        .foregroundColor(.mainBlue)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal,30)
                        .frame(minHeight: 20)
                    
                    GeometryReader { gr in
                        VStack(alignment:.leading){ // Title - Data - Submit Button)
                            
                            ScrollView(.vertical,showsIndicators: false){
                                Spacer().frame(height:20)
                                
                                if let rate = teacher.teacherRate,rate > 0{
                                SignUpHeaderTitle(Title: "Student feedback", subTitle: "")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
                                    HStack{
                                        VStack{
                                            Text("\(rate ,specifier: "%.1f")")
                                                .foregroundColor(Color.mainBlue)
                                                .font(.bold(size: 18))
                                            StarsView(rating: rate)
                                        }
                                        .frame(width:110)
                                        //                            }
                                        
                                        VStack{
                                            ForEach(teacher.teacherRatePercents ?? [],id:\.self){percent in
                                                
                                                HStack {
                                                    Slider(value:.constant(percent.ratePercents ?? 20),in:0...100)
                                                        .tint(Color.orange)
                                                    
                                                    StarsView(rating: percent.rateNumber ?? 0)
                                                    
                                                    Text("\(percent.ratePercents ?? 0,specifier: "%.1f") %")
                                                        .foregroundColor(Color.mainBlue)
                                                        .font(.regular(size: 10))
                                                }
                                            }
                                        }
                                        .onAppear {
                                            UISlider
                                                .appearance().thumbTintColor = .clear
                                        }
                                    }
                                }
                                
                                
                                SignUpHeaderTitle(Title: "Subjects", subTitle: "")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)

                                let studentSubjects = teacher.subjects
                                    let homesbject: [HomeSubject] = studentSubjects?.convertToStudentSubjectsM() ?? []
                                LazyVGrid(columns: [.init(), .init(),.init()]) {
                                    ForEach(Array(homesbject.enumerated()),id:\.element){index,subject in
//                                        let teachersubject = teacherTitle(subjectAcademicYear: "studentSubjects[index].subjectAcademicYear" , subjectLevel: "studentSubjects[index].subjectLevel")
                                        
                                        StudentHomeSubjectCell(subject:subject,selectedSubject:$teacherinfovm.SelectedStudentSubjects
                                        ){
                                            destination = AnyView(HomeSubjectDetailsView(selectedsubjectid:subject.id ?? 0))
                                            isPush = true
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
        .localizeView()
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onAppear(perform: {
//            DispatchQueue.main.async{
                teacherinfovm.GetTeacherInfo(TeacherId: teacherid)
//            }
        })
        //        .onDisappear {
        //            lessondetailsvm.cleanup()
        //        }
        
                .showHud(isShowing: $teacherinfovm.isLoading)
                .showAlert(hasAlert: $teacherinfovm.isError, alertType: teacherinfovm.error)
        
                NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
    
}

#Preview {
    TeacherInfoView(teacherid: 0)
}


