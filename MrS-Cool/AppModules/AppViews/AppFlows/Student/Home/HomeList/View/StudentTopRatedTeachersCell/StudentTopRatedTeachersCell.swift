//
//  StudentTopRatedTeachersCell.swift
//  MrS-Cool
//
//  Created by wecancity on 14/01/2024.
//


import SwiftUI

struct StudentTopRatedTeachersCell: View {
    var teacher:StudentMostViewedTeachersM = StudentMostViewedTeachersM()
    @Binding var selectedteacher:StudentMostViewedTeachersM
    var action:(()->Void)?

    var body: some View {
        Button(action: {
            selectedteacher = teacher
            action?()
        }, label: {
            VStack (spacing:0){
//                AsyncImage(url: URL(string: Constants.baseURL+(teacher.teacherImage ?? "")  )){image in
//                    image
//                        .resizable()
//                }placeholder: {
//                    Image("img_younghappysmi")
//                        .resizable()
//                }
                let imageURL : URL? = URL(string: Constants.baseURL+(teacher.teacherImage ?? "").reverseSlaches())
                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                .aspectRatio(contentMode: .fill)
                .frame(width: 80,height: 80)
                .clipShape(Circle())
                .padding(.top, 10)

                Text(teacher.teacherName ?? "")
                    .font(Font.SoraSemiBold(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(teacher.id == selectedteacher.id ? ColorConstants.WhiteA700 : .mainBlue)
                    .multilineTextAlignment(.center)
                    .frame(height:40)
                
                HStack{
                    StarsView(rating: teacher.teacherRate ?? 0.0)
                    if let ratescount = teacher.teacherReview, ratescount > 0{
                        Text(" \(ratescount)")
                        .foregroundColor(teacher.id == selectedteacher.id ? ColorConstants.WhiteA700 : .mainBlue)
                        .font(Font.SoraRegular(size: 12))
                    }
                }
            }
            .padding(.bottom)
            .frame(minWidth: 0,maxWidth: .infinity)
            .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                .fill(teacher.id == selectedteacher.id ? .mainBlue :ColorConstants.Bluegray100.opacity(0.5)))
        })
    }
}

#Preview {
    StudentTopRatedTeachersCell(selectedteacher: .constant(StudentMostViewedTeachersM.init()))
}


//struct StarsView: View {
//    private static let MAX_RATING: Float = 5 // Defines upper limit of the rating
//    private static let COLOR = Color.orange // The color of the stars
//    
//    let rating: Float
//    private let fullCount: Int
//    private let emptyCount: Int
//    private let halfFullCount: Int
//    
//    init(rating: Float) {
//        self.rating = rating
//        fullCount = Int(rating)
//        emptyCount = Int(StarsView.MAX_RATING - rating)
//        halfFullCount = (Float(fullCount + emptyCount) < StarsView.MAX_RATING) ? 1 : 0
//    }
//    
//    var body: some View {
//        HStack (spacing:5){
//            ForEach(0..<fullCount) { _ in
//                self.fullStar
//                    .frame(width:10,height: 10)
//            }
//            ForEach(0..<halfFullCount) { _ in
//                self.halfFullStar
//                    .frame(width:10,height: 10)
//            }
//            ForEach(0..<emptyCount) { _ in
//                self.emptyStar
//                    .frame(width:10,height: 10)
//            }
//        }
//    }
//    
//    private var fullStar: some View {
//        Image(systemName: "star.fill").resizable().foregroundColor(StarsView.COLOR)
//    }
//    
//    private var halfFullStar: some View {
//        Image(systemName: "star.lefthalf.fill").resizable().foregroundColor(StarsView.COLOR)
//    }
//    
//    private var emptyStar: some View {
//        Image(systemName: "star").resizable().foregroundColor(StarsView.COLOR)
//    }
//}

//#Preview{
//    StarsView(rating: 3.5)
//}

/// A view displaying a star rating with a step of 0.5.
struct StarsView: View {
  /// A value in range of 0.0 to 5.0.
  let rating: Float
    
  var body: some View {
    HStack(spacing: 5) {
      ForEach(0..<5) { index in
        Image(systemName: imageName(for: index, value: rating))
              .resizable()
              .frame(width:10,height: 10)
              .aspectRatio(contentMode: .fit)
          
      }
    }
    .foregroundColor(.yellow)
  }
  
    func imageName(for starIndex: Int, value: Float) -> String {
      // Version A
//      if value >= Double(starIndex + 1) {
//        return "star.fill"
//      }
//      else if value >= Double(starIndex) + 0.5 {
//        return "star.leadinghalf.filled"
//      }
//      else {
//        return "star"
//      }
            
      // Version B
      switch value - Float(starIndex) {
      case ..<0.5: return "star"
      case 0.5..<1.0: return "star.leadinghalf.filled"
      default: return "star.fill"
      }
    }
}

#Preview{
    StarsView(rating: 3.5)
        .frame(width:120)
}
