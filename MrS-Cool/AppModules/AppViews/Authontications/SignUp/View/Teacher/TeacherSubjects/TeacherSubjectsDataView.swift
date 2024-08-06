//
//  TeacherSubjectsDataView.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct TeacherSubjectsDataView: View {
//        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var teachersubjectsvm : TeacherSubjectsVM
    
//    @State var isPush = false
//    @State var destination = EmptyView()
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical,showsIndicators: false){
                VStack{ // (Title - Data - Submit Button)
                    Group{
                    VStack(alignment: .leading, spacing: 0){
                        // -- Data Title --
                        HStack(alignment: .top){
                            SignUpHeaderTitle(Title: "Subjects Information")
                            Spacer()
                            Text("(2 / 3)".localized())
                                .font(.SoraRegular(size: 14))
                                .foregroundColor(.black)
                        }
                        // -- inputs --
                        Group {
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $teachersubjectsvm.educationType,options:lookupsvm.EducationTypesList,isvalid: teachersubjectsvm.iseducationTypevalid)
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $teachersubjectsvm.educationLevel,options:lookupsvm.EducationLevelsList,isvalid: teachersubjectsvm.iseducationLevelvalid)
                            
//                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $teachersubjectsvm.academicYear,options:lookupsvm.AcademicYearsList,isvalid: teachersubjectsvm.isacademicYearvalid)
//                            
//                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject *", selectedOption: $teachersubjectsvm.subject,options:lookupsvm.SubjectsList,isvalid: teachersubjectsvm.issubjectvalid)

                            CustomDropDownField(iconName:"img_group148",placeholder: "Subjects *", selectedOption: $teachersubjectsvm.academicYear ,options:lookupsvm.SubjectListByEducationLevelIdList,isvalid: teachersubjectsvm.isacademicYearvalid)
                            
                            MultiSelectDropDownField(iconName:"img_group_512380",placeholder: "ِStudy materials for the stages *", selectedOptions: $teachersubjectsvm.subjectsArr,options:lookupsvm.SubjectListBySubjectIdAndEducationLevelIdList,isvalid: teachersubjectsvm.issubjectsArrvalid)
                            

//                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِStudy materials for the stages *", selectedOption: $teachersubjectsvm.subject,options:lookupsvm.SubjectListBySubjectIdAndEducationLevelIdList,isvalid: teachersubjectsvm.issubjectvalid)
                            
                            
                            
                        }
                        .padding([.top])
                    }.padding(.top,20)
                    
                    HStack {
                        Group{
                            CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                                teachersubjectsvm.CreateTeacherSubject()
                            })
                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                teachersubjectsvm.clearTeachersSubject()
                            })
                        }
                        .frame(width:120,height: 40)
                        
                    }.padding(.vertical)
                    
                    HStack {
                        Text("* Note: Must be enter one item at least")
                            .font(Font.SoraRegular(size: 14))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(ColorConstants.Black900)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)

                    List(teachersubjectsvm.TeacherSubjects ?? [] ,id:\.self){ subject in
                        TeacherSubjectCell(model: subject){
                            teachersubjectsvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                teachersubjectsvm.DeleteTeacherSubject(id: subject.id)
                            })
                            teachersubjectsvm.isError.toggle()
                        }
                        .listRowSpacing(0)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .frame(height: gr.size.height/2)
                    Spacer()
                }
                .frame(minHeight: gr.size.height)
            }
        }.onAppear(perform: {
            signupvm.isUserChangagble = false
            lookupsvm.GetEducationTypes()
//            teachersubjectsvm.GetTeacherSubjects()
        })
        .onChange(of: teachersubjectsvm.educationType, perform: { value in
            lookupsvm.SelectedEducationType = value
        })
        .onChange(of: teachersubjectsvm.educationLevel, perform: { value in
            lookupsvm.SelectedEducationLevel = value
            lookupsvm.GetSubjectListByEducationLevelId()
        })
//        .onChange(of: teachersubjectsvm.academicYear, perform: { value in
//            lookupsvm.SelectedAcademicYear = value
//        })
//        .onChange(of: teachersubjectsvm.subject, perform: { value in
//            lookupsvm.SelectedEducationLevel = value
//            lookupsvm.GetSubjectListByEducationLevelId()
//        })

        .onChange(of: teachersubjectsvm.academicYear, perform: { value in
//            lookupsvm.SelectedAcademicYear = value
            lookupsvm.SelectedSubjectListByEducationLevelId = value
        })
//        .onChange(of: teachersubjectsvm.subject, perform: { value in
//            lookupsvm.SelectedEducationLevel = value
//        })

        .onChange(of: teachersubjectsvm.isTeacherHasSubjects, perform: { value in
            signupvm.isTeacherHasSubjects = value
        })
//        .showHud(isShowing: $teachersubjectsvm.isLoading)
//        .showAlert(hasAlert: $teachersubjectsvm.isError, alertType: .error( message: "\(teachersubjectsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
//        .onChange(of: teachersubjectsvm.isLoading, perform: { value in
//            signupvm.isLoading = value
//        })

    }
}

#Preview {
    TeacherSubjectsDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
        .environmentObject(TeacherSubjectsVM())
}
