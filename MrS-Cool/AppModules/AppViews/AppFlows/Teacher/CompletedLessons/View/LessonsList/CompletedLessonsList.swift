//
//  CompletedLessonsList.swift
//  MrS-Cool
//
//  Created by wecancity on 12/12/2023.
//

import SwiftUI

struct CompletedLessonsList: View {    //        @Environment(\.dismiss) var dismiss
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
            CustomTitleBarView(title: "Completed Lessons")
            
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Completed Lessons")
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
                manageteachersubjectlessonsvm.subjectSemesterYearId = currentSubject?.subjectAcademicYearID ?? 0
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
    CompletedLessonsList()
        .environmentObject(LookUpsVM())
        .environmentObject(ManageTeacherSubjectLessonsVM())
    
}
