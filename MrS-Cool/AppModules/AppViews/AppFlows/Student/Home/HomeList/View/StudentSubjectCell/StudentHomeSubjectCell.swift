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
                let imageURL : URL? = URL(string: Constants.baseURL+(subject.image ?? "").reverseSlaches())
                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                .aspectRatio(contentMode: .fill)
                .frame(width: 70,height: 70)
                .clipShape(Circle())
                .padding(.top, 10)
                
                let subjectName = subject.name ?? ""
                let name = subjectName.split(separator: ",").map{ String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

                let Part1 = name.indices.contains(0) ? name[0] : ""
//                let Part2 = name.indices.contains(1) ? name[1] : ""

                
                            Text(Part1)
                            .font(Font.SoraSemiBold(size: 13))
                            .foregroundColor(subject.id == selectedSubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                            .multilineTextAlignment(.center)
                            .frame(height:60)
                
                if let teachertitle = subject.teacherSubject {
                    Group{
                        Text(teachertitle.subjectAcademicYear ?? "")
                            .padding(.top,-30)
                        Text(teachertitle.subjectLevel ?? "")
                            .padding(.top,-30)

                    }
                    .font(Font.SoraSemiBold(size: 13))
                    .foregroundColor(subject.id == selectedSubject.id ? ColorConstants.WhiteA700 : .mainBlue)
                    .multilineTextAlignment(.center)
                    .frame(height:20)
                    
                }
                    
            }
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .fill(subject.id == selectedSubject.id ? .mainBlue :ColorConstants.Bluegray100.opacity(0.5)))
        })
    }
}

#Preview {
    StudentHomeSubjectCell(selectedSubject: .constant(HomeSubject.init()))
}
