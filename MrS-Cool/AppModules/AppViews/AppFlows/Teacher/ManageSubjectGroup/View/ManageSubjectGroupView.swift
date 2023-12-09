//
//  ManageSubjectGroupView.swift
//  MrS-Cool
//
//  Created by wecancity on 06/12/2023.
//


import SwiftUI

struct ManageSubjectGroupView: View {
    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var subjectgroupvm : ManageSubjectGroupVM
    
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
                                        SignUpHeaderTitle(Title: "Add New Subject Group")
                                    }
                                    // -- inputs --
                                    Group {
                                        CustomDropDownField(iconName:"img_group_512380",placeholder: "ِSubject", selectedOption: $subjectgroupvm.subject,options:lookupsvm.SubjectsForList)

                                        CustomTextField(iconName:"img_group58",placeholder: "Group Name", text: $subjectgroupvm.groupName)
                                        
                                        CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$subjectgroupvm.startDate,datePickerComponent:.date)
//                                            .overlay(content: {
//                                                if  (subjectgroupvm.endTime) != nil {
//                                                    VStack(alignment: .trailing) {
//                                                        Spacer()
//                                                        HStack {
//                                                            Spacer()
//                                                            
//                                                            Group{
//                                                                Text("End Time Is ")+Text("\(subjectgroupvm.endTime ?? "")")
//                                                            }     .font(Font.SoraBold(size: 9))
//                                                                .foregroundColor(ColorConstants.LightGreen800)
//                                                        }
//                                                    }
//                                                    .padding([.bottom,.trailing],5)
//                                                }
//                                            })
                                        
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
                                                CustomDatePickerField(iconName:"img_maskgroup7cl",placeholder: "Start Time", selectedDateStr:$subjectgroupvm.startTime,datePickerComponent:.hourAndMinute)
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
                                        CustomButton(Title: "Review Details" ,IsDisabled: .constant(false), action: {
                                            subjectgroupvm.ReviewTeacherGroup()
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
                            
                            List(subjectgroupvm.TeacherSubjectGroups ?? [] ,id:\.self){ group in
                                ManageSubjectGroupCell(model: group,
                                                       reviewBtnAction:{
                                    
                                }, deleteBtnAction: {
                                    subjectgroupvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                        subjectgroupvm.DeleteTeacherGroup(id: group.id)
                                    })
                                    subjectgroupvm.isError = true
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
                    lookupsvm.GetDays()
                    subjectgroupvm.GetTeacherSubjectGroups()
                })
            }
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            .onDisappear {
                subjectgroupvm.cleanup()
            }
                    .showHud(isShowing: $subjectgroupvm.isLoading)
            .showAlert(hasAlert: $subjectgroupvm.isError, alertType: subjectgroupvm.error)
            
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
                                                subjectgroupvm.GetTeacherSubjectGroups()
                                                showFilter = false
                                            })
                                            
                                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                subjectgroupvm.clearFilter()
                                                subjectgroupvm.GetTeacherSubjectGroups()
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
            }
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    ManageSubjectGroupView()
        .environmentObject(LookUpsVM())
        .environmentObject(ManageSubjectGroupVM())
    
}

