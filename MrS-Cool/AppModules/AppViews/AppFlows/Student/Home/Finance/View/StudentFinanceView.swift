//
//  StudentFinanceView.swift
//  MrS-Cool
//
//  Created by wecancity on 07/07/2024.
//

import SwiftUI

struct StudentFinanceView: View {
    @StateObject var financevm = StudentFinanceVM()
    @Binding var selectedChild : ChildrenM?
    var body: some View {
        VStack {
//            CustomTitleBarView(title: "Completed Lessons")
            
            if Helper.shared.getSelectedUserType() == .Parent && selectedChild == nil{
                VStack{
                    Text("You Have To Select Child First".localized())
                        .frame(minHeight:UIScreen.main.bounds.height)
                        .frame(width: UIScreen.main.bounds.width,alignment: .center)
                        .font(.title2)
                        .foregroundColor(ColorConstants.MainColor)
                }
            }else{
                VStack (alignment: .leading,spacing:0){
                    SignUpHeaderTitle(Title: "Finance", subTitle: "Enter subtitle here")
                        .frame(maxWidth:.infinity,alignment:.leading)
                        .foregroundStyle(Color.mainBlue)
                        .padding(.bottom)
                    
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
                            Group{
                                Text("\(financevm.Finance?.currentBalance ?? 0,specifier:"%.2f") ") + Text("LE".localized())
                            }
                            .font(Font.SoraBold(size: 48))
                            .foregroundColor(ColorConstants.MainColor)
                            
                            Group{
                                Text("Till ".localized())+Text("\(Date().formatDate(format: "dd MMM YYYY"))")
                            }
                            .font(Font.SoraRegular(size: 12))
                            .foregroundColor(.mainBlue)
                            .padding(.trailing,-20)
                            .padding(.bottom,5)
                        }
//                        Spacer()
                    }
                    .borderRadius(ColorConstants.Bluegray20099, width: 1, cornerRadius: 8, corners: [.allCorners])
                    
                    GeometryReader { gr in
                        ScrollView(.vertical,showsIndicators: false){
                            SignUpHeaderTitle(Title: "Purchased Lessons", subTitle: "Enter subtitle here")
                                .frame(maxWidth:.infinity,alignment:.leading)
                                .foregroundStyle(Color.mainBlue)
                                .padding(.vertical)
                            
                            if let lessons = financevm.PurchasedLessons?.items{
                                List(lessons, id:\.self) { lesson in
                                    PurchasedsubjectOrLessonCell(model: lesson)
                                        .listRowSpacing(0)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
                                            guard lesson == lessons.last else {return}
                                            
                                            if let totalCount = financevm.PurchasedLessons?.totalCount, lessons.count < totalCount {
                                                // Load the next page if there are more items to fetch
                                                financevm.lessonsSkipCount += financevm.maxResultCount
                                                financevm.GetPurchasedFor(financese: .Lessons)
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
                                    PurchasedsubjectOrLessonCell(model: Subject)
                                        .listRowSpacing(0)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .onAppear {
                                            guard Subject == Subjects.last else {return}
                                            
                                            if let totalCount = financevm.PurchasedSubjects?.totalCount, Subjects.count < totalCount {
                                                // Load the next page if there are more items to fetch
                                                financevm.subjectsSkipCount += financevm.maxResultCount
                                                financevm.GetPurchasedFor(financese: .Subjects)
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
                //            .background{
                //                ColorConstants.ParentDisableBg
                //                    .ignoresSafeArea()
                //            }
                
                Spacer()
            }
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        .onAppear(perform: {
            financevm.GetFinance()
            financevm.GetPurchasedFor(financese: .Lessons)
            financevm.GetPurchasedFor(financese: .Subjects)
        })
        .showHud(isShowing: $financevm.isLoading)
        .showAlert(hasAlert: $financevm.isError, alertType: financevm.error)
        
//        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview {
    StudentFinanceView(selectedChild: .constant(nil))
}


