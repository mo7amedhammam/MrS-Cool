//
//  ManageSubjectGroupView.swift
//  MrS-Cool
//
//  Created by wecancity on 06/12/2023.
//


import SwiftUI

struct ManageSubjectGroupView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var subjectgroupvm = ManageSubjectGroupVM.shared
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    //    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    //    var selectedSubject:TeacherSubjectM?
    @State private var countHints: [Int: Bool] = [:]
    @State private var orderHints: [Int: Bool] = [:]
    
    @State var showConfirmDelete = false
    //    @State var addExtraSession = true
    //    @State var selectedGrup = SubjectGroupM()
    
    fileprivate func preparelessonscounts() -> Bool {
        //        print("updated lookupsvm.LessonsForList/n",lookupsvm.LessonsForList)
        subjectgroupvm.teacherLessonList = subjectgroupvm.AllLessonsForList.compactMap{option in
            //            return option.LessonItem
            
            if option.isSelected == true {
                return option.LessonItem
            }
            return nil
        }
        //        print("subjectgroupvm.CreateTeacherLessonList",subjectgroupvm.CreateTeacherLessonList)
        
        // Check if there are no selected items
        guard !subjectgroupvm.teacherLessonList.isEmpty else {
            subjectgroupvm.error = .error(title:  "", image: "img_group", message: "You must choose at least one lesson", buttonTitle: "OK", mainBtnAction: {})
            subjectgroupvm.isError = true
            return false
        }
        
        return true
    }
    
    //    @State var AllLessonsForList: [DropDownOption] = []
    
    @ViewBuilder
    fileprivate func ExtraSession() -> some View {
        VStack{
            ColorConstants.Bluegray100
                .frame(width:50,height:5)
                .cornerRadius(2.5)
                .padding(.top,2)
            HStack {
                Text("Extra Session".localized())
                    .font(Font.bold(size: 18))
                    .foregroundColor(.mainBlue)
            }.padding(8)
            ScrollView{
                Group {
                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِLesson", selectedOption: $subjectgroupvm.extraLesson,options:lookupsvm.AllLessonsForList,isvalid: subjectgroupvm.isextraLessonvalid)
                    
                    let startDate = Date()
                    CustomDatePickerField(iconName:"img_group148",placeholder: "Date", selectedDateStr:$subjectgroupvm.extraDate,startDate: startDate,datePickerComponent:.date,isvalid: subjectgroupvm.isextraDatevalid)
                    
                    CustomDatePickerField(iconName:"img_maskgroup7cl",placeholder: "Start Time", selectedDateStr:$subjectgroupvm.extraTime,timeZone:TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current,datePickerComponent:.hourAndMinute,isvalid:subjectgroupvm.isextraTimevalid)
                    
                }
                .padding(.top,5)
                
                HStack {
                    Group{
                        CustomButton(Title:"Save",IsDisabled: .constant(false), action: {
                            subjectgroupvm.CreateExtraSession()
                            //                                subjectgroupvm.ShowAddExtraSession = false
                        })
                        
                        CustomBorderedButton(Title:"Cancel",IsDisabled: .constant(false), action: {
                            subjectgroupvm.clearExtraSession()
                            //                            subjectgroupvm.GetTeacherSubjectGroups()
                            subjectgroupvm.ShowAddExtraSession = false
                        })
                    }
                    .frame(width:130,height:40)
                    .padding(.vertical)
                }
                .padding(.horizontal,3)
                .padding(.top)
                
            }
            .frame(height: 320)
        }
        //            .localizeView()
        .background(ColorConstants.WhiteA700.cornerRadius(8))
        .padding()
    }
    
    @ViewBuilder
    fileprivate func FilterView() -> DynamicHeightSheet<some View> {
        // Adjust the blur radius as needed
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
                            CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $subjectgroupvm.filtersubject,options:lookupsvm.SubjectsForList)
                            
                            CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $subjectgroupvm.filtergroupName)
                            
                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$subjectgroupvm.filterstartdate,datePickerComponent:.date)
                            
                            CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$subjectgroupvm.filterenddate,datePickerComponent:.date)
                            
                        }
                        .padding(.top,5)
                        
                        //                                Spacer()
                        HStack {
                            Group{
                                CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                    Task{
                                        await subjectgroupvm.fetchSubjectGroups()
                                    }
                                    showFilter = false
                                })
                                
                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                    subjectgroupvm.clearFilter()
                                    Task{
                                        await subjectgroupvm.fetchSubjectGroups()
                                    }
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
            .frame(height:450)
            .keyboardAdaptive()
        }
    }
        
    @MainActor
    private func fetchlessons(id:Int)async{
        await lookupsvm.GetAllLessonsForList(id: id)
        subjectgroupvm.AllLessonsForList = lookupsvm.AllLessonsForList
    }
    
    @State var showzerocosthint = false
    @State var showsubjects = false

    var body: some View {
        VStack {
            CustomTitleBarView(title: "Manage Groups For Subject",action: {
                subjectgroupvm.clearTeacherGroup()
                dismiss()
            })
            
            GeometryReader { gr in
                ScrollView(.vertical,showsIndicators: false){
                    VStack{ // (Title - Data - Submit Button)
                        Group{
                            VStack(alignment: .leading, spacing: 0){
                                // -- Data Title --
                                HStack(alignment: .top){
                                    SignUpHeaderTitle(Title: "Add New Subject Group")
                                }
                                // -- inputs --
                                Group {
                                    CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $subjectgroupvm.subject,options:lookupsvm.SubjectsForList,isvalid:subjectgroupvm.issubjectvalid)
                                        .onChange(of: subjectgroupvm.subject){newval in
                                            guard let newval = newval,let id = newval.id else {return}
                                            if newval.subject?.groupSessionCost == 0{
                                                showzerocosthint = true
                                            }else{
                                                showzerocosthint = false
                                            }
                                            
                                            Task{
                                                await fetchlessons(id:id)
                                            }
                                            //                                            subjectgroupvm.AllLessonsForList.removeAll()
                                            //                                            lookupsvm.AllLessonsForList.removeAll()
                                            //                                            lookupsvm.SelectedSubjectForList = subjectgroupvm.subject
                                            //                                            if let id = newval.id{
                                            //                                           await lookupsvm.GetAllLessonsForList(id: id)
                                            //                                            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:{
                                            //                                                    AllLessonsForList = lookupsvm.AllLessonsForList
                                            //                                                subjectgroupvm.AllLessonsForList = lookupsvm.AllLessonsForList
                                            //                                            })
                                            
                                            //                                            }
                                        }
                                    
                                    if subjectgroupvm.subject != nil{
                                        // Validation hint for Lesson Order
                                        if let price = Float(subjectgroupvm.SessionPrice), !(price > 0){
                                                Text("Session Price cannot be 0".localized())
                                                .foregroundColor(.red)
                                                .font(Font.semiBold(size: 11))
                                        }

                                        CustomTextField(iconName:"img_group_black_900",placeholder: "Session Price *", text: $subjectgroupvm.SessionPrice,keyboardType:.decimalPad,isvalid:subjectgroupvm.isSessionPricevalid)
                                            .onChange(of: subjectgroupvm.SessionPrice) { newValue in
                                                subjectgroupvm.SessionPrice = newValue.filter { $0.isEnglish }
                                            }
                                            .sheet(isPresented: $showsubjects, onDismiss: {
                                                subjectgroupvm.subject = nil
                                                lookupsvm.GetSubjestForList()
                                                showzerocosthint = false
                                            }, content: {
                                                ManageTeacherSubjectsView()
                                            })
                                        
                                        if showzerocosthint {
                                            HStack(){
                                                Text("You Can Change Group Cost".localized())
                                                    .foregroundColor(ColorConstants.MainColor)
                                                    .font(Font.semiBold(size: 11))
                                                Button(action: {
                                                    showsubjects = true
                                                },label:{
                                                    Text("Click Here".localized())
                                                        .font(Font.semiBold(size: 12))

                                                })
                                                Spacer()
                                            }
                                        }
                                        
                                        lessonsOrder(countHints: $countHints, orderHints: $orderHints).environmentObject(subjectgroupvm)
                                    }
                                    
                                    
                                    CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $subjectgroupvm.groupName,isvalid:subjectgroupvm.isgroupNamevalid)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$subjectgroupvm.startDate,startDate:Date(),datePickerComponent:.date,isvalid:subjectgroupvm.isstartDatevalid)
                                }
                                .padding([.top])
                                
                                // -- Data Title --
                                HStack(alignment: .top){
                                    SignUpHeaderTitle(Title: "Lessons Schedule")
                                }.padding(.top)
                                
                                // -- list --
                                ForEach(Array(subjectgroupvm.DisplaySchedualSlotsArr.enumerated()), id: \.element) { (index, slot) in
                                    Group {
                                        CustomDropDownField(iconName: "img_group148", placeholder: "Day", selectedOption: .constant(slot.day), options: lookupsvm.daysList)
                                            .disabled(true)
                                        
                                        HStack {
                                            CustomDatePickerField(iconName: "img_maskgroup7cl", rightIconName: nil, placeholder: "Start Time", selectedDateStr: .constant(slot.fromTime), datePickerComponent: .hourAndMinute)
                                                .disabled(true)
                                            
                                            Button(action: {
                                                // Handle the delete action
                                                subjectgroupvm.deleteFromDisplaySchedualSlot(at: index)
                                            }) {
                                                Image("img_group")
                                                    .resizable()
                                                    .frame(width: 20, height: 20, alignment: .leading)
                                                    .aspectRatio(contentMode: .fill)
                                            }
                                            .frame(width: 40, height: 40)
                                            .buttonStyle(.plain)
                                            .overlay(RoundedCorners(topLeft: 8, topRight: 8, bottomLeft: 8, bottomRight: 8)
                                                .stroke(.mainBlue, lineWidth: 1.5))
                                            .frame(width: 40, height: 40)
                                        }
                                    }
                                    .padding([.top])
                                }
                                
                                // -- inputs --
                                if subjectgroupvm.DisplaySchedualSlotsArr.count < 7{
                                    Group {
                                        CustomDropDownField(iconName:"img_group148",placeholder: "Day", selectedOption: $subjectgroupvm.day,options:lookupsvm.daysList)
                                        
                                        HStack {
                                            CustomDatePickerField(iconName:"img_maskgroup7cl",placeholder: "Start Time", selectedDateStr:$subjectgroupvm.startTime,timeZone:TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current,datePickerComponent:.hourAndMinute)
                                        }
                                        
                                        HStack{
                                            Spacer()
                                            Group{
                                                CustomButton(imageName:"icons8-plus-90",Title: "" ,IsDisabled: .constant(subjectgroupvm.day == nil || subjectgroupvm.startTime == nil), action: {
                                                    subjectgroupvm.DisplaySchedualSlotsArr.append( NewScheduleSlotsM.init(day: subjectgroupvm.day,fromTime:subjectgroupvm.startTime))
                                                    subjectgroupvm.clearCurrentSlot()
                                                    
                                                })
                                                CustomBorderedButton(imageName:"icons8-broom-90",Title:"",IsDisabled: .constant(subjectgroupvm.day == nil && subjectgroupvm.startTime == nil), action: {
                                                    subjectgroupvm.clearCurrentSlot()
                                                })
                                            }
                                            .frame(width:40,height: 40)
                                        }
                                    }
                                    .padding([.top])
                                }
                                
                            }.padding(.top,20)
                            
                            HStack {
                                Group{
                                    CustomButton(Title: "Review Details" ,IsDisabled: .constant(subjectgroupvm.DisplaySchedualSlotsArr.isEmpty), action: {
                                        guard !(countHints.values.contains(true) || orderHints.values.contains(true)) else {return}
                                        guard preparelessonscounts() else{ return }
                                        
                                        subjectgroupvm.ReviewTeacherGroup()
                                        destination = AnyView(    SubjectGroupDetailsView(isPriceCustomizable: true,previewOption: .newGroup).hideNavigationBar().environmentObject(subjectgroupvm).environmentObject(lookupsvm))
                                    })
                                    CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                        subjectgroupvm.clearTeacherGroup()
                                    })
                                }
                                .frame(width:150,height: 40)
                                
                            }.padding(.vertical)
                            
                            HStack(){
                                SignUpHeaderTitle(Title: "Manage My Subject Groups")
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
                            
                        }
                        .padding(.horizontal)
              listGroups( isPush: $isPush, destination: $destination, gr: gr)
                            .environmentObject(subjectgroupvm)
                            .environmentObject(lookupsvm)
                        
                        Spacer()
                    }
                    .frame(minHeight: gr.size.height)
                }
            }
            .task{
                //                subjectgroupvm.subject = nil
                subjectgroupvm.clearFilter()
//                subjectgroupvm.GetTeacherSubjectGroups()
                await subjectgroupvm.fetchSubjectGroups()
            }
            .onAppear(perform: {
                lookupsvm.GetSubjestForList()
                lookupsvm.GetDays()
                //                    subjectgroupvm.GetTeacherSubjectGroups()
            })
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onDisappear {
            subjectgroupvm.cleanup()
        }
        
        .bottomSheet(isPresented: $subjectgroupvm.ShowAddExtraSession){
            ExtraSession()
            
        }
        .overlay{
            if showFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                    .blur(radius: 4)
                FilterView()
            }
        }
        
        .showHud(isShowing: $subjectgroupvm.isLoading)
        .showAlert(hasAlert: $subjectgroupvm.isError, alertType: subjectgroupvm.error)
        .showAlert(hasAlert: $subjectgroupvm.showConfirmDelete, alertType: subjectgroupvm.error)
        
        NavigationLink(destination: destination, isActive: $subjectgroupvm.letsPreview, label: {})
    }
}

#Preview {
    ManageSubjectGroupView()
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(ManageSubjectGroupVM())
}


struct lessonsOrder: View {
    @EnvironmentObject var subjectgroupvm : ManageSubjectGroupVM
    @Binding var countHints: [Int: Bool]
    @Binding var orderHints: [Int: Bool]
    
    
    var body: some View {
        ForEach(subjectgroupvm.AllLessonsForList.indices,id:\.self){index in
            LazyVStack{
                Button(action: {
                    subjectgroupvm.AllLessonsForList[index].isSelected?.toggle()
                }, label: {
                    HStack {
                        Text(subjectgroupvm.AllLessonsForList[index].LessonItem?.lessonName ?? "")
                            .fontWeight(.medium)
                            .frame(maxWidth:.infinity,alignment:.leading)
                            .foregroundColor(ColorConstants.MainColor)
                        
                        // Checkbox for selection
                        let isSelected = subjectgroupvm.AllLessonsForList[index].isSelected ?? false
                        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            .resizable()
                            .foregroundColor(isSelected ? ColorConstants.MainColor : .gray)
                            .frame(width: 20, height: 20)
                        
                    }
                })
                
                // Validation hint for Lesson No
                if let showHint = countHints[index], showHint {
                    Text("Number must be between 1 and 5".localized())
                        .foregroundColor(.red)
                        .font(Font.semiBold(size: 11))
                }
                
                // Validation hint for Lesson Order
                if let showHint = orderHints[index], showHint {
                    Text("Order cannot be 0".localized())
                        .foregroundColor(.red)
                        .font(Font.semiBold(size: 11))
                }
                
                HStack{
                    
                    CustomTextField(placeholder: "Lesson No",
                                    text: Binding(
                                        get: {
                                            if index >= 0 && index < subjectgroupvm.AllLessonsForList.count {
                                                return subjectgroupvm.AllLessonsForList[index].LessonItem?.count.map { String($0) } ?? ""
                                            } else {
                                                return ""  // Default value if index is out of range
                                            }                                                                        },
                                        set: { newValue in
                                            subjectgroupvm.AllLessonsForList[index].LessonItem?.count = Int(newValue)
                                            if index >= 0 && index < subjectgroupvm.AllLessonsForList.count {
                                                if let intValue = Int(newValue), intValue > 0 && intValue <= 5 {
                                                    countHints[index] = false  // Show hint for invalid input
                                                    
                                                } else {
                                                    countHints[index] = true  // Show hint for invalid input
                                                    
                                                }                                                                        }
                                        }),
                                    keyboardType: .asciiCapableNumberPad,
                                    isvalid: !(countHints[index] ?? false))
                    
                    CustomTextField(placeholder: "Lesson Order",
                                    text: Binding(
                                        get: {
                                            if index >= 0 && index < subjectgroupvm.AllLessonsForList.count {
                                                return   subjectgroupvm.AllLessonsForList[index].LessonItem?.order.map { String($0) } ?? ""
                                            } else {
                                                return ""  // Default value if index is out of range
                                            }
                                        },
                                        set: { newValue in
                                            subjectgroupvm.AllLessonsForList[index].LessonItem?.order = Int(newValue)
                                            
                                            if index >= 0 && index < subjectgroupvm.AllLessonsForList.count {
                                                if let intValue = Int(newValue), intValue > 0 {
                                                    orderHints[index] = false  // Show hint for invalid input
                                                    
                                                } else {
                                                    orderHints[index] = true  // Show hint for invalid input
                                                    
                                                }
                                            }
                                        }),
                                    keyboardType: .asciiCapableNumberPad,
                                    isvalid: !(orderHints[index] ?? false))
                    
                }
            }
            .padding()
            .font(Font.regular(size: 13))
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0).fill(ColorConstants.WhiteA700))
            .overlay(RoundedCorners(topLeft: 5.0, topRight: 5.0, bottomLeft: 5.0,bottomRight: 5.0)
                .stroke(ColorConstants.Bluegray30066,
                        lineWidth: 1))
        }
    }
}



struct listGroups: View {
    @EnvironmentObject var subjectgroupvm : ManageSubjectGroupVM
    @EnvironmentObject var lookupsvm : LookUpsVM

    @Binding var isPush : Bool
    @Binding var destination : AnyView
    var gr:GeometryProxy
    
    @MainActor
    private func fetchlessons(id:Int)async{
        await lookupsvm.GetAllLessonsForList(id: id)
    }
    
    var body: some View {
        
        List(subjectgroupvm.TeacherSubjectGroups ?? [] ,id:\.self){ group in
            ManageSubjectGroupCell(model: group,
                                   reviewBtnAction:{
                subjectgroupvm.GetTeacherGroupDetails(id: group.id)
                destination = AnyView(SubjectGroupDetailsView(previewOption: .existingGroup)
                    .hideNavigationBar()
                    .environmentObject(subjectgroupvm)
                    .environmentObject(lookupsvm)
                )
                
            },extraTimetnAction: {
                subjectgroupvm.clearExtraSession()
                if let id = group.teacherSubjectAcademicSemesterYearID {
//                    lookupsvm.GetAllLessonsForList(id: id)
                    Task{
                        await fetchlessons(id: id)
                    }
                }
                subjectgroupvm.selectedGroup = group
                subjectgroupvm.ShowAddExtraSession = true
            }, deleteBtnAction: {
                subjectgroupvm.error = .question( image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                    subjectgroupvm.DeleteTeacherGroup(id: group.id)
                })
                subjectgroupvm.showConfirmDelete = true
            })
            .listRowSpacing(0)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .padding(.vertical,-4)
        }
        //                        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .frame(height: gr.size.height/2)
    }
}

