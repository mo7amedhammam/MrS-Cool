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
    var body: some View {
        VStack {
                VStack (alignment: .leading,spacing:0){
                    SignUpHeaderTitle(Title: "Finance", subTitle: "Enter subtitle here")
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
                                    .font(Font.SoraRegular(size: 12))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                            .padding([.top,.leading],10)
                            
                            VStack(alignment:.trailing,spacing:0){
                                HStack(spacing:0){
                                    Text("\(financevm.Finance?.totalDue ?? 0,specifier:"%.2f") ")
                                    Text("LE".localized())
                                }
                                .font(Font.SoraBold(size: 24))
                                .foregroundColor(ColorConstants.MainColor)
                            }
                        }
                        .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])
                        
                        VStack(spacing:0){
                            HStack(spacing: 10){
                                Image("moneyicon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.mainBlue )
                                    .frame(width: 20,height: 20, alignment: .center)
                                Text("Next Payment".localized())
                                    .font(Font.SoraRegular(size: 12))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                            .padding([.top,.leading],10)
                            
                            VStack(alignment:.trailing,spacing:0){
                                HStack(spacing:0){
                                    Text("\(financevm.Finance?.nextCycleDue ?? 0,specifier:"%.2f") ")
                                    Text("LE".localized())
                                }
                                .font(Font.SoraBold(size: 24))
                                .foregroundColor(ColorConstants.LightGreen800)
                            }
                        }
                        .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])

                        }
                        
                        VStack(spacing:0){
                            HStack(spacing: 10){
                                Image("moneyicon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.mainBlue )
                                    .frame(width: 20,height: 20, alignment: .center)
                                Text("You Earned".localized())
                                    .font(Font.SoraRegular(size: 12))
                                    .foregroundColor(.mainBlue)
                                Spacer()
                            }
                            .padding([.top,.leading],10)
                            
                            VStack(alignment:.trailing,spacing:0){
                                HStack(spacing:0){
                                    Text("\(financevm.Finance?.totalIncome ?? 0,specifier:"%.2f") ")
                                    Text("LE".localized())
                                }
                                .font(Font.SoraBold(size: 48))
                                .foregroundColor(ColorConstants.MainColor)
                            }
                        }
                        .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])
                    }
                    .padding(.bottom,5)

                    
                    GeometryReader { gr in
                        ScrollView(.vertical,showsIndicators: false){
                            SignUpHeaderTitle(Title: "Purchased Lessons", subTitle: "Enter subtitle here")
                                .frame(maxWidth:.infinity,alignment:.leading)
                                .foregroundStyle(Color.mainBlue)
                                .padding(.vertical)
                            
                            if let lessons = financevm.PurchasedLessons?.items{
                                List(lessons, id:\.self) { lesson in
                                    Text(lesson.profit ?? 0,format:.number)
//                                    PurchasedsubjectOrLessonCell(financese: .Lessons, model: lesson)
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
                                .frame(minHeight: gr.size.height)
                            }
                            
                            SignUpHeaderTitle(Title: "Purchased Subjects", subTitle: "Enter subtitle here")
                                .frame(maxWidth:.infinity,alignment:.leading)
                                .foregroundStyle(Color.mainBlue)
                                .padding(.vertical)
                            
                            if let Subjects = financevm.PurchasedSubjects?.items{
                                List(Subjects, id:\.self) { Subject in
//                                    PurchasedsubjectOrLessonCell(financese: .Subjects,model: Subject)
                                    Text(Subject.profit ?? 0,format:.number)
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
                                .frame(minHeight: gr.size.height)
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
                    financevm.subjectsSkipCount=0
                    financevm.lessonsSkipCount=0
                    financevm.PurchasedSubjects = nil
                    financevm.PurchasedLessons = nil
                    DispatchGroup.leave()

                    DispatchGroup.enter()
                    financevm.GetFinance()
                    DispatchGroup.leave()

                    DispatchGroup.enter()
                    financevm.GetPurchasedFor(financese: .Lessons)
//                    financevm.GetPurchasedLessons()
                    DispatchGroup.leave()

                    DispatchGroup.enter()
                    financevm.GetPurchasedFor(financese: .Subjects)
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
        
    }
}

#Preview {
    TeacherFinanceView()
}


