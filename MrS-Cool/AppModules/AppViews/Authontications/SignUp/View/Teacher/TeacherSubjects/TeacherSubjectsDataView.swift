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
    @StateObject var teachersubjectsvm = TeacherSubjectsVM()
    
    @State var isPush = false
    @State var destination = EmptyView()
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
                            Text("(2 / 3)")
                                .font(.SoraRegular(size: 14))
                                .foregroundColor(.black)
                        }
                        // -- inputs --
                        Group {
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $teachersubjectsvm.educationType,options:lookupsvm.EducationTypesList)
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $teachersubjectsvm.educationLevel,options:lookupsvm.EducationLevelsList)
                            
                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $teachersubjectsvm.academicYear,options:lookupsvm.AcademicYearsList)
                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject *", selectedOption: $teachersubjectsvm.subject,options:lookupsvm.SubjectsList)
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
                            teachersubjectsvm.DeleteTeacherSubject(id: subject.id)
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
        })
        .onChange(of: teachersubjectsvm.educationType, perform: { value in
            lookupsvm.SelectedEducationType = value
        })
        .onChange(of: teachersubjectsvm.educationLevel, perform: { value in
            lookupsvm.SelectedEducationLevel = value
        })
        .onChange(of: teachersubjectsvm.academicYear, perform: { value in
            lookupsvm.SelectedAcademicYear = value
        })
        .onChange(of: teachersubjectsvm.isTeacherHasSubjects, perform: { value in
            signupvm.isTeacherHasSubjects = value
        })
        .showHud(isShowing: $teachersubjectsvm.isLoading)
        .showAlert(hasAlert: $teachersubjectsvm.isError, alertType: .error( message: "\(teachersubjectsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))

    }
}

#Preview {
    TeacherSubjectsDataView()
        .environmentObject(LookUpsVM())
        .environmentObject(SignUpViewModel())
}
