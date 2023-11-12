//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    var body: some View {

        NavigationView{
            VStack {
//                SignInView()
                
                ManageTeacherProfileView()
                    .environmentObject(LookUpsVM())
                    .environmentObject(ManageTeacherProfileVM())
                

            }
        }
        .hideNavigationBar()
        .localizeView()


    }
}
@available(iOS 16.0, *)
#Preview {
    ContentView()
    //        .localizeView()
}




//class appEnvironments: ObservableObject {
//    @Published var isLoading:Bool? = false
//    @Published var isError = false
//    @Published var message = ""
//    
////    @Published var desiredTab = ""
////
//////    MARK:  -- showMap Image preview --
////    @Published var isPresented = false
////    @Published var imageUrl = ""
////    
//////    MARK:  -- showMap Redirector --
////    @Published var ShowMapRedirector = false
////    @Published var Destinationlongitude:Double = 0
////    @Published var Destinationlatitude:Double = 0
////    
//////    MARK:  -- showRating --
////    @Published var  ShowRatingSheet = false
////    
////    @Published var isError = false
////    
////    @Published var confirmAlert = false
////    @Published var confirmMessage = "are_you_sure_To_Start_now?"
////
//
//}
