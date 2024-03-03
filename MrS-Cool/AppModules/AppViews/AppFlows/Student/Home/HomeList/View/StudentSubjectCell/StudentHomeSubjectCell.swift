//
//  StudentHomeSubjectCell.swift
//  MrS-Cool
//
//  Created by wecancity on 09/01/2024.
//

import SwiftUI

struct StudentHomeSubjectCell: View {
    var subject:StudentSubjectsM = StudentSubjectsM.init()
    @Binding var selectedSubject:StudentSubjectsM
    var action:(()->())?

    var body: some View {
        Button(action: {
            selectedSubject = subject
            action?()
        }, label: {
            VStack (spacing:0){
//                AsyncImage(url: URL(string: Constants.baseURL+(subject.image ?? "")  )){image in
//                    image
//                        .resizable()
//                }placeholder: {
//                    Image("img_younghappysmi")
//                        .resizable()
//                }
                let imageURL : URL? = URL(string: Constants.baseURL+(subject.image ?? ""))
                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                .aspectRatio(contentMode: .fill)
                .frame(width: 70,height: 70)
                .clipShape(Circle())
                .padding(.top, 10)

                Text(subject.name ?? "ArabicArabic ArabicArabicArabic ArabicArabicArabic ArabicArabicArabic ArabicArabicArabic ArabicArabicArabic ArabicArabicArabic Arabic")
                    .font(Font.SoraSemiBold(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(subject.id == selectedSubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                    .multilineTextAlignment(.center)
                    .frame(height:70)
            }
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .fill(subject.id == selectedSubject.id ? .mainBlue :ColorConstants.Bluegray100.opacity(0.5)))
        })
    }
}

#Preview {
    StudentHomeSubjectCell(selectedSubject: .constant(StudentSubjectsM.init()))
}
