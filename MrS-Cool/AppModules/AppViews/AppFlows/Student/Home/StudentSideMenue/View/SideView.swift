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
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                content
                    .transition(.move(edge: direction))
                    .background(
                        Color.white
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    SideView(isShowing: .constant(true), content: AnyView(Text("menue")), direction: .leading)
}

#Preview {
    SideMenuViewTemp()
}

struct SideMenuViewTemp: View {
    @State var presentSideMenu = true
    
    var body: some View {
        ZStack {
            SideMenuView()
            
            Button {
                presentSideMenu.toggle()
            } label: {
                HStack {
                    Text("Show Menu")
                }
            }
            
        }.background(.black)
        
    }
    
    @ViewBuilder
    private func SideMenuView() -> some View {
        SideView(isShowing: $presentSideMenu, content: AnyView(StudentSideMenuContent(presentSideMenu: $presentSideMenu)), direction: .trailing)
            .offset(x:80)
    }
}

enum Categories:String{
    case home = "home"
    case favorite = "favorite"
    case chat = "chat"
    case profile = "profile"
}

struct StudentSideMenuContent: View {
    @Binding var presentSideMenu: Bool
    //    var categories = [Categories.home.rawValue, Categories.favorite.rawValue, Categories.chat.rawValue, Categories.profile.rawValue
    //    ]
    @State private var selectedCategory: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                
                Text("Jhon Smith")
                
                
            }
            Spacer()
        }
        .offset(x:-40)
        
        .frame(width: UIScreen.main.bounds.width - 100)
        .padding(.horizontal, 20)
        .background{
            Color.mainBlue
        }
        
    }
    
}
