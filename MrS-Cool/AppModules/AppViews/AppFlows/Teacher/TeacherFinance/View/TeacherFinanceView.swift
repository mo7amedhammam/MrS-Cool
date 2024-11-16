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
        formatter.timeZone = TimeZone.current
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
        financevm.GetPurchasedFor(financese: .Subjects)
    }
    func clearSubjectsFilterValues(){
        filtersubjectsdatefrom = nil
        filtersubjectsdateto = nil
        financevm.filtersubjectsdatefrom = nil
        financevm.filtersubjectsdateto = nil
        financevm.PurchasedSubjects?.items?.removeAll()
        financevm.subjectsSkipCount = 0
        financevm.GetPurchasedFor(financese: .Subjects)
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
        financevm.GetPurchasedFor(financese: .Lessons)
    }

    func clearLessonsFilterValues(){
        filterlessonsdatefrom = nil
        filterlessonsdateto = nil
        financevm.filterlessonsdatefrom = nil
        financevm.filterlessonsdateto = nil
        financevm.PurchasedLessons?.items?.removeAll()
        financevm.lessonsSkipCount = 0
        financevm.GetPurchasedFor(financese: .Lessons)
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
    
    var body: some View {
        VStack {
                VStack (alignment: .leading,spacing:0){
                    SignUpHeaderTitle(Title: "Finance")
                        .frame(maxWidth:.infinity,alignment:.leading)
                        .foregroundStyle(Color.mainBlue)
                        .padding(.bottom)
                    
                    Group{
                        HStack(spacing:10){
                        VStack(spacing:0){
                            HStack(spacing: 10){
                                Image("moneyicon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.mainBlue )
                                    .frame(width: 20,height: 20, alignment: .center)
                                Text("Current Balance".localized())
                                    .font(Font.regular(size: 12))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                            .padding([.top,.leading],10)
                            
                            VStack(alignment:.trailing,spacing:0){
                                HStack(spacing:0){
                                    Text("\(financevm.Finance?.totalDue ?? 0,specifier:"%.2f") ")
                                    Text("LE".localized())
                                }
                                .font(Font.bold(size: 24))
                                .foregroundColor(.mainBlue)
                            }
                        }
                        .padding(.bottom,10)
                        .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])

                            VStack(spacing:0){
                                HStack(spacing: 10){
                                    Image("moneyicon")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.mainBlue )
                                        .frame(width: 20,height: 20, alignment: .center)
                                    Text("You Earned".localized())
                                        .font(Font.regular(size: 12))
                                        .foregroundColor(ColorConstants.LightGreen800)
                                    Spacer()
                                }
                                .padding([.top,.leading],10)
                                
                                VStack(alignment:.trailing,spacing:0){
                                    HStack(spacing:0){
                                        Text("\(financevm.Finance?.totalIncome ?? 0,specifier:"%.2f") ")
                                        Text("LE".localized())
                                    }
                                    .font(Font.bold(size: 24))
                                    .foregroundColor(ColorConstants.LightGreen800)
                                }
                            }
                            .padding(.bottom,10)
                            .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])
                            
                            
//                        VStack(spacing:0){
//                            HStack(spacing: 10){
//                                Image("moneyicon")
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .foregroundColor(.mainBlue )
//                                    .frame(width: 20,height: 20, alignment: .center)
//                                Text("Next Payment".localized())
//                                    .font(Font.regular(size: 12))
//                                    .foregroundColor(.mainBlue)
//                                Spacer()
//                            }
//                            .padding([.top,.leading],10)
//                            
//                            VStack(alignment:.trailing,spacing:0){
//                                HStack(spacing:0){
//                                    Text("\(financevm.Finance?.nextCycleDue ?? 0,specifier:"%.2f") ")
//                                    Text("LE".localized())
//                                }
//                                .font(Font.bold(size: 24))
//                                .foregroundColor(ColorConstants.LightGreen800)
//                            }
//                        }
//                        .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])

                        }
                       }
                    .padding(.bottom,5)

                    
                    GeometryReader { gr in
                        ScrollView(.vertical,showsIndicators: false){
//                            SignUpHeaderTitle(Title: "Purchased Lessons", subTitle: "Enter subtitle here")
//                                .frame(maxWidth:.infinity,alignment:.leading)
//                                .foregroundStyle(Color.mainBlue)
//                                .padding(.vertical)
                            
                            HStack(){
                                SignUpHeaderTitle(Title: "Purchased Lessons")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
                                    .padding(.vertical)
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
                            }.padding(.top)
                            
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
                                                financevm.GetPurchasedFor(financese: .Lessons)
//                                                financevm.GetPurchasedLessons()
                                            }
                                        }
                                }
                                .padding(.horizontal,-15)
                                .listStyle(.plain)
                                .frame(minHeight: lessons.count*80 > 500 ? 400 : CGFloat(lessons.count)*80+30)
//                                .frame(minHeight: gr.size.height)
                            }
                            
//                            SignUpHeaderTitle(Title: "Purchased Subjects", subTitle: "Enter subtitle here")
//                                .frame(maxWidth:.infinity,alignment:.leading)
//                                .foregroundStyle(Color.mainBlue)
//                                .padding(.vertical)
                            
                            HStack(){
                                SignUpHeaderTitle(Title: "Purchased Subjects")
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                    .foregroundStyle(Color.mainBlue)
                                    .padding(.vertical)
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
                            
                            if let Subjects = financevm.PurchasedSubjects?.items{
                                List(Subjects, id:\.self) { Subject in
                                    TeacherFinanceCellView(financese: .Subjects,model: Subject)
                                        .padding(.vertical,0)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
                                            guard Subject == Subjects.last else {return}
                                            
                                            if let totalCount = financevm.PurchasedSubjects?.totalCount, Subjects.count < totalCount {
                                                // Load the next page if there are more items to fetch
                                                financevm.subjectsSkipCount += financevm.maxResultCount
                                                financevm.GetPurchasedFor(financese: .Subjects)
//                                                financevm.GetPurchasedSubjects()

                                            }
                                        }
                                }
                                .padding(.horizontal,-15)
                                .listStyle(.plain)
//                                .frame(minHeight: gr.size.height)
                                .frame(minHeight: Subjects.count*80 > 500 ? 400 : CGFloat(Subjects.count)*80+30)

                            }
                        }
                        .frame(minHeight: gr.size.height)
                        .padding(.top)
                    }
                    .padding(.top,-15)

                }
                .padding()
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
                    let DispatchGroup = DispatchGroup()
                    DispatchGroup.enter()
//                    financevm.subjectsSkipCount = 0
//                    financevm.lessonsSkipCount = 0
//                    financevm.PurchasedSubjects = nil
//                    financevm.PurchasedLessons = nil
                    DispatchGroup.leave()

                    DispatchGroup.enter()
                    financevm.GetFinance()
                    DispatchGroup.leave()

                    DispatchGroup.enter()
                    clearLessonsFilterValues()
//                    financevm.GetPurchasedFor(financese: .Lessons)
//                    financevm.GetPurchasedLessons()
                    DispatchGroup.leave()

                    DispatchGroup.enter()
                    clearSubjectsFilterValues()
//                    financevm.GetPurchasedFor(financese: .Subjects)
//                    financevm.GetPurchasedSubjects()
                    DispatchGroup.leave()

                    DispatchGroup.notify(queue: .main, execute: {
                        print("DispatchGroup ended")
                    })
                }
                .onDisappear(perform: {
                    financevm.cleanup()
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
    }
}

#Preview {
    TeacherFinanceView()
}


