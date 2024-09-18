//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomNavigationView{
            VStack {
                if Helper().checkOnBoard(){
                    SignInView()

                }else if Helper().CheckIfLoggedIn(){
                    if Helper().getSelectedUserType() == .Teacher{
                        TeacherTabBarView()
                    }else if Helper().getSelectedUserType() == .Student{
                        StudentTabBarView()
                    }else{
                        ParentTabBarView()
                    }
                }else{
                    AnonymousHomeView() // home

                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .hideNavigationBar()
//        .onAppear {
//                   for family in UIFont.familyNames.sorted() {
//                       print("Family: \(family)")
//                       
//                       let names = UIFont.fontNames(forFamilyName: family)
//                       for fontName in names {
//                           print("- \(fontName)")
//                       }
//                   }
//               }
    }
}
#Preview {
    ContentView()
}
