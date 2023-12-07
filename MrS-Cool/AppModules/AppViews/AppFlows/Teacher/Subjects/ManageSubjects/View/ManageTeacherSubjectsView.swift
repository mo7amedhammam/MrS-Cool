//
//  ManageTeacherSubjectsView.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//

import SwiftUI

struct ManageTeacherSubjectsView: View {
    //    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var manageteachersubjectsvm : ManageTeacherSubjectsVM
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var selectedSubject:TeacherSubjectM?
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Manage my Subjects")
            
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            VStack(alignment: .leading, spacing: 0){
                                // -- Data Title --
                                HStack(alignment: .top){
                                    SignUpHeaderTitle(Title:isEditing ? "Update Your Subject" : "Request New Subject")
                                    //                                Spacer()
                                    //                                Text("(2 / 3)")
                                    //                                    .font(.SoraRegular(size: 14))
                                    //                                    .foregroundColor(.black)
                                }
                                // -- inputs --
                                Group {
                                    CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $manageteachersubjectsvm.educationType,options:lookupsvm.EducationTypesList)
                                    
                                    CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $manageteachersubjectsvm.educationLevel,options:lookupsvm.EducationLevelsList)
                                    
                                    CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $manageteachersubjectsvm.academicYear,options:lookupsvm.AcademicYearsList)
                                    
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject *", selectedOption: $manageteachersubjectsvm.subject,options:lookupsvm.SubjectsList)
                                    
                                    CustomTextField(iconName:"img_group_black_900",placeholder: "Group Price", text: $manageteachersubjectsvm.groupCost,keyboardType:.asciiCapableNumberPad)
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Minimum Number Of Group Students", text: $manageteachersubjectsvm.minGroup ,keyboardType:.asciiCapableNumberPad)
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Maximum Number Of Group Students", text: $manageteachersubjectsvm.maxGroup,keyboardType:.asciiCapableNumberPad)
                                    
                                    CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Price", text: $manageteachersubjectsvm.individualCost,keyboardType:.asciiCapableNumberPad)
                                    
                                    CustomTextEditor(iconName:"img_group512375",placeholder: "Subject Brief", text: $manageteachersubjectsvm.subjectBrief,charLimit: 1000)
                                    
                                }
                                .padding([.top])
                            }.padding(.top,20)
                            
                            HStack {
                                Group{
                                    CustomButton(Title:isEditing ? "Update" : "Save" ,IsDisabled: .constant(false), action: {
                                        if isEditing{
                                            manageteachersubjectsvm.UpdateTeacherSubject()
                                        }else{
                                            manageteachersubjectsvm.CreateTeacherSubject()
                                        }
                                    })
                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                        manageteachersubjectsvm.clearTeachersSubject()
                                        isEditing = false
                                    })
                                }
                                .frame(width:120,height: 40)
                                
                            }.padding(.vertical)
                            
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Subjects")
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
                            HStack(){
                                Spacer()
                                Rectangle().frame(width: 14, height: 14)
                                    .foregroundColor(.yellow)
                                Text("In Review".localized())
                                    .foregroundColor(.mainBlue)
                                    .font(Font.SoraRegular(size: 7))
                                
                                Rectangle().frame(width: 14, height: 14)
                                    .foregroundColor(.green)
                                Text("Approved".localized())
                                    .foregroundColor(.mainBlue)
                                    .font(Font.SoraRegular(size: 7))
                                
                                Rectangle().frame(width: 14, height: 14)
                                    .foregroundColor(.red)
                                Text("Rejected".localized())
                                    .foregroundColor(.mainBlue)
                                    .font(Font.SoraRegular(size: 7))
                            }
                        }
                        .padding(.horizontal)
                        
                        List(manageteachersubjectsvm.TeacherSubjects ?? [] ,id:\.self){ subject in
                            ManageSubjectCell(model: subject, editSubjectBtnAction:{
                                isEditing = true
                                manageteachersubjectsvm.selectSubjectForEdit(item: subject)
                            },editLessonsBtnAction: {
                                destination = AnyView(ManageTeacherSubjectLessonsView(currentSubject:subject)
                                    .environmentObject(LookUpsVM())
                                    .environmentObject(ManageTeacherSubjectLessonsVM())
                                )
                                isPush = true
                            }, deleteBtnAction:{
                                manageteachersubjectsvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                    manageteachersubjectsvm.DeleteTeacherSubject(id: subject.id)
                                })
                                manageteachersubjectsvm.isError.toggle()
                            })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.vertical,-4)
                    }
//                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                        .frame(height: gr.size.height/2)
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
                //                                signupvm.isUserChangagble = false
                lookupsvm.GetEducationTypes()
                manageteachersubjectsvm.GetTeacherSubjects()
            })
            .onChange(of: manageteachersubjectsvm.educationType, perform: { value in
                lookupsvm.SelectedEducationType = value
            })
            .onChange(of: manageteachersubjectsvm.educationLevel, perform: { value in
                lookupsvm.SelectedEducationLevel = value
            })
            .onChange(of: manageteachersubjectsvm.academicYear, perform: { value in
                lookupsvm.SelectedAcademicYear = value
            })
            //            .onChange(of: teachersubjectsvm.isTeacherHasSubjects, perform: { value in
            //                signupvm.isTeacherHasSubjects = value
            //        })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        .onDisappear {
            manageteachersubjectsvm.cleanup()
        }
        .showHud(isShowing: $manageteachersubjectsvm.isLoading)
        .showAlert(hasAlert: $manageteachersubjectsvm.isError, alertType: manageteachersubjectsvm.error)
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
                                    CustomDropDownField(iconName:"img_vector",placeholder: "Education Type", selectedOption: $manageteachersubjectsvm.filterEducationType,options:lookupsvm.EducationTypesList)
                                    //                                                .onTapGesture(perform: {
                                    //                                                    lookupsvm.GetEducationTypes()
                                    //                                                })
                                        .onChange(of: manageteachersubjectsvm.filterEducationType){val in
                                            lookupsvm.SelectedEducationType = val
                                        }
                                    
                                    CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level", selectedOption: $manageteachersubjectsvm.filterEducationLevel,options:lookupsvm.EducationLevelsList)
                                        .onChange(of:manageteachersubjectsvm.filterEducationLevel){val in
                                            lookupsvm.SelectedEducationLevel = val
                                        }
                                    
                                    CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year", selectedOption: $manageteachersubjectsvm.filterAcademicYear,options:lookupsvm.AcademicYearsList)
                                        .onChange(of:manageteachersubjectsvm.filterAcademicYear){val in
                                            lookupsvm.SelectedAcademicYear = val
                                        }
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $manageteachersubjectsvm.filterSubject,options:lookupsvm.SubjectsList)
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject Status", selectedOption: $manageteachersubjectsvm.filterSubjectStatus,options:lookupsvm.SubjectsList)
                                }
                                .padding(.top,5)
                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            manageteachersubjectsvm .GetTeacherSubjects()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            manageteachersubjectsvm.clearFilter()
                                            manageteachersubjectsvm .GetTeacherSubjects()
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
                    .frame(height:515)
//                    .keyboardAdaptive()
                }

            }
        }
        NavigationLink(destination: destination, isActive: $isPush, label: {})
        
    }
}

#Preview {
    ManageTeacherSubjectsView()
        .environmentObject(LookUpsVM())
        .environmentObject(ManageTeacherSubjectsVM())
}
