//
//  RadioCheck.swift
//  MrS-Cool
//
//  Created by wecancity on 24/10/2023.
//

import SwiftUI

struct RadioCheck: View {
    @Binding var isSelected : Bool?
    var buttons = ["Yes":true,"No":false]
    var body: some View {
        HStack(spacing:0){
            Spacer()
                Button(action: {
                    isSelected = true
                }, label: {
                    HStack(spacing:3){
                        Image(systemName:isSelected == true ? "largecircle.fill.circle" : "circle")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                            .font(Font.bold(size: 13))
                        
                        Text("Yes".localized())
                            .foregroundColor(isSelected == true ? .black:.black.opacity(0.6))
                            .font(Font.regular(size: 14))
                    }
                    .padding(.horizontal)
                    .frame(height: 57)
                })
                
                Button(action: {
                    isSelected = false
                }, label: {
                    HStack(spacing:3){
                        Image(systemName:isSelected == false ? "largecircle.fill.circle" : "circle")
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                            .font(Font.bold(size: 13))
                        
                        Text("No".localized())
                            .foregroundColor(isSelected == false ? .black:.black.opacity(0.6))
                            .font(Font.regular(size: 14))
                    }
                    .padding(.horizontal)
                    .frame(height: 57)
                })
                
        }
    }
}

#Preview {
    RadioCheck(isSelected: .constant(false))
}
