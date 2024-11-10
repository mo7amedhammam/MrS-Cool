//
//  ChatListCell.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//

import SwiftUI

struct ChatListCell: View {
    var model = ChatListM()
    @Binding var isExpanded : Bool
    @Binding var selectedLessonId : Int
    var selectLessonBtnAction : (()->())?
    
//    @State var selectedLessonId:Int?
    var body: some View {
        VStack(alignment:.leading,spacing: 0){
//           Button(action: {
//               isExpanded.toggle()
//
//           }, label: {
            HStack(alignment: .center,spacing: 20) {
//                AsyncImage(url: URL(string: Constants.baseURL+(model.studentImage ?? "")  )){image in
//                    image
//                        .resizable()
//                }placeholder: {
//                    Image("img_younghappysmi")
//                        .resizable()
//                }

                let imageURL : URL? = URL(string: Constants.baseURL+(model.studentImage ?? "").reverseSlaches())
                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                .aspectRatio(contentMode: .fill)
                .frame(width: 40,height: 40)
                .clipShape(Circle())
                
                Text(model.studentName ?? "")
                    .font(Font.bold(size:15))
                    .foregroundColor(isExpanded ? .whiteA700:.mainBlue)
                    .lineSpacing(8)
                Spacer()
                if let lessonNum = model.lessonNum,lessonNum > 0{
                    Text("\(lessonNum)")
                        .font(Font.bold(size:11))
                        .foregroundColor(.whiteA700)
                        .background{
                            ColorConstants.LightGreen800
                                .frame(width: 20, height: 20, alignment: .center)
                                .clipShape(Circle())
                        }
                }
                Image(isExpanded ? "img_arrowup":"img_arrowdown")
                //                        .resizable()
                //                        .frame(width: 15, height: 18,alignment: .leading)
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(isExpanded ? .whiteA700:.mainBlue)
                    .padding(.trailing)
            }
            .padding(8)
            .background(RoundedCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
                .fill(isExpanded ? ColorConstants.MainColor : .clear))
            
//        })
//           .buttonStyle(.borderless )

            if isExpanded, let array = model.teacherLessonSessionsDtos{
                ForEach(Array(array.enumerated()), id:\.element.id) { index,lesson in
                    Button(action: {
                        selectedLessonId = lesson.id ?? 0
                        selectLessonBtnAction?()

                    }, label: {
                        ChatLessonNameCell(model: lesson,isLessonSelected: .constant(selectedLessonId == lesson.id))
                            .padding(.vertical,5)
                    })
                    .buttonStyle(.borderless)

                }
            }
        }
    }
}

#Preview {
    ChatListCell( isExpanded: .constant(false), selectedLessonId: .constant(0))
}

struct ChatLessonNameCell: View {
    var model = TeacherLessonSessionsDto()
    @Binding var isLessonSelected : Bool

    var body: some View {
        HStack{
            Circle()
                .fill(isLessonSelected ? .black : .bluegray100 )
                .frame(width: 8, height: 8, alignment: .center)
            Text(model.lessonName ?? "")
                .font(Font.bold(size:13))
                .lineSpacing(8)
            Spacer()
        }
//        .frame(minWidth: 0,maxWidth: .infinity)
        .padding()
        .foregroundColor(isLessonSelected ? .black:.black90099)
        .background(RoundedCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
            .fill(isLessonSelected ? .red400.opacity(0.08) : .clear))
    }
}
