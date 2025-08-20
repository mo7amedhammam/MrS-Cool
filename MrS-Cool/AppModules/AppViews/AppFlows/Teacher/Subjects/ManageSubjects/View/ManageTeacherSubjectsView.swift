//
//  ManageTeacherSubjectsView.swift
//  MrS-Cool
//
//  Created by wecancity on 14/11/2023.
//

import SwiftUI

struct ManageTeacherSubjectsView: View {
    //    @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var manageteachersubjectsvm = ManageTeacherSubjectsVM()
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
//    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var selectedSubject:TeacherSubjectM?
    
    @State var showConfirmDelete = false
    
    @State var filterEducationType : DropDownOption?
    @State var filterEducationLevel : DropDownOption?
    @State var filterAcademicYear : DropDownOption?
    @State var filterSubject : DropDownOption?
    @State var filterSubjectStatus : DropDownOption?
    
     func PassFilterValues(){
        manageteachersubjectsvm.filterEducationType = filterEducationType
        manageteachersubjectsvm.filterEducationLevel = filterEducationLevel
        manageteachersubjectsvm.filterAcademicYear = filterAcademicYear
        manageteachersubjectsvm.filterSubject = filterSubject
        manageteachersubjectsvm.filterSubjectStatus = filterSubjectStatus
    }
    
     func ClearFilterValues(){
        filterEducationType = nil
        lookupsvm.FilterSelectedEducationType = nil
        filterEducationLevel = nil
        filterAcademicYear = nil
        filterSubject = nil
        filterSubjectStatus = nil
         manageteachersubjectsvm.clearFilter()
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
                
                ScrollView{
                    VStack{
                        Group {
                            CustomDropDownField(iconName:"img_vector",placeholder: "Education Type", selectedOption: $filterEducationType,options:lookupsvm.EducationTypesList)
                                .onChange(of: filterEducationType){val in
                                    filterEducationLevel = nil
                                    lookupsvm.FilterSelectedEducationType = val
                                }
                            
                            CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level", selectedOption: $filterEducationLevel,options:lookupsvm.FilterEducationLevelsList)
                                .onChange(of:filterEducationLevel){val in
                                    filterAcademicYear = nil
                                    lookupsvm.FilterSelectedEducationLevel = val
                                }
                            
                            CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year", selectedOption: $filterAcademicYear,options:lookupsvm.FilterAcademicYearsList)
                                .onChange(of:filterAcademicYear){val in
                                    filterSubject = nil
                                    //                                            filterSubjectStatus = nil
                                    lookupsvm.FilterSelectedAcademicYear = val
                                    
                                }
                            CustomDropDownField(iconName:"img_group_512380",placeholder: "Subject", selectedOption: $filterSubject,options:lookupsvm.FilterSubjectsList)
                            CustomDropDownField(iconName:"img_group_512380",placeholder: "Subject Status", selectedOption: $filterSubjectStatus,options:lookupsvm.StatusList)
                        }
                        .padding(.top,5)
                        Spacer()
                        HStack {
                            Group{
                                CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                    PassFilterValues()
                                    manageteachersubjectsvm.GetTeacherSubjects()
                                    showFilter = false
                                })
                                
                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                    showFilter = false
                                    ClearFilterValues()
                                    manageteachersubjectsvm.clearFilter()
                                    manageteachersubjectsvm.GetTeacherSubjects()
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
    
    var body: some View{
        VStack {
            CustomTitleBarView(title: "Manage my Subjects")
            
            GeometryReader { gr in
                ScrollViewReader{ scrollViewProxy in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                VStack(alignment: .leading, spacing: 0){
                                    // -- Data Title --
                                    HStack(alignment: .top){
                                        SignUpHeaderTitle(Title:manageteachersubjectsvm.isEditing ? "Update Your Subject" : "Request New Subject")
                                        //                                Spacer()
                                        //                                Text("(2 / 3)")
                                        //                                    .font(.regular(size: 14))
                                        //                                    .foregroundColor(.black)
                                    }
                                    // -- inputs --
                                    Group {
                                        CustomDropDownField(iconName:"img_vector",placeholder: "Education Type *", selectedOption: $manageteachersubjectsvm.educationType,options:lookupsvm.EducationTypesList,Disabled:manageteachersubjectsvm.isEditing,isdimmed:manageteachersubjectsvm.isEditing,isvalid:manageteachersubjectsvm.iseducationTypevalid)
                                            .id(manageteachersubjectsvm.educationType)

                                        CustomDropDownField(iconName:"img_vector_black_900",placeholder: "Education Level *", selectedOption: $manageteachersubjectsvm.educationLevel,options:lookupsvm.EducationLevelsList,Disabled:manageteachersubjectsvm.isEditing,isdimmed:manageteachersubjectsvm.isEditing,isvalid:manageteachersubjectsvm.iseducationLevelvalid)
                                        
                                        CustomDropDownField(iconName:"img_group148",placeholder: "Academic Year *", selectedOption: $manageteachersubjectsvm.academicYear,options:lookupsvm.AcademicYearsList,Disabled:manageteachersubjectsvm.isEditing,isdimmed:manageteachersubjectsvm.isEditing,isvalid:manageteachersubjectsvm.isacademicYearvalid)
                                        //                                        .onChange(of: ){newval in
                                        //                                            lookupsvm.GetSubjectsByAcademicLevel(academicYearId: manageteachersubjectsvm.academicYear?.id ?? 0)
                                        //                                        }
                                        
                                        CustomDropDownField(iconName:"img_group_512380",placeholder: "Subject *", selectedOption: $manageteachersubjectsvm.subject,options:lookupsvm.SubjectsList,Disabled:manageteachersubjectsvm.isEditing,isdimmed:manageteachersubjectsvm.isEditing,isvalid:manageteachersubjectsvm.issubjectvalid)
                                        
                                        ZStack(alignment:.bottomTrailing){
                                            CustomTextField(iconName:"img_group_black_900",placeholder: "Session Price *", text: $manageteachersubjectsvm.groupCost,keyboardType:.decimalPad,isvalid:manageteachersubjectsvm.isgroupCostvalid)
                                                .onChange(of: manageteachersubjectsvm.groupCost) { newValue in
                                                    manageteachersubjectsvm.groupCost = newValue.filter { $0.isEnglish }
                                                }
                                                .id(1)
                                            if let cost = manageteachersubjectsvm.subject?.subject{
//                                                print(cost)
                                                HStack(spacing:5){
                                                    Text("Recommended".localized())
                                                    Text(String(cost.groupCostFrom ?? 0))
                                                    Text("To".localized())
                                                    Text(String(cost.groupCostTo ?? 0))
                                                    Text(cost.currency ?? "EGP".localized())
                                                }
                                                .font(Font.semiBold(size: 9))
                                                .foregroundColor(ColorConstants.Bluegray402)
                                                .padding(5)
                                            }
                                        }
                                        
//                                        CustomTextField(iconName:"img_group58",placeholder: "Minimum Number Of Group Students", text: $manageteachersubjectsvm.minGroup ,keyboardType:.asciiCapableNumberPad,isvalid:manageteachersubjectsvm.isminGroupvalid)
                                        
//                                        CustomTextField(iconName:"img_group58",placeholder: "Maximum Number Of Group Students", text: $manageteachersubjectsvm.maxGroup,keyboardType:.asciiCapableNumberPad,isvalid:manageteachersubjectsvm.ismaxGroupvalid)
                                        
//                                        ZStack(alignment:.bottomTrailing){
//                                            CustomTextField(iconName:"img_group_black_900",placeholder: "Individual Price", text: $manageteachersubjectsvm.individualCost,keyboardType:.decimalPad,isvalid:manageteachersubjectsvm.isindividualCostvalid)
//                                                .onChange(of: manageteachersubjectsvm.individualCost) { newValue in
//                                                    manageteachersubjectsvm.individualCost = newValue.filter { $0.isEnglish }
//                                                }
//                                            if let cost = manageteachersubjectsvm.subject?.subject{
//                                                HStack(spacing:5){
//                                                    Text("Recommended".localized())
//                                                    Text(String(cost.individualCostFrom ?? 0))
//                                                    Text("To".localized())
//                                                    Text(String(cost.individualCostTo ?? 0))
//                                                    Text("EGP".localized())
//                                                }
//                                                .font(Font.regular(size: 9))
//                                                .foregroundColor(ColorConstants.Bluegray402)
//                                                .padding(5)
//                                            }
//                                        }
                                        
                                        CustomTextEditor(iconName:"img_group512375",placeholder: "Teacher Brief English", text: $manageteachersubjectsvm.subjectBriefEn,charLimit: 1000)
                                            .onChange(of: manageteachersubjectsvm.subjectBriefEn) { newValue in
                                                manageteachersubjectsvm.subjectBriefEn = newValue.filter { $0.isEnglish }
                                            }
                                        
                                        CustomTextEditor(iconName:"img_group512375",placeholder: "Teacher Brief Arabic", text: $manageteachersubjectsvm.subjectBrief,charLimit: 1000).reversLocalizeView()
                                            .onChange(of: manageteachersubjectsvm.subjectBrief) { newValue in
                                                manageteachersubjectsvm.subjectBrief = newValue.filter { $0.isArabic }
                                            }
                                        
                                    }
                                    .padding([.top])
                                }.padding(.top,20)
                                
                                HStack {
                                    Group{
                                        CustomButton(Title:manageteachersubjectsvm.isEditing ? "Update" : "Save" ,IsDisabled: .constant(false), action: {
                                            ClearFilterValues()
                                            
                                            if manageteachersubjectsvm.isEditing{
                                                manageteachersubjectsvm.UpdateTeacherSubject()
                                            }else{
                                                manageteachersubjectsvm.CreateTeacherSubject()
                                            }
                                        })
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            manageteachersubjectsvm.clearTeachersSubject()
                                            manageteachersubjectsvm.isEditing = false
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
                                        .font(Font.regular(size: 10))
                                    
                                    Rectangle().frame(width: 14, height: 14)
                                        .foregroundColor(.green)
                                    Text("Approved".localized())
                                        .foregroundColor(.mainBlue)
                                        .font(Font.regular(size: 10))
                                    
                                    Rectangle().frame(width: 14, height: 14)
                                        .foregroundColor(.red)
                                    Text("Rejected".localized())
                                        .foregroundColor(.mainBlue)
                                        .font(Font.regular(size: 10))
                                }
                            }
                            .padding(.horizontal)
                            
                            List(manageteachersubjectsvm.TeacherSubjects ?? [] ,id:\.self){ subject in
                                ManageSubjectCell(model: subject, editSubjectBtnAction:{
                                    manageteachersubjectsvm.isEditing = true
                                    manageteachersubjectsvm.selectSubjectForEdit(item: subject)
                                    scrollViewProxy.scrollTo(1)
                                },editLessonsBtnAction: {
                                    if subject.groupSessionCost == 0
//                                        || subject.individualCost == 0
                                    {
                                        manageteachersubjectsvm.error = .error( message: "You Must Enter YOUR  Subject Price First To Can Access To This Page".localized, buttonTitle: "Ok", mainBtnAction: {
                                        })
                                        manageteachersubjectsvm.isError.toggle()
                                    }else{
                                        destination = AnyView(ManageTeacherSubjectLessonsView(currentSubject:subject)
                                            .environmentObject(LookUpsVM())
                                            .environmentObject(ManageTeacherSubjectLessonsVM())
                                        )
                                        isPush = true
                                        manageteachersubjectsvm.clearTeachersSubject()
                                        manageteachersubjectsvm.isEditing = false
                                    }
                                }, deleteBtnAction:{
//                                    manageteachersubjectsvm.isEditing = false
//                                    manageteachersubjectsvm.clearTeachersSubject()
                                    manageteachersubjectsvm.error = .question( image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                        manageteachersubjectsvm.DeleteTeacherSubject(id: subject.id)
                                    })
                                    showConfirmDelete.toggle()
                                })
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.vertical,-8)
                            }
                            //                    .scrollContentBackground(.hidden)
                            .listStyle(.plain)
                            .frame(height: gr.size.height/2)
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
                }
            }
            .onAppear(perform: {
                manageteachersubjectsvm.GetTeacherSubjects()
                //                                signupvm.isUserChangagble = false
                lookupsvm.GetEducationTypes(withAppCountryId: false)
                lookupsvm.GetStatus()
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
//            .onChange(of: manageteachersubjectsvm.subject, perform: { value in
//                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
//                    print("lookupsvm.SubjectsList",lookupsvm.SubjectsList)
//                    if let subject = value,
//                       let matchingSubject = lookupsvm.SubjectsList.first(where: { $0.id == subject.id }) {
//                        // Perform your action with matchingSubject
//                        print("Matching subject: \(matchingSubject)")
//                        manageteachersubjectsvm.subject = matchingSubject
//                    }
//                })
//            })
//            .onChange(of: manageteachersubjectsvm.subject){ newValue in
//                if let subject = newValue {
//                    // Check if lookupsvm.SubjectsList contains the subject with the same ID
//                    if let matchingSubject = lookupsvm.SubjectsList.first(where: { $0.id == subject.id }) {
//                        // Perform your action with matchingSubject
//                        print("Matching subject: \(matchingSubject)")
//                        manageteachersubjectsvm.subject = matchingSubject
//                    }
//                }
//            }
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
        .showAlert(hasAlert: $showConfirmDelete, alertType: manageteachersubjectsvm.error)

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
        NavigationLink(destination: destination, isActive: $isPush, label: {})
        
    }
}

#Preview {
    ManageTeacherSubjectsView()
    //        .environmentObject(LookUpsVM())
    //        .environmentObject(ManageTeacherSubjectsVM())
}


