//
//  TeacherFinanceView.swift
//  MrS-Cool
//
//  Created by wecancity on 12/09/2024.
//
import SwiftUI

struct TeacherFinanceView: View {
    @StateObject var financevm = TeacherFinanceVM()
//    @Binding var selectedChild : ChildrenM?
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter.cachedFormatter
        formatter.dateFormat = "dd MMM yyyy"
//        formatter.timeZone = TimeZone.current
        formatter.timeZone = TimeZone(identifier: "Africa/Cairo") ?? TimeZone.current
//        formatter.locale = Local(identifier: "en")
        return formatter
     }()
    
    
    @State var showSubjectsFilter : Bool = false
    @State var showLessonsFilter : Bool = false

    @State var filtersubjectsdatefrom : String?
    @State var filtersubjectsdateto : String?

    @State var filterlessonsdatefrom : String?
    @State var filterlessonsdateto : String?

    func sendSubjectsFilterValues(){
        financevm.filtersubjectsdatefrom = filtersubjectsdatefrom
        financevm.filtersubjectsdateto = filtersubjectsdateto
        financevm.subjectsSkipCount = 0
        Task{
            await financevm.GetPurchasedFor(financese: .Subjects)
        }
    }
    func clearSubjectsFilterValues(){
        filtersubjectsdatefrom = nil
        filtersubjectsdateto = nil
        financevm.filtersubjectsdatefrom = nil
        financevm.filtersubjectsdateto = nil
        financevm.PurchasedSubjects?.items?.removeAll()
        financevm.subjectsSkipCount = 0
        Task{
            await financevm.GetPurchasedFor(financese: .Subjects)
        }
        //        financevm.clearFilter()

    }
//    func validateSubjectsFilterValues(){
//       if groupsforlessonvm.filtersubject != filtersubject {
//           filtersubject = nil
//           lookupsvm.FilterLessonsForList.removeAll()
//        }
//        if groupsforlessonvm.filterlesson != filterlesson{
//            filterlesson = nil
//        }
//        if groupsforlessonvm.filtergroupName != filtergroupName{
//            filtergroupName = ""
//        }
//        if groupsforlessonvm.filterdate != filterdate{
//            filterdate = nil
//        }
//    }

    func sendLessonsFilterValues(){
        financevm.filterlessonsdatefrom = filterlessonsdatefrom
        financevm.filterlessonsdateto = filterlessonsdateto
        financevm.lessonsSkipCount = 0
        Task{
            await financevm.GetPurchasedFor(financese: .Lessons)
        }
    }

    func clearLessonsFilterValues(){
        filterlessonsdatefrom = nil
        filterlessonsdateto = nil
        financevm.filterlessonsdatefrom = nil
        financevm.filterlessonsdateto = nil
        financevm.PurchasedLessons?.items?.removeAll()
        financevm.lessonsSkipCount = 0
        Task{
            await financevm.GetPurchasedFor(financese: .Lessons)
        }
    }
//    func validateLessonsFilterValues(){
//       if groupsforlessonvm.filtersubject != filtersubject {
//           filtersubject = nil
//           lookupsvm.FilterLessonsForList.removeAll()
//        }
//        if groupsforlessonvm.filterlesson != filterlesson{
//            filterlesson = nil
//        }
//        if groupsforlessonvm.filtergroupName != filtergroupName{
//            filtergroupName = ""
//        }
//        if groupsforlessonvm.filterdate != filterdate{
//            filterdate = nil
//        }
//    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var showSubjectLessonsSheet = false
    
    @ViewBuilder
    fileprivate func PurchasedLessonsList() -> some View {
        if let lessons = financevm.PurchasedLessons?.items{
            List(lessons, id:\.self) { lesson in
                TeacherFinanceCellView(financese: .Lessons, model: lesson)
                    .padding(.vertical,0)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear {
                        guard lesson == lessons.last else {return}
                        
                        if let totalCount = financevm.PurchasedLessons?.totalCount, lessons.count < totalCount {
                            // Load the next page if there are more items to fetch
                            financevm.lessonsSkipCount += financevm.maxResultCount
                            Task{
                                await financevm.GetPurchasedFor(financese: .Lessons)
                                //                                                financevm.GetPurchasedLessons()
                            }
                        }
                    }
            }
            .padding(.horizontal,-15)
            .listStyle(.plain)
            .frame(minHeight: lessons.count*80 > 500 ? 400 : CGFloat(lessons.count) * 80 + (lessons.count > 0 ? 30:0))
            //                                .frame(minHeight: gr.size.height)
        }
    }
    
    @ViewBuilder
    fileprivate func PurchasedSubjects() -> some View {
        if let Subjects = financevm.PurchasedSubjects?.items{
            List(Subjects, id:\.self) { Subject in
                TeacherFinanceCellView(financese: .Subjects,model: Subject,reviewBtnAction: {
                    guard let teacherLessonSessionId = Subject.teacherLessonSessionId else {return}
                    showSubjectLessonsSheet = true
                    financevm.GetTeacherLessonsForSubjectGroup(TeacherLessonSessionId: teacherLessonSessionId)
                })
                    .padding(.vertical,0)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onAppear {
                        guard Subject == Subjects.last else {return}
                        
                        if let totalCount = financevm.PurchasedSubjects?.totalCount, Subjects.count < totalCount {
                            // Load the next page if there are more items to fetch
                            financevm.subjectsSkipCount += financevm.maxResultCount
                            Task{
                                await financevm.GetPurchasedFor(financese: .Subjects)
                                //                                                financevm.GetPurchasedSubjects()
                            }
                        }
                    }
                    
            }
            .padding(.horizontal,-15)
            .listStyle(.plain)
            //                                .frame(minHeight: gr.size.height)
            .frame(minHeight: Subjects.count*80 > 500 ? 400 : CGFloat(Subjects.count) * 80 + (Subjects.count > 0 ? 30:0))
        }
    }
    
    var body: some View {
        VStack {
//                VStack (alignment: .leading,spacing:0){

//                    GeometryReader { gr in
//                        ScrollView(.vertical,showsIndicators: false){
                        List{
                            
                            Section(header:
                                        SignUpHeaderTitle(Title: "Finance")
                                .frame(maxWidth:.infinity,alignment:.leading)
                                .foregroundStyle(Color.mainBlue)
//                                .padding(.bottom)
                            ){
                                Group{
                                    //                        VStack(spacing:10){
                                    LazyVGrid(columns: columns, spacing: 8) {
                                        
                                        MoneyEarnedCell(Title: "Total Purchases", Value: financevm.Finance?.totalPurchases)
                                        
                                        MoneyEarnedCell(Title: "Current Balance", Value: financevm.Finance?.totalDue)
                                        
                                        MoneyEarnedCell(Title: "You Earned", Titlecolor: ColorConstants.LightGreen800, Value: financevm.Finance?.totalIncome, Valuecolor: ColorConstants.LightGreen800)
                                        
                                        MoneyEarnedCell(Title: "Remaining", Value: financevm.Finance?.remaining)
                                        
                                        MoneyEarnedCell(Title: "Teacher Not Attend", Titlecolor: ColorConstants.Red400, Value: financevm.Finance?.totalTeacherNotattend, Valuecolor: ColorConstants.Red400)
                                        
                                        MoneyEarnedCell(Title: "Student Not Attend", Titlecolor: ColorConstants.Red400, Value: financevm.Finance?.totalStudentNotattend, Valuecolor: ColorConstants.Red400)
                                        
                                        MoneyEarnedCell(Title: "Total Canceled", Titlecolor: ColorConstants.Red400, Value: financevm.Finance?.totalCanceled, Valuecolor: ColorConstants.Red400)
                                    }
                                }
                                .padding(.bottom,5)
                            }
                            
                            Section(header:
                                        
                                        HStack(){
                                SignUpHeaderTitle(Title: "Purchased Lessons")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
//                                    .padding(.vertical)
                                Spacer()
                                Image("img_maskgroup62_clipped")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(ColorConstants.MainColor)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .onTapGesture(perform: {
                                        showLessonsFilter = true
                                        //                                        validateFilterValues()
                                    })
                            }
//                                .padding(.top)
                            ){
                                PurchasedLessonsList()
                            }
                            
                            Section(header:
                                        HStack(){
                                SignUpHeaderTitle(Title: "Purchased Subjects")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
//                                    .padding(.vertical)
                                Spacer()
                                Image("img_maskgroup62_clipped")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(ColorConstants.MainColor)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .onTapGesture(perform: {
                                        showSubjectsFilter = true
                                        //                                        validateFilterValues()
                                    })
                            }
                            ){
                                
                                PurchasedSubjects()
                            }
                        }
//                        .frame(minHeight: gr.size.height)
//                        .padding(.top)
                        .listStyle(.plain)
//                        .padding(.horizontal,-15)
//                    }
//                    .padding(.top,-15)

//                }
//                .padding()
//                .onAppear(perform: {
//                    guard selectedChild != nil || Helper.shared.getSelectedUserType() == .Student else{return}
//                    let DispatchGroup = DispatchGroup()
//                    DispatchGroup.enter()
//                    financevm.subjectsSkipCount=0
//                    financevm.lessonsSkipCount=0
//                    financevm.PurchasedSubjects = nil
//                    financevm.PurchasedLessons = nil
//                    DispatchGroup.leave()
//
//                    DispatchGroup.enter()
//                    financevm.GetFinance()
//                    DispatchGroup.leave()
//
//                    DispatchGroup.enter()
//                    financevm.GetPurchasedFor(financese: .Lessons)
//                    DispatchGroup.leave()
//
//                    DispatchGroup.enter()
//                    financevm.GetPurchasedFor(financese: .Subjects)
//                    DispatchGroup.leave()
//
//                    DispatchGroup.notify(queue: .main, execute: {
//                        print("DispatchGroup ended")
//                    })
//                })

                .task {
                    async let finance : () = financevm.GetFinance()
                    async let lessons : () = clearLessonsFilterValues()
                    async let subjects : () = clearSubjectsFilterValues()
                    await _ = (finance,lessons,subjects)
                    
//                    let DispatchGroup = DispatchGroup()
//                    DispatchGroup.enter()
////                    financevm.subjectsSkipCount = 0
////                    financevm.lessonsSkipCount = 0
////                    financevm.PurchasedSubjects = nil
////                    financevm.PurchasedLessons = nil
//                    DispatchGroup.leave()
//
//                    DispatchGroup.enter()
//                    financevm.GetFinance()
//                    DispatchGroup.leave()
//
//                    DispatchGroup.enter()
//                    clearLessonsFilterValues()
////                    financevm.GetPurchasedFor(financese: .Lessons)
////                    financevm.GetPurchasedLessons()
//                    DispatchGroup.leave()
//
//                    DispatchGroup.enter()
//                    clearSubjectsFilterValues()
////                    financevm.GetPurchasedFor(financese: .Subjects)
////                    financevm.GetPurchasedSubjects()
//                    DispatchGroup.leave()
//
//                    DispatchGroup.notify(queue: .main, execute: {
//                        print("DispatchGroup ended")
//                    })
                }
                .onDisappear(perform: {
                    financevm.cleanup()
                    showLessonsFilter = false
                    showSubjectsFilter = false
                })
                Spacer()
//            }
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .showHud(isShowing: $financevm.isLoading)
        .showAlert(hasAlert: $financevm.isError, alertType: financevm.error)
        .overlay{
            if showLessonsFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showLessonsFilter.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showLessonsFilter){
                    
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
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date From", selectedDateStr:$filterlessonsdatefrom,datePickerComponent:.date)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date To", selectedDateStr:$filterlessonsdateto,datePickerComponent:.date)

                                }
                                .padding(.top,5)
                                
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            sendLessonsFilterValues()
                                            showLessonsFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            clearLessonsFilterValues()
                                            showLessonsFilter = false
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
                    .frame(height:315)
                    .keyboardAdaptive()
                }
            }else if showSubjectsFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showSubjectsFilter.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showSubjectsFilter){
                    
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

                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date From", selectedDateStr:$filtersubjectsdatefrom,datePickerComponent:.date)
                                    
                                    CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Date To", selectedDateStr:$filtersubjectsdateto,datePickerComponent:.date)

                                }
                                .padding(.top,5)
                                
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            sendSubjectsFilterValues()
                                            showSubjectsFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            clearSubjectsFilterValues()
                                            showSubjectsFilter = false
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
                    .frame(height:315)
                    .keyboardAdaptive()
                }
            }
        }
        .sheet(isPresented: $showSubjectLessonsSheet, onDismiss: {
//            financevm.GetPurchasedFor(financese: .Lessons)
        }, content: {
            TeacherLessonsForSubjectGroupView()
                .environmentObject(financevm)
        })
    }
}

#Preview {
    TeacherFinanceView()
}

struct MoneyEarnedCell : View {
    var Title:String?
    var Titlecolor:Color?
    var TitleFont:Font?
    var Value:Double?
    var Valuecolor:Color?
    var ValueFont:Font?

    var body: some View {
        VStack(spacing:0){
            HStack(spacing: 10){
                Image("moneyicon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.mainBlue )
                    .frame(width: 20,height: 20, alignment: .center)
                Text(Title?.localized() ?? "")
                    .font(TitleFont ?? Font.regular(size: 12))
                    .foregroundColor(Titlecolor ?? .mainBlue)
                Spacer()
            }
            .padding([.top,.leading],10)
            
            VStack(alignment:.trailing,spacing:0){
                HStack(spacing:0){
                    Text("\(Value ?? 0,specifier:"%.2f") ")
                    Text(appCurrency ?? "LE".localized())
                }
                .font(ValueFont ?? Font.bold(size: 24))
                .foregroundColor(Valuecolor ?? .mainBlue)
            }
        }
        .padding(.bottom,10)
        .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])
    }
}
