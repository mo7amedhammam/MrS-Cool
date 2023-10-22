//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    init() {
         UITableView.appearance().showsVerticalScrollIndicator = false
     }
    var body: some View {
        NavigationView{
            VStack {
                SignInView()
            }
        }
        .hideNavigationBar()
        .localizeView()
    }
}

#Preview {
    ContentView()
    //        .localizeView()
}
