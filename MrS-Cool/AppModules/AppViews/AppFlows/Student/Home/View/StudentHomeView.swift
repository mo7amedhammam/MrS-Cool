//
//  StudentHomeView.swift
//  MrS-Cool
//
//  Created by wecancity on 01/01/2024.
//

import SwiftUI

struct StudentHomeView: View {
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
                GeometryReader{gr in
                    ScrollView{
                        HStack {
                            Text("Subjects".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            Spacer()
                        }.padding(.top)
                        
                        ScrollView(.horizontal){
                            HStack(spacing:10){
                                ForEach(["tab1","tab2","tab3","tab4"],id:\.self){image in
                                    Image(image)
                                        .resizable()
                                        .frame(width: gr.size.width/2.6, height: 120)
                                }
                            }.padding(.vertical,10)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
            

            
        }
        .edgesIgnoringSafeArea(.bottom)
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
    }
}

#Preview{
    StudentHomeView()
}

