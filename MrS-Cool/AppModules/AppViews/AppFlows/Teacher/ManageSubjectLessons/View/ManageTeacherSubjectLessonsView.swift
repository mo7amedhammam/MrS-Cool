//
//  ManageTeacherSubjectLessonsView.swift
//  MrS-Cool
//
//  Created by wecancity on 19/11/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct ManageTeacherSubjectLessonsView: View {    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var manageteachersubjectlessonsvm : ManageTeacherSubjectLessonsVM
    
    //    @State var isPush = false
    //    @State var destination = EmptyView()
    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var currentSubject:TeacherSubjectM?
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
                                // -- inputs --
                                Group {
                                    Text("Education Type".localized())
                                        .padding(.top)
                                        .font(Font.SoraSemiBold(size: 16))
                                    
                                    Text(currentSubject?.educationTypeName ?? "Egyption")
                                        .font(Font.SoraRegular(size: 14))
                                    
                                    Text("Education Level".localized())
                                        .font(Font.SoraSemiBold(size: 16))
                                    
                                    Text(currentSubject?.educationLevelName ?? "Primary")
                                        .font(Font.SoraRegular(size: 14))
                                    
                                    Text("Academic Year".localized())
                                        .font(Font.SoraSemiBold(size: 16))
                                    
                                    Text(currentSubject?.academicYearName ?? "level 1")
                                        .font(Font.SoraRegular(size: 14))
                                    
                                    Text("Subject".localized())
                                        .font(Font.SoraSemiBold(size: 16))
                                    
                                    Text(currentSubject?.subjectSemesterYearName ?? "level 1")
                                        .font(Font.SoraRegular(size: 14))
                                    
                                    Text("Status".localized())
                                        .font(Font.SoraSemiBold(size: 16))
                                    
                                    Text(currentSubject?.statusIDName ?? "Aproved")
                                        .font(Font.SoraRegular(size: 14))
                                        .padding(.bottom)
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
                            .sheet(isPresented: $showFilter) {
                                ScrollView {
                                    VStack {
                                        HStack {
                                            //                                            Image("img_maskgroup62_clipped")
                                            //                                                .renderingMode(.template)
                                            Text("Filter".localized())
                                                .font(Font.SoraBold(size: 18))
                                                .foregroundColor(.mainBlue)
                                            //                                            Spacer()
                                        }
                                        .padding(.vertical)
                                        Group {
                                            CustomDropDownField(iconName:"img_vector",placeholder: "Subject Lesson", selectedOption: $manageteachersubjectlessonsvm.filterEducationType,options:lookupsvm.EducationTypesList)
                                            
                                            
                                        }
                                        
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
                                        //                                    Spacer()
                                    }
                                    .padding()
                                    .presentationDetents([.fraction(0.3),.medium])
                                    //                                    .presentationDetents([.fraction(0.25)])
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView{
                            LazyVStack{
                                ForEach(manageteachersubjectlessonsvm.TeacherSubjectLessons ?? []) { unit in
                                    Section(header: Text(unit.unitName ?? "")) {
                                        ForEach(unit.teacherUnitLessons ?? []) { lesson in
                                            ManageSubjectLessonCell(model: lesson, editBtnAction: {
                                                
                                            }, deleteBtnAction: {
                                                
                                            })
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: gr.size.height/2)
                                                
                        //                        List(manageteachersubjectsvm.TeacherSubjects ?? [] ,id:\.self){ subject in
                        //                            ManageSubjectCell(model: subject, editBtnAction:{
                        //                                isEditing = true
                        //                                manageteachersubjectsvm.selectSubjectForEdit(item: subject)
                        //                            }, deleteBtnAction:{
                        //                                manageteachersubjectsvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                        //                                    manageteachersubjectsvm.DeleteTeacherSubject(id: subject.id)
                        //                                })
                        //                                manageteachersubjectsvm.isError.toggle()
                        //                            })
                        //                            .listRowSpacing(0)
                        //                            .listRowSeparator(.hidden)
                        //                        }
                        //                        .listStyle(.plain)
                        //                        .frame(height: gr.size.height/2)
                        
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
                //                                signupvm.isUserChangagble = false
//                lookupsvm.GetEducationTypes()
                manageteachersubjectlessonsvm.subjectSemesterYearId = currentSubject?.subjectSemesterID ?? 0
                manageteachersubjectlessonsvm.GetTeacherSubjectLessons()
            })
            //            .onChange(of: manageteachersubjectlessonsvm.educationType, perform: { value in
            //                lookupsvm.SelectedEducationType = value
            //            })
            //            .onChange(of: manageteachersubjectlessonsvm.educationLevel, perform: { value in
            //                lookupsvm.SelectedEducationLevel = value
            //            })
            //            .onChange(of: manageteachersubjectlessonsvm.academicYear, perform: { value in
            //                lookupsvm.SelectedAcademicYear = value
            //            })
            //            .onChange(of: teachersubjectsvm.isTeacherHasSubjects, perform: { value in
            //                signupvm.isTeacherHasSubjects = value
            //        })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })

        .onDisappear {
            manageteachersubjectlessonsvm.cleanup()
        }
        //        .showHud(isShowing: $teachersubjectsvm.isLoading)
        //        .showAlert(hasAlert: $teachersubjectsvm.isError, alertType: .error( message: "\(teachersubjectsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
        //        .onChange(of: teachersubjectsvm.isLoading, perform: { value in
        //            signupvm.isLoading = value
        //        })
    }
}

@available(iOS 16.0, *)
#Preview {
    ManageTeacherSubjectLessonsView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(ManageTeacherSubjectLessonsVM())
    
}
