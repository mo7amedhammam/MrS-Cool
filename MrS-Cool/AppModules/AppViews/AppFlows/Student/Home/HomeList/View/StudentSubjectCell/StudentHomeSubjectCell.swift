//
//  StudentHomeSubjectCell.swift
//  MrS-Cool
//
//  Created by wecancity on 09/01/2024.
//

import SwiftUI
struct teacherTitle:Codable,Hashable {
    var subjectAcademicYear,subjectLevel: String?
    enum CodingKeys: String, CodingKey {
        case  subjectAcademicYear, subjectLevel
    }
//    init(subjectAcademicYear: String? = nil, subjectLevel: String? = nil) {
//        self.subjectAcademicYear = subjectAcademicYear
//        self.subjectLevel = subjectLevel
//    }
}

struct StudentHomeSubjectCell: View {
    var subject:HomeSubject = HomeSubject.init()
    @Binding var selectedSubject:HomeSubject
    var action:(()->Void)?
//    var teacherInfoTitle: teacherTitle?
    var body: some View {
        Button(action: {
//            selectedSubject = subject
            action?()
        }, label: {
            VStack (spacing:4){
//                AsyncImage(url: URL(string: Constants.baseURL+(subject.image ?? "")  )){image in
//                    image
//                        .resizable()
//                }placeholder: {
//                    Image("img_younghappysmi")
//                        .resizable()
//                }
                let imageURL : URL? = URL(string: Constants.baseURL+(subject.image ?? "").reverseSlaches())
                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                .aspectRatio(contentMode: .fill)
                .frame(width: 70,height: 70)
                .clipShape(Circle())
                .padding(.vertical, 10)
                
                let subjectName = subject.name ?? ""
                let name = subjectName.split(separator: ",").map{ String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                let Part1 = name.indices.contains(0) ? name[0] : ""
//                let Part2 = name.indices.contains(1) ? name[1] : ""
                
                            Text(Part1)
                            .font(Font.bold(size: 13))
                            .lineLimit(2)
                            .foregroundColor(subject.id == selectedSubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                            .multilineTextAlignment(.center)
//                            .frame(height:60)
                            .frame(minHeight:subject.teacherSubject != nil ? 20:40)

                
                if let teachertitle = subject.teacherSubject {
                    Group{
                        Text(teachertitle.subjectAcademicYear ?? "")
                            .fontWeight(.medium)
//                            .padding(.top,-30)
                        Text(teachertitle.subjectLevel ?? "")
                            .fontWeight(.medium)
//                            .padding(.top,-30)
//                            .frame(minHeight:15,idealHeight:25,maxHeight: 60)
                    }
                    .font(Font.bold(size: 13))
                    .lineLimit(2)
                    .foregroundColor(subject.id == selectedSubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                    .multilineTextAlignment(.center)
                    .frame(height:20)
//                    .frame(minHeight:15,idealHeight:25,maxHeight: 60)

                }
                    
            }
            .padding(.bottom,5)
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .fill(subject.id == selectedSubject.id ? .mainBlue :ColorConstants.Bluegray100.opacity(0.5)))
        })
    }
}

#Preview {
    StudentHomeSubjectCell(subject:.init(id: 0,name: "general-English namr",teacherSubject: .init(subjectAcademicYear:"name2",subjectLevel:" middle school")),selectedSubject: .constant(HomeSubject.init()))
        .frame(width: (UIScreen.main.bounds.width/3)-20)

}
