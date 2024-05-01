//
//  ManageTeacherSubjectLessonsView.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import SwiftUI

struct ManageTeacherSubjectLessonsView: View {    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var manageteachersubjectlessonsvm : ManageTeacherSubjectLessonsVM
    
    //    @State var isPush = false
    //    @State var destination = EmptyView()
    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var currentSubject:TeacherSubjectM?

    @State var isPush = false
    @State var destination = AnyView(EmptyView())

    var body: some View {
            VStack {
                CustomTitleBarView(title: "Manage My Subject Lessons")
                
                GeometryReader { gr in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                VStack(alignment: .leading, spacing: 0){
                                    // -- Data Title --
                                    HStack(alignment: .top){
                                        SignUpHeaderTitle(Title:  "Subject Information")
                                        Spacer()
                                    }
                                    //                                .padding(.bottom )
                                    
                                    // -- inputs --
                                    Group {
                                        HStack{
                                            VStack(alignment:.leading){
                                                Text("Education Type".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentSubject?.educationTypeName ?? "Egyption")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:30)
                                                
                                                Text("Academic Year".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentSubject?.academicYearName ?? "level 1")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                            }
                                            Spacer()
                                            VStack(alignment:.leading){
                                                Text("Education Level".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentSubject?.educationLevelName ?? "Primary")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:30)
                                                
                                                Text("Subject".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentSubject?.subjectSemesterYearName ?? "level 1")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                            }
                                        }
                                        
                                        
                                        //                                    HStack{
                                        ////                                        VStack(alignment:.leading){
                                        ////                                            Text("Academic Year".localized())
                                        ////                                                .font(Font.SoraSemiBold(size: 16))
                                        ////
                                        ////                                            Text(currentSubject?.academicYearName ?? "level 1")
                                        ////                                                .font(Font.SoraRegular(size: 14))
                                        ////                                        }
                                        //                                        VStack(alignment:.leading){
                                        ////                                            Text("Subject".localized())
                                        ////                                                .font(Font.SoraSemiBold(size: 16))
                                        ////
                                        ////                                            Text(currentSubject?.subjectSemesterYearName ?? "level 1")
                                        ////                                                .font(Font.SoraRegular(size: 14))
                                        //
                                        //                                        }
                                        //                                    }
                                        //
                                        //                                    Text("Status".localized())
                                        //                                        .font(Font.SoraSemiBold(size: 16))
                                        //
                                        //                                    Text(currentSubject?.statusIDName ?? "Aproved")
                                        //                                        .font(Font.SoraRegular(size: 14))
                                        //                                        .padding(.bottom)
                                    }
                                    .foregroundColor(.mainBlue)
                                    .padding([.top,.horizontal])
                                }
                                .padding(.top,20)
                                
                                HStack(){
                                    SignUpHeaderTitle(Title: "Manage Subject Lessons")
                                    Spacer()
                                    Image("img_maskgroup62_clipped")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(ColorConstants.MainColor)
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .onTapGesture(perform: {
                                            showFilter = true
                                        })
                                }
                                .padding(.top)
                                
                            }
                            .padding(.horizontal)
                            //                        ScrollView{
                            List{
                                ForEach(manageteachersubjectlessonsvm.TeacherSubjectLessons ?? [], id:\.self) { unit in
                                    Section(header:
                                                HStack {
                                        Text(unit.unitName ?? "")
                                            .font(Font.SoraBold(size: 18))
                                            .foregroundColor(.mainBlue)
                                            .padding(.top)
                                        Spacer()
                                    }
                                            //                                        .frame(height:40)
                                    ) {
                                        ForEach(unit.teacherUnitLessons ?? [], id:\.id) { lesson in
                                            ManageSubjectLessonCell(model: lesson, editBtnAction: {

                                                manageteachersubjectlessonsvm.selectSubjectForEdit(subjectSemeterYearId:currentSubject?.id,item: lesson)
                                                manageteachersubjectlessonsvm.showEdit = true
                                            }, addBriefBtnAction: {
                                              
                                                manageteachersubjectlessonsvm.selectSubjectForEdit(subjectSemeterYearId:currentSubject?.id,item: lesson)
                                                manageteachersubjectlessonsvm.GetSubjectLessonBrief()
                                                manageteachersubjectlessonsvm.showBrief = true
                                            },addMaterialBtnAction:{
                                                
                                                destination = AnyView(ManageLessonMaterialView(currentLesson:lesson)
                                                    .environmentObject(LookUpsVM())
                                                    .environmentObject(ManageLessonMaterialVM())
                                                                      )
                                                isPush = true

                                                
                                            })
                                            .listRowSpacing(0)
                                            .listRowSeparator(.hidden)
                                            .listRowBackground(Color.clear)
                                        }
                                    }
                                }
                                //                            }
                            }
                            .padding(.horizontal,-4)
                            .listStyle(.plain)
//                            .scrollContentBackground(.hidden)
                            .frame(minHeight: gr.size.height/2)
                            
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
                }
                .onAppear(perform: {
                    manageteachersubjectlessonsvm.subjectSemesterYearId = currentSubject?.subjectSemesterYearID ?? 0
                    manageteachersubjectlessonsvm.GetTeacherSubjectLessons()
                })
     
            }
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            
            .onDisappear {
                manageteachersubjectlessonsvm.cleanup()
            }
            .showHud(isShowing: $manageteachersubjectlessonsvm.isLoading)
            .showAlert(hasAlert: $manageteachersubjectlessonsvm.isError, alertType: manageteachersubjectlessonsvm.error)
            
            .overlay{
                if manageteachersubjectlessonsvm.showEdit{
                    ScrollView {
                        VStack{
                            Spacer()
                            VStack(spacing:15){
                                HStack(spacing:10) {
                                    Image("img_vector_black_900_14x14")
                                    //                                                .renderingMode(.template)
                                    
                                    Text("Update Lesson".localized())
                                        .font(Font.SoraBold(size: 18))
                                        .foregroundColor(.mainBlue)
                                    Spacer()
                                }
                                Group {
                                    CustomTextField(iconName:"img_group_black_900",placeholder: "Group Price", text: $manageteachersubjectlessonsvm.groupCost
                                                    ,keyboardType:.decimalPad)
                                        .onChange(of: manageteachersubjectlessonsvm.groupCost) { newValue in
                                            manageteachersubjectlessonsvm.groupCost = newValue.filter { $0.isEnglish }
                                        }
                                    
                                    CustomTextField(iconName:"img_group_black_900",placeholder: "Group Time", text: $manageteachersubjectlessonsvm.groupTime,keyboardType:.asciiCapableNumberPad)
                                    
                                    //                        CustomTextField(iconName:"img_group58",placeholder: "Minimum Number Of Group Students", text: $manageteachersubjectlessonsvm.minGroup ,keyboardType:.asciiCapableNumberPad)
                                    
                                    //                        CustomTextField(iconName:"img_group58",placeholder: "Maximum Number Of Group Students", text: $manageteachersubjectlessonsvm.maxGroup,keyboardType:.asciiCapableNumberPad)
                                    
                                    CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Price", text: $manageteachersubjectlessonsvm.individualCost,keyboardType:.decimalPad)
                                        .onChange(of: manageteachersubjectlessonsvm.individualCost) { newValue in
                                            manageteachersubjectlessonsvm.individualCost = newValue.filter { $0.isEnglish }
                                        }
                                    CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Time", text: $manageteachersubjectlessonsvm.individualTime,keyboardType:.asciiCapableNumberPad)
                                }
                                HStack {
                                    Group{
                                        CustomButton(Title:"Update",IsDisabled: .constant(false), action: {
                                            manageteachersubjectlessonsvm .UpdateTeacherSubjectLesson()
                                            manageteachersubjectlessonsvm.showEdit = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
    //                                        manageteachersubjectlessonsvm.clearFilter()
    //                                        manageteachersubjectlessonsvm .GetTeacherSubjectLessons()
                                            manageteachersubjectlessonsvm.showEdit = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                            }
                            .padding()
                            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,bottomRight: 10.0)
                                .fill(ColorConstants.WhiteA700).disabled(true)
                            )
                            .padding(.horizontal)
                            Spacer()
                        }
                        .frame(height:UIScreen.main.bounds.height+30)
                    }.frame(height:UIScreen.main.bounds.height+30)
                        .background( Color(.mainBlue).opacity(0.2))
                }
                
                if manageteachersubjectlessonsvm.showBrief{
                    ScrollView {
                        VStack{
                            Spacer()
                            VStack(spacing:15){
                                HStack(spacing:10) {
                                    Image("img_group512375")
                                    //                                                .renderingMode(.template)
                                    Text("Update Lesson Brief".localized())
                                        .font(Font.SoraBold(size: 18))
                                        .foregroundColor(.mainBlue)
                                    Spacer()
                                }
                                Group {
                                    CustomTextEditor(iconName: "img_group512375",placeholder: "Lesson Brief",insidePlaceholder: "Tell us about your Lesson", text: $manageteachersubjectlessonsvm.subjectBriefEn,charLimit: 1000)
                                        .onChange(of: manageteachersubjectlessonsvm.subjectBriefEn) { newValue in
                                            manageteachersubjectlessonsvm.subjectBriefEn = newValue.filter { $0.isEnglish }
                                        }

                                    CustomTextEditor(iconName: "img_group512375",placeholder: "عن الدرس",insidePlaceholder: "اخبرنا عن الدرس", text: $manageteachersubjectlessonsvm.subjectBrief,charLimit: 1000)
                                        .reversLocalizeView()
                                        .onChange(of: manageteachersubjectlessonsvm.subjectBrief) { newValue in
                                            manageteachersubjectlessonsvm.subjectBrief = newValue.filter { $0.isArabic }
                                        }
                                }
                                HStack {
                                    Group{
                                        CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                                            manageteachersubjectlessonsvm.UpdateSubjectLessonBrief()
                                            manageteachersubjectlessonsvm.showBrief = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            manageteachersubjectlessonsvm.showBrief = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                            }
                            .padding()
                            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,bottomRight: 10.0)
                                .fill(ColorConstants.WhiteA700).disabled(true)
                            )
                            .padding(.horizontal)
                            Spacer()
                        }
                        .frame(height:UIScreen.main.bounds.height+30)
                    }.frame(height:UIScreen.main.bounds.height+30)
                        .background( Color(.mainBlue).opacity(0.2))
                }
                
                if showFilter{
                    // Blurred Background and Sheet
                    Color.mainBlue
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showFilter.toggle()
                        }
                        .blur(radius: 4) // Adjust the blur radius as needed
                    DynamicHeightSheet(isPresented: $showFilter){
                        
                        VStack {
                            ColorConstants.Bluegray100
                                .frame(width:50,height:5)
                                .cornerRadius(2.5)
                                .padding(.top,2.5)
                            HStack {
                                Text("Filter".localized())
                                    .font(Font.SoraBold(size: 18))
                                    .foregroundColor(.mainBlue)
                                //                                            Spacer()
                            }
                            
                            ScrollView{
                                VStack{
                                    Group {
                                        CustomTextField(iconName:"img_group_512380",placeholder: "Subject Lesson", text: $manageteachersubjectlessonsvm.lessonName )
                                    }.padding(.top,5)
                                    
                                    Spacer()
                                    HStack {
                                        Group{
                                            CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                                manageteachersubjectlessonsvm .GetTeacherSubjectLessons()
                                                showFilter = false
                                            })
                                            
                                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                manageteachersubjectlessonsvm.clearFilter()
                                                manageteachersubjectlessonsvm .GetTeacherSubjectLessons()
                                                showFilter = false
                                            })
                                        } .frame(width:130,height:40)
                                            .padding(.vertical)
                                    }
                                }
                                .padding(.horizontal,3)
                                .padding(.top)
                            }

                        }
                        .padding()
                        .frame(height:240)
                        .keyboardAdaptive()
                    }

                }
        }        
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})

    }
}

#Preview {
    ManageTeacherSubjectLessonsView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(ManageTeacherSubjectLessonsVM())
    
}
