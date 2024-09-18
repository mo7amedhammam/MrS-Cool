//
//  TeacherDocumentCell.swift
//  MrS-Cool
//
//  Created by wecancity on 31/10/2023.
//

import SwiftUI

struct TeacherDocumentCell: View {
    var model = TeacherDocumentM()
    var deleteBtnAction : (()->Void)?
    var previewBtnAction : (()->Void)?
    
    var body: some View {
        VStack(alignment:.leading,spacing: 10){
            HStack(alignment: .center,spacing: 10) {
                Text("\(model.order ?? 1)")
                    .font(Font.bold(size:16.0))
                    .foregroundColor(ColorConstants.Bluegray402)
                    .fontWeight(.bold)
                
                VStack{
                    Text(model.title ?? "Certificate")
                        .font(Font.semiBold(size:13.0))
                        .foregroundColor(ColorConstants.Black900)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                Button(action: {
                    deleteBtnAction?()
                }, label: {
                    Image("img_group")
                        .resizable()
                        .frame(width: 15, height: 18,alignment: .leading)
                        .aspectRatio(contentMode: .fill)
                })
                .buttonStyle(.plain)
                .offset(y:-10)
            }
            
            HStack (alignment:.center,spacing: 10){
                Text(model.documentTypeName ?? "PDF")
                    .font(Font.regular(size: 12.0))
                    .fontWeight(.regular)
                    .foregroundColor(ColorConstants.Black900)
                
                Spacer()
                
                Button(action: {
                    previewBtnAction?()
                }, label: {
                    HStack {
                        Image("img_xmlid105")
                            .resizable()
                            .frame(width: 10, height: 12,
                                   alignment: .leading)
                            .scaledToFit()
                        Text("Click For Prev".localized())
                            .font(Font.regular(size:11))
                            .fontWeight(.regular)
                            .foregroundColor(ColorConstants.Gray901)
                    }
                })
                .buttonStyle(.plain)
            }
            .padding(.leading,20)
        }
        .padding()
        .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
            .stroke(ColorConstants.Bluegray100,
                    lineWidth: 1))
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,
                                   bottomRight: 10.0)
            .fill(ColorConstants.WhiteA700))
    }
}

#Preview {
    TeacherDocumentCell()
}
