//
//  GroupForLessonView.swift
//  MrS-Cool
//
//  Created by wecancity on 02/12/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct GroupForLessonView: View {
    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var groupsforlessonvm : GroupForLessonVM
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    //    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    //    var selectedSubject:TeacherSubjectM?
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
                                    SignUpHeaderTitle(Title: "Create New Group For Lesson")
                                }
                                // -- inputs --
                                Group {
                                    
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $groupsforlessonvm.subject,options:lookupsvm.SubjectsForList)  
                                        .onChange(of: groupsforlessonvm.subject){newval in
                                        if lookupsvm.SelectedSubjectForList != groupsforlessonvm.subject{
                                            lookupsvm.SelectedSubjectForList = groupsforlessonvm.subject
                                        }
                                    }
                                    
                                    CustomDropDownField(iconName:"img_group_512388",placeholder: "ِLesson", selectedOption: $groupsforlessonvm.lesson,options:lookupsvm.LessonsForList)

                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $groupsforlessonvm.groupName)
                                    
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date", selectedDateStr:$groupsforlessonvm.date,datePickerComponent:.date)
                                    
                                    CustomDatePickerField(iconName:"img_maskgroup7cl",rightIconName: "",placeholder: "Start Time", selectedDateStr:$groupsforlessonvm.time,datePickerComponent:.hourAndMinute)
                                }
                                .padding([.top])
                            }.padding(.top,20)
                            
                            HStack {
                                Group{
                                    CustomButton(Title: "Save" ,IsDisabled: .constant(false), action: {
                                        groupsforlessonvm.CreateTeacherGroup()
                                    })
                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                        groupsforlessonvm.clearTeacherGroup()
                                    })
                                }
                                .frame(width:120,height: 40)
                                
                            }.padding(.vertical)
                            
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Groups For Lessons")
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
                                            Text("Filter".localized())
                                                .font(Font.SoraBold(size: 18))
                                                .foregroundColor(.mainBlue)
                                            //                                            Spacer()
                                        }
                                        .padding(.vertical)
                                        Group {
                                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $groupsforlessonvm.filtersubject,options:lookupsvm.SubjectsForList).onChange(of:groupsforlessonvm.subject) {newval in
                                                if                                                     lookupsvm.SelectedSubjectForList != groupsforlessonvm.filtersubject
                                                {
                                                    lookupsvm.SelectedSubjectForList = groupsforlessonvm.filtersubject
                                                }
                                            }
                                            
                                            CustomDropDownField(iconName:"img_group_512388",placeholder: "ِLesson", selectedOption: $groupsforlessonvm.filterlesson,options:lookupsvm.LessonsForList)
                                            
                                            CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $groupsforlessonvm.filtergroupName)
                                            
                                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date", selectedDateStr:$groupsforlessonvm.filterdate,datePickerComponent:.date)
                                        }
                                        
                                        Spacer()
                                        HStack {
                                            Group{
                                                CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                                    groupsforlessonvm.GetTeacherGroups()
                                                    showFilter = false
                                                })
                                                
                                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                    groupsforlessonvm.clearFilter()
                                                    groupsforlessonvm.GetTeacherGroups()
                                                    showFilter = false
                                                })
                                            } .frame(width:130,height:40)
                                                .padding(.vertical)
                                        }
                                    }
                                    .padding()
                                    .presentationDetents([.fraction(0.50),.medium])
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        List(groupsforlessonvm.TeacherGroups ?? [] ,id:\.self){ schedual in
                            GroupForLessonCell(model: schedual, deleteBtnAction: {
                                groupsforlessonvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                    groupsforlessonvm.DeleteTeacherGroup(id: schedual.id)
                                })
                                groupsforlessonvm.isError.toggle()
                            })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.vertical,-4)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .frame(height: gr.size.height/2)
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
                lookupsvm.GetSubjestForList()
                groupsforlessonvm.GetTeacherGroups()
            })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onDisappear {
            groupsforlessonvm.cleanup()
        }
        //        .showHud(isShowing: $teachersubjectsvm.isLoading)
        .showAlert(hasAlert: $groupsforlessonvm.isError, alertType: groupsforlessonvm.error)
        NavigationLink(destination: destination, isActive: $isPush, label: {})
        
    }
}

@available(iOS 16.0, *)
#Preview {
    GroupForLessonView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(GroupForLessonVM())
    
}