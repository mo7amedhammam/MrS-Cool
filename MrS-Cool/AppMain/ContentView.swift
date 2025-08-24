//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationvm = LocationService.shared
    @StateObject var lookupsvm = LookUpsVM()
    @State var showAppCountry = Helper.shared.getAppCountry() == nil && Helper.shared.CheckIfLoggedIn() == false
    @State var selectedAppCountry:AppCountryM? = Helper.shared.getAppCountry()
    
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
//        .onAppear{
//            detectCountry()
//        }
        .environment(\.locale, Locale(identifier: LocalizeHelper.shared.currentLanguage))
        .environment(\.layoutDirection,LocalizeHelper.shared.currentLanguage == "ar" ? .rightToLeft:.leftToRight)
        .edgesIgnoringSafeArea(.vertical)
        .hideNavigationBar()
//        .bottomSheet(isPresented: $showAppCountry,tapToDismiss: false){
        .fullScreenCover(isPresented: $showAppCountry){
            VStack(){
//                ColorConstants.Bluegray100
//                    .frame(width:50,height:5)
//                    .cornerRadius(2.5)
//                    .padding(.top,2)
                
//                HStack {
//                    
//                    Text("select_app_country".localized())
//                        .font(Font.bold(size: 18))
//                        .foregroundColor(.mainBlue)
//                }.padding(8)
                CustomTitleBarView(imgColor:.mainBlue, title: "select_app_country"){
//                    showAppCountry = false
                    print("selectedAppCountry :",selectedAppCountry?.name ?? "")
                }
//                Spacer()
                
                if let countries = lookupsvm.AppCountriesList{
                    
                    ScrollView {
                        ZStack(){
                            Image(.countrySelectHeader)
                                .resizable()
                                .frame(height: 194)
                                .scaledToFit()
                        }
//                        .frame(height: UIScreen.main.bounds.height / 3.3,alignment: .top)
                        .padding(.vertical)

//                        LazyVGrid(
//                            columns: [
//                                    GridItem(.flexible(minimum: 100, maximum: 150)),
//                                    GridItem(.flexible(minimum: 100, maximum: 150))
//                            ],
//                            alignment: .center,
//                            spacing: 10
//                        ) {
                        VStack(spacing:10){
                            let filtered = countries.first?.checkRegion == false ? countries : countries.filter{ $0.abbreviation == locationvm.countryCode }
                            ForEach(filtered,id:\.self) { country in
                                
                                //                                ZStack{
                                //                                    ColorConstants.MainColor
                                //
                                //                                }
                                
                                VStack(spacing:4){
                                    // Radio button indicator
                                    //                                    Image(systemName: selectedAppCountry == country ? "largecircle.fill.circle" : "circle")
                                    //                                        .foregroundColor(.mainBlue) // or use a custom color
                                    //                                        .font(.system(size: 15))
                                    
                                    ZStack{
                                        Circle().fill(Color(.white))
                                        
                                        let imageURL : URL? = URL(string: Constants.baseURL+(country.image ?? "").reverseSlaches())
                                        KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 64,height: 42)
                                            .padding(.horizontal)
                                        //                                        .clipShape(Circle())
                                    }
                                    .frame(width: 82,height: 82)

                                    Spacer()
                                    
                                    Text(country.name ?? "")
                                        .font(.bold(size: 12))
                                        .foregroundColor(selectedAppCountry == country ? .white : Color("Parent-tint"))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(8)
                                    
                                }
                                .padding(20)
                                .frame(maxWidth: 150, alignment: .center) // 👈 Important
                                .background{
                                    (selectedAppCountry == country ? Color(.mainBlue) : Color("StudentDisableBg").opacity(0.5)).cornerRadius(10)
                                }
//                                .padding(.vertical, 10) // Optional: for better tap target
                                .padding(.horizontal,3)
                                .contentShape(Rectangle()) // 👈 Optional
                                .onTapGesture {
                                           selectedAppCountry = country
                                       }

                            }
                        }
                        .padding()
                    }
                    
                    
                    
//                                        ScrollView{
//                    ForEach(countries,id:\.self) { country in
//               
//                        HStack{
//                            // Radio button indicator
//                            Image(systemName: selectedAppCountry == country ? "largecircle.fill.circle" : "circle")
//                                .foregroundColor(.mainBlue) // or use a custom color
//                                .font(.system(size: 15))
//                            
//                            Text(country.name ?? "")
//                                .font(Font.semiBold(size: 16))
//                                .foregroundColor(.mainBlue)
//                            
//                            Spacer()
//                            
//                            let imageURL : URL? = URL(string: Constants.baseURL+(country.image ?? "").reverseSlaches())
//                            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 40,height: 40)
//                                .padding(.horizontal)
//                            //                                    .clipShape(Circle())
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading) // 👈 Important
//                        .padding(.vertical, 10) // Optional: for better tap target
//                        .contentShape(Rectangle()) // 👈 Optional
//                        .onTapGesture {
//                                   selectedAppCountry = country
//                               }
//                        .listRowSpacing(0)
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(Color.clear)
//
//                    }.listStyle(.plain)
//                }
                    
                    CustomButton(Title:"Confirm",bgColor: .mainBlue,IsDisabled:.constant(selectedAppCountry == nil) , action: {
                        DispatchQueue.main.async {
                            guard let country = selectedAppCountry else { return }
                            Helper.shared.saveAppCountry(country: country)
                            //                        Country = false
                            //                            Country = Helper.shared.getAppCountry()
                            showAppCountry = false
                            
                            Helper.shared.changeRoot(toView: ContentView())
                        }
                    })
                    .frame(height: 50)
                }
                else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            .localizeView()
//            .frame(height: 240)
            .background(ColorConstants.WhiteA700.cornerRadius(8))
            .padding()
            .onAppear(){
                Task {
                    await lookupsvm.GetAppCountries()
                    selectedAppCountry = Helper.shared.getAppCountry()
                }
//                print("appcountry is :",Helper.shared.getAppCountry())
            }
//            .onDisappear{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                    print("new appcountry is :",Helper.shared.getAppCountry())
//                })
//            }
            
        }
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

extension ContentView{
    
//     func detectCountry() {
////        locationService = LocationService() // keep a strong reference
//
//         LocationService.shared.onCountryDetected = { countryCode in
//            if let code = countryCode {
//                print("Detected Country: \(code)")
//
//                // Example: Set global flags or variables
//                if code == "EG" {
//                    print("🇪🇬 User is in Egypt")
//                } else if code == "SA" {
//                    print("🇸🇦 User is in Saudi Arabia")
//                }
//            } else {
//                print("❌ Failed to detect country")
//            }
//        }
//    }
}
