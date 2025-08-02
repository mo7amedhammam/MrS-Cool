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
    var isPriceCustomizable:Bool? = false

    //    @State var isPush = false
    //    @State var destination = EmptyView()
    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var previewOption:PreviewOptions? = .newGroup
    
    @State var showConfirmSave : Bool = false
    
    //    @State var isPush = false
    //    @State var destination = AnyView(EmptyView())
    let columns: [GridItem] =
    Array(repeating: .init(.flexible(),spacing: 25,alignment: .topLeading), count: 2)

    @State var TotalPrice : String = ""{
        didSet{
            guard TotalPrice.count > 0, let price = Float(TotalPrice) else {
                isTotalPricevalid = false
                return}
            if price > 0{
                isTotalPricevalid = true
            }else{
                isTotalPricevalid = false
            }
        }
    }
    @State var isTotalPricevalid:Bool?
    
//    private func isPriceValid() -> Bool {
//        
//        // Ensure the groupCost is safely unwrapped and cast to Int if it's a valid Double/Float
//        if let groupCost = subjectgroupvm.TeacherSubjectGroupsDetails?.groupCost,groupCost.description.count > 0, groupCost > 0 {
//            return true
//        }
//        return false
//    }
    
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
                                
                                LazyVGrid(columns: columns,alignment: .center,spacing: 25){
                                    VStack(alignment:.leading,spacing:5){
                                        Text("Subject".localized())
                                            .font(Font.bold(size: 16))
                                        //
                                        Text(subjectgroupvm.TeacherSubjectGroupsDetails?.teacherSubjectAcademicSemesterYearName ?? "subhect name name")
                                            .font(Font.regular(size: 14))
                                            .lineSpacing(5)
                                    }
                                    
                                    VStack(alignment:.leading,spacing:5){
                                        Text("Group Name".localized())
                                            .font(Font.bold(size: 16))
                                        
                                        Text(subjectgroupvm.TeacherSubjectGroupsDetails?.groupName ?? "group 1")
                                            .font(Font.regular(size: 14))
                                            .fontWeight(.medium)
                                    }
                                    
                                    VStack(alignment:.leading,spacing:5){
                                        Text("Start Date".localized())
                                            .font(Font.bold(size: 16))
                                        
                                        Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.startDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                                            .font(Font.regular(size: 14))
                                            .fontWeight(.medium)
                                    }
                                    
                                    VStack(alignment:.leading,spacing:5){
                                        Text("End Date".localized())
                                            .font(Font.bold(size: 16))
                                        
                                        Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.endDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy"))
                                            .font(Font.regular(size: 14))
                                            .fontWeight(.medium)
                                    }
                                    
                                    VStack(alignment:.leading,spacing:5){
                                        Text("Num Of Lessons".localized())
                                            .font(Font.bold(size: 16))
                                        Group{
                                            Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.numLessons ?? 0) ").fontWeight(.medium)+Text("Lesson".localized()).fontWeight(.medium)
                                            
                                        }
                                        .font(Font.regular(size: 14))
                                    }
                                    
                                    VStack(alignment:.leading,spacing:5){
                                        Text("Total Cost".localized())
                                            .font(Font.bold(size: 16))
                                        
                                        
                                        if isPriceCustomizable == true{
                                            CustomTextField(
                                                iconName: "img_group_black_900",
                                                placeholder: "",
                                                text:$TotalPrice,
                                                keyboardType: .decimalPad,
                                                isvalid: isTotalPricevalid
                                            )
                                            .task{
                                                TotalPrice = String(format: "%.2f",subjectgroupvm.TeacherSubjectGroupsDetails?.groupCost ?? 0)
                                            }
                                            .onChange(of: TotalPrice) { newValue in
                                                TotalPrice = newValue.filter { $0.isEnglish }
                                                subjectgroupvm.TeacherSubjectGroupsDetails?.groupCost = Float(TotalPrice)
                                            }
                                        }else{
                                            Text("\(subjectgroupvm.TeacherSubjectGroupsDetails?.groupCost ?? 0,specifier:"%.2f") ").fontWeight(.medium)+Text(appCurrency ?? "EGP".localized()).fontWeight(.medium)
                                        }
                                    }
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
                        
                        let scheduleSlots = subjectgroupvm.TeacherSubjectGroupsDetails?.scheduleSlots ?? []
                        let enumeratedSlots = Array(scheduleSlots.enumerated())
                        List(enumeratedSlots, id: \.element) { index, group in
                            SubjectGroupDetailsCell(number: index+1, model: group)
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.vertical,-4)
                        }
                        .padding(.horizontal,-4)
                        .listStyle(.plain)
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
                            guard isTotalPricevalid == true else {return}
                            // Use a localized format string for the title
                            let isArabic = LocalizeHelper.shared.currentLanguage == "ar"
                            let title = isArabic ? "تكلفة المجموعه للطالب \(subjectgroupvm.TeacherSubjectGroupsDetails?.groupCost ?? 0) جنيه" : "Cost for student is \(subjectgroupvm.TeacherSubjectGroupsDetails?.groupCost ?? 0) EGP" 

                            subjectgroupvm.error = .question(title: title, image: "savegroupIcon", message: "Are you sure you want to Save ?", buttonTitle: "Save", secondButtonTitle: "Clear", mainBtnAction: {
                                subjectgroupvm.CreateTeacherGroup()
                            })
                            showConfirmSave = true
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
        .showAlert(hasAlert: $showConfirmSave, alertType: subjectgroupvm.error)
        
        //        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    SubjectGroupDetailsView()
        .environmentObject(LookUpsVM())
        .environmentObject(ManageSubjectGroupVM())
}
