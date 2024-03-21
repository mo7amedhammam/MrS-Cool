//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        NavigationView{
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
//                    SignInView()
                    AnonymousHomeView() // home

                }
//                ManageTeacherSchedualsView()
//                    .environmentObject(LookUpsVM())
//                    .environmentObject(ManageTeacherSchedualsVM())

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


struct NavigationUtil {
    static func popToRootView(animated: Bool = false) {
        findNavigationController(viewController: UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.rootViewController)?.popToRootViewController(animated: animated)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UITabBarController {
            return findNavigationController(viewController: navigationController.selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
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
