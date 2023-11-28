//
//  ManageTeacherSchedualsView.swift
//  MrS-Cool
//
//  Created by wecancity on 28/11/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct ManageTeacherSchedualsView: View {
    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var manageteacherschedualsvm : ManageTeacherSchedualsVM
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
//    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var selectedSubject:TeacherSubjectM?
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Manage my Schedules")
            
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            VStack(alignment: .leading, spacing: 0){
                                // -- Data Title --
                                HStack(alignment: .top){
                                    SignUpHeaderTitle(Title: "Add New Schedule")
                                }
                                // -- inputs --
                                Group {
                                    CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $manageteacherschedualsvm.day,options:lookupsvm.EducationTypesList)

                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$manageteacherschedualsvm.startDate,datePickerComponent:.date)

                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$manageteacherschedualsvm.endDate,datePickerComponent:.date)

                                    CustomDatePickerField(iconName:"img_maskgroup7cl",rightIconName: "",placeholder: "Start Time", selectedDateStr:$manageteacherschedualsvm.startTime,datePickerComponent:.hourAndMinute)

                                    CustomDatePickerField(iconName:"img_maskgroup7cl",rightIconName: "",placeholder: "End Time", selectedDateStr:$manageteacherschedualsvm.endTime,datePickerComponent:.hourAndMinute)
                                }
                                .padding([.top])
                            }.padding(.top,20)
                            
                            HStack {
                                Group{
                                    CustomButton(Title: "Save" ,IsDisabled: .constant(false), action: {
                                            manageteacherschedualsvm.CreateTeacherSchedual()
                                    })
                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                        manageteacherschedualsvm.clearTeacherSchedual()
                                    })
                                }
                                .frame(width:120,height: 40)
                                
                            }.padding(.vertical)
                            
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Schedules")
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
                                            CustomDropDownField(iconName:"img_vector",placeholder: "Day", selectedOption: $manageteacherschedualsvm.filterDay,options:lookupsvm.EducationTypesList)

                                            
                                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$manageteacherschedualsvm.filterStartDate,datePickerComponent:.date)

                                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$manageteacherschedualsvm.filterEndDate,datePickerComponent:.date)

                                     }
                                        
                                        Spacer()
                                        HStack {
                                            Group{
                                                CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                                    manageteacherschedualsvm.GetTeacherScheduals()
                                                    showFilter = false
                                                })
                                                
                                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                    manageteacherschedualsvm.clearFilter()
                                                    manageteacherschedualsvm.GetTeacherScheduals()
                                                    showFilter = false
                                                })
                                            } .frame(width:130,height:40)
                                                .padding(.vertical)
                                        }
                                        //                                    Spacer()
                                    }
                                    .padding()
                                    //                                    .presentationDetents([.medium,.fraction(0.75)])
                                    .presentationDetents([.fraction(0.45),.medium])
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        List(manageteacherschedualsvm.TeacherSubjects ?? [] ,id:\.self){ subject in
//                            ManageSubjectCell(model: subject, editSubjectBtnAction:{
////                                manageteacherschedualsvm.selectSubjectForEdit(item: subject)
//                            },editLessonsBtnAction: {
//                                destination = AnyView(ManageTeacherSubjectLessonsView(currentSubject:subject)
//                                    .environmentObject(LookUpsVM())
//                                    .environmentObject(ManageTeacherSubjectLessonsVM())
//                                )
//                                isPush = true
//                            }, deleteBtnAction:{
//                                manageteacherschedualsvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
//                                    manageteacherschedualsvm.DeleteTeacherSubject(id: subject.id)
//                                })
//                                manageteacherschedualsvm.isError.toggle()
//                            })
                            Text("goo")
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .frame(height: gr.size.height/2)
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .onAppear(perform: {
                lookupsvm.GetEducationTypes()
                manageteacherschedualsvm.GetTeacherScheduals()
            })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onDisappear {
            manageteacherschedualsvm.cleanup()
        }
        //        .showHud(isShowing: $teachersubjectsvm.isLoading)
        //        .showAlert(hasAlert: $teachersubjectsvm.isError, alertType: .error( message: "\(teachersubjectsvm.error?.localizedDescription ?? "")",buttonTitle:"Done"))
        //        .onChange(of: teachersubjectsvm.isLoading, perform: { value in
        //            signupvm.isLoading = value
        //        })
        NavigationLink(destination: destination, isActive: $isPush, label: {})
        
    }
}

@available(iOS 16.0, *)
#Preview {
    ManageTeacherSchedualsView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(ManageTeacherSchedualsVM())
    
}
