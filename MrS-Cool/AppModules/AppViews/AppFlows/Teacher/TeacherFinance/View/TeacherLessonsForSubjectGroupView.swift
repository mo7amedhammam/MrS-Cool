//
//  TeacherLessonsForSubjectGroupView.swift
//  MrS-Cool
//
//  Created by wecancity on 02/01/2025.
//

import SwiftUI

struct TeacherLessonsForSubjectGroupView: View {
   @EnvironmentObject  var financevm : TeacherFinanceVM
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
            VStack (alignment: .leading,spacing:0){
                HStack {
                    SignUpHeaderTitle(Title: "Purchased Lessons")
                        .frame(maxWidth:.infinity,alignment:.leading)
                    .foregroundStyle(Color.mainBlue)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .padding(7)
                            .font(.system(size: 18))
                            .foregroundStyle(ColorConstants.WhiteA700)
                    }
                    .background{
                        Color.black.opacity(0.2)
                            .clipShape(.circle)
                    }

                }
//                    .padding(.bottom)

//                func PurchasedLessonsList() -> some View {
                    if let lessons = financevm.TeacherLessonsForSubjectGroup {
                        List(lessons, id:\.self) { lesson in
                            TeacherFinanceCellView(financese: .Lessons, model: lesson)
                                .padding(.vertical,0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                        .padding(.horizontal,-15)
                        .listStyle(.plain)
            //            .frame(minHeight: lessons.count*80 > 500 ? 400 : CGFloat(lessons.count)*80+30)
                        //                                .frame(minHeight: gr.size.height)
                    }
//                }
                    Spacer()
            }
            .padding()
            .showHud(isShowing: $financevm.isLoading)
            .showAlert(hasAlert: $financevm.isError, alertType: financevm.error)

        }
}

#Preview {
    TeacherLessonsForSubjectGroupView()
        .environmentObject(TeacherFinanceVM())
}

