//
//  SubjectGroupDetailsView.swift
//  MrS-Cool
//
//  Created by wecancity on 10/12/2023.
//

enum PreviewOptions{
    case newGroup, existingGroup
}
import SwiftUI

struct SubjectGroupDetailsView: View {  
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var subjectgroupvm : ManageSubjectGroupVM

    //    @State var isPush = false
    //    @State var destination = EmptyView()
    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var previewOption:PreviewOptions? = .newGroup

//    @State var isPush = false
//    @State var destination = AnyView(EmptyView())

    var body: some View {
            VStack {
                CustomTitleBarView(title: "Manage Groups For Lesson")
                
                GeometryReader { gr in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                VStack(alignment: .leading, spacing: 0){
                                    // -- Data Title --
                                    HStack(alignment: .top){
                                        SignUpHeaderTitle(Title:"Group Information")
                                        Spacer()
                                    }
                                    //                                .padding(.bottom )
                                    
                                    // -- inputs --
                                    Group {
                                        HStack(alignment:.top){
                                            VStack(alignment:.leading){
                                                Text("Subject".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                //
                                                Text(subjectgroupvm.TeacherSubjectGroupsDetails?.teacherSubjectAcademicSemesterYearName ?? "subhect name name")
                                                    .font(Font.SoraRegular(size: 14))
                                                //
                                                Spacer().frame(height:30)
                                                //
                                                Text("Start Date".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.startDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                                                    .font(Font.SoraRegular(size: 14))
                                                //
                                                Spacer().frame(height:30)
                                                //
                                                Text("Num Of Lessons".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                Group{
                                                    Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.numLessons ?? 0) ")
                                                    + Text("Lesson".localized())
                                                }
                                                .font(Font.SoraRegular(size: 14))
                                            }
                                            Spacer()
                                            
                                            VStack(alignment:.leading){
                                                Text("Group Name".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(subjectgroupvm.TeacherSubjectGroupsDetails?.groupName ?? "group 1")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:30)
                                                
                                                Text("End Date".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.endDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
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
                                    SignUpHeaderTitle(Title: "Lessons Schedule")
                                    Spacer()
                                }
                                .padding(.top)
                                
                            }
                            .padding(.horizontal)
                            List(subjectgroupvm.TeacherSubjectGroupsDetails?.scheduleSlots ?? [], id:\.self) { group in
                                SubjectGroupDetailsCell(number:1 ,model: group)
                                    .listRowSpacing(0)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .padding(.vertical,-4)
                                
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
                if previewOption == .newGroup{
                    HStack {
                        Group{
                            CustomButton(Title: "Save" ,IsDisabled: .constant(false), action: {
                                subjectgroupvm.error = .question(title: "", image: "savegroupIcon", message: "Are you sure you want to Save ?", buttonTitle: "Save", secondButtonTitle: "Clear", mainBtnAction: {
                                    subjectgroupvm.CreateTeacherGroup()
                                })
                                subjectgroupvm.isError = true
                            })
                            CustomBorderedButton(Title:"Back",IsDisabled: .constant(false), action: {
                                //                                    subjectgroupvm.clearTeacherGroup()
                                dismiss()
                            })
                        }
                        .frame(width:150,height: 40)
                        
                    }.padding(.vertical)
                }
//                .onAppear(perform: {
//                    manageteachersubjectlessonsvm.subjectSemesterYearId = currentSubject?.subjectAcademicYearID ?? 0
//                    manageteachersubjectlessonsvm.GetTeacherSubjectLessons()
//                })

            }
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            .onChange(of: subjectgroupvm.TeacherSubjectGroupCreated){value in
                if value == true {
                    dismiss()
                }
            }
//            .onDisappear {
//                subjectgroupvm.cleanup()
//            }
            .showHud(isShowing: $subjectgroupvm.isLoading)
            .showAlert(hasAlert: $subjectgroupvm.isError, alertType: subjectgroupvm.error)
        
//        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    SubjectGroupDetailsView()
        .environmentObject(LookUpsVM())
        .environmentObject(ManageSubjectGroupVM())
}
