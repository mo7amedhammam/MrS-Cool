//
//  GroupForLessonView.swift
//  MrS-Cool
//
//  Created by wecancity on 02/12/2023.
//

import SwiftUI

struct GroupForLessonView: View {
    //        @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var groupsforlessonvm = GroupForLessonVM()
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    //    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    //    var selectedSubject:TeacherSubjectM?
    @State var showConfirmDelete = false
    
    @State var filtersubject : DropDownOption?
    @State var filterlesson : DropDownOption?
    @State var filtergroupName : String = ""
    @State var filterdate : String?
    func sendFilterValues(){
        groupsforlessonvm.filtersubject = filtersubject
        groupsforlessonvm.filterlesson = filterlesson
        groupsforlessonvm.filtergroupName = filtergroupName
        groupsforlessonvm.filterdate = filterdate
        groupsforlessonvm.GetTeacherGroups()
    }
    func clearFilterValues(){
        filtersubject = nil
        filterlesson = nil
        filtergroupName = ""
        filterdate = nil
        lookupsvm.FilterLessonsForList.removeAll()
        groupsforlessonvm.clearFilter()
    }
    func validateFilterValues(){
       if groupsforlessonvm.filtersubject != filtersubject {
           filtersubject = nil
           lookupsvm.FilterLessonsForList.removeAll()
        }
        if groupsforlessonvm.filterlesson != filterlesson{
            filterlesson = nil
        }
        if groupsforlessonvm.filtergroupName != filtergroupName{
            filtergroupName = ""
        }
        if groupsforlessonvm.filterdate != filterdate{
            filterdate = nil
        }
    }
    
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
                                    
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "Subject", selectedOption: $groupsforlessonvm.subject,options:lookupsvm.SubjectsForList,isvalid:groupsforlessonvm.issubjectvalid)
                                        .onChange(of: groupsforlessonvm.subject){newval in
                                            if lookupsvm.SelectedSubjectForList != groupsforlessonvm.subject{
                                                lookupsvm.SelectedSubjectForList = groupsforlessonvm.subject
                                            }
                                        }
                                    
                                    CustomDropDownField(iconName:"img_group_512388",placeholder: "Lesson", selectedOption: $groupsforlessonvm.lesson,options:lookupsvm.LessonsForList,isvalid:groupsforlessonvm.islessonvalid)
                                        .overlay(content: {
                                            if  (groupsforlessonvm.lesson?.subTitle ?? 0) > 0  {
                                                VStack(alignment: .trailing) {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        Group{
                                                            Text("This Lesson Takes".localized())+Text(" \(groupsforlessonvm.lesson?.subTitle ?? 0) ")+Text("mins".localized())
                                                        }        .font(Font.bold(size: 9))
                                                            .foregroundColor(ColorConstants.LightGreen800)
                                                    }
                                                }
                                                .padding([.bottom,.trailing],5)
                                            }
                                        })
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $groupsforlessonvm.groupName,isvalid:groupsforlessonvm.isgroupNamevalid)
                                    
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date", selectedDateStr:$groupsforlessonvm.date,startDate:Date(),datePickerComponent:.date,isvalid:groupsforlessonvm.isdatevalid)
                                    
                                    CustomDatePickerField(iconName:"img_maskgroup7cl",rightIconName: "",placeholder: "Start Time", selectedDateStr:$groupsforlessonvm.time,timeZone:.current,datePickerComponent:.hourAndMinute,isvalid:groupsforlessonvm.istimevalid)
                                        .overlay(content: {
                                            if  (groupsforlessonvm.endTime) != nil {
                                                VStack(alignment: .trailing) {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        Group{
                                                            Text("End Time Is ".localized())+Text("\(groupsforlessonvm.endTime ?? "")")
                                                        }     .font(Font.bold(size: 9))
                                                            .foregroundColor(ColorConstants.LightGreen800)
                                                    }
                                                }
                                                .padding([.bottom,.trailing],5)
                                            }
                                        })
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
                                        validateFilterValues()
                                    })
                            }
                        }
                        .padding(.horizontal)
                        
                        List(groupsforlessonvm.TeacherGroups ?? [] ,id:\.self){ schedual in
                            GroupForLessonCell(model: schedual, deleteBtnAction: {
                                groupsforlessonvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                    groupsforlessonvm.DeleteTeacherGroup(id: schedual.id)
                                })
                                showConfirmDelete = true
                            })
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding(.vertical,-4)
                        }
                        //                        .scrollContentBackground(.hidden)
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
        .showHud(isShowing: $groupsforlessonvm.isLoading)
        .showAlert(hasAlert: $groupsforlessonvm.isError, alertType: groupsforlessonvm.error)
        .showAlert(hasAlert: $showConfirmDelete, alertType: groupsforlessonvm.error)

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
                                .font(Font.bold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        //                        .padding(.vertical)
                        ScrollView {
                            VStack{
                                Group {
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "Subject", selectedOption: $filtersubject,options:lookupsvm.SubjectsForList).onChange(of:filtersubject) {newval in
//                                        if                                                     lookupsvm.SelectedFilterSubjectForList != groupsforlessonvm.filtersubject{
//                                            lookupsvm.SelectedFilterSubjectForList = groupsforlessonvm.filtersubject
//                                        }
                                        filterlesson = nil
                                        lookupsvm.SelectedFilterSubjectForList = newval
                                    }
                                    
                                    CustomDropDownField(iconName:"img_group_512388",placeholder: "Lesson", selectedOption: $filterlesson,options:lookupsvm.FilterLessonsForList)
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $filtergroupName)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date", selectedDateStr:$filterdate,datePickerComponent:.date)
                                }
                                .padding(.top,5)
                                
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            sendFilterValues()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            clearFilterValues()
                                            showFilter = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                            }
                            .padding(.horizontal,3)
                            .padding(.top)
                        }
                        //                                    .presentationDetents([.fraction(0.50),.medium])
                    }
                    .padding()
                    .frame(height:450)
                    .keyboardAdaptive()
                }
            }
        }
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    GroupForLessonView()
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(GroupForLessonVM())
}


struct DynamicHeightSheet<Content: View>: View {
    @Binding var isPresented: Bool
    var content: () -> Content
    
    var body: some View {
        ZStack {
            //            if isPresented{
            // Background
            //                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            //                    .onTapGesture {
            //                        isPresented = false
            //                    }
            
            // Dynamic Content
            VStack {
                Spacer()
                content()
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .edgesIgnoringSafeArea(.bottom)
            //            }
        }
        .frame(maxWidth: .infinity, maxHeight: isPresented ? .infinity:0)
        .opacity(isPresented ? 1 : 0)
        .animation(.easeInOut)
    }
}

extension View {
    func dynamicHeightSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        DynamicHeightSheet(isPresented: isPresented, content: content)
    }
}



