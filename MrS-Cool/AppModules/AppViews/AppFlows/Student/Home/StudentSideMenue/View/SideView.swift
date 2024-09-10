//
//  SideView.swift
//  MrS-Cool
//
//  Created by wecancity on 11/02/2024.
//

import SwiftUI

struct SideView: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var direction: Edge
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isShowing {
                Color.mainBlue
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                content
//                    .offset(x:66)
                    .transition(.move(edge: direction))
                    .background(
                        Color.clear
//                            .offset(x:-35)
//                            .opacity(0.3)
//                            .onTapGesture {
//                                isShowing = false
//                            }
                    )
            }
        }
        .localizeView()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    SideView(isShowing: .constant(true), content: AnyView(Text("menue")), direction: .leading)
}

//#Preview {
//    SideMenuViewTemp()
//}

//struct SideMenuViewTemp: View {
//    @State var presentSideMenu = true
//    
//    var body: some View {
//        ZStack {
//            SideMenuView()
//            
////            Button {
////                presentSideMenu.toggle()
////            } label: {
////                HStack {
////                    Text("Show Menu")
////                }
////            }
//            
//        }.background(.black)
//        
//    }
//    
//    @ViewBuilder
//    private func SideMenuView() -> some View {
//        SideView(isShowing: $presentSideMenu, content: AnyView(StudentSideMenuContent(presentSideMenu: $presentSideMenu)), direction: .trailing)
//            .localizeView()
//    }
//}

