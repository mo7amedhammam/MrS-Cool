//
//  ContentView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
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
        .environment(\.locale, Locale(identifier: LocalizeHelper.shared.currentLanguage))
        .environment(\.layoutDirection,LocalizeHelper.shared.currentLanguage == "ar" ? .rightToLeft:.leftToRight)
        .edgesIgnoringSafeArea(.vertical)
        .hideNavigationBar()
        .bottomSheet(isPresented: $showAppCountry,tapToDismiss: false){
            VStack(){
                ColorConstants.Bluegray100
                    .frame(width:50,height:5)
                    .cornerRadius(2.5)
                    .padding(.top,2)
                HStack {
                    
                    Text("select_app_country".localized())
                        .font(Font.bold(size: 18))
                        .foregroundColor(.mainBlue)
                }.padding(8)
                Spacer()
                
                if let countries = lookupsvm.AppCountriesList{
                    //                    ScrollView{
                    List(countries,id:\.self,selection: $selectedAppCountry) { country in
                        //                                Button(action:{
                        //                                    DispatchQueue.main.async {
                        ////                                        country = country
                        //                                        selectedAppCountry = country
                        ////                                        Helper.shared.saveAppCountry(country: country)
                        //                                    }
                        //                                },label: {
                        HStack{
                            // Radio button indicator
                            Image(systemName: selectedAppCountry == country ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(.mainBlue) // or use a custom color
                                .font(.system(size: 15))
                            
                            Text(country.name ?? "")
                                .font(Font.semiBold(size: 16))
                                .foregroundColor(.mainBlue)
                            
                            Spacer()
                            
                            let imageURL : URL? = URL(string: Constants.baseURL+(country.image ?? "").reverseSlaches())
                            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40,height: 40)
                                .padding(.horizontal)
                            //                                    .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // 👈 Important
                        //                                    .padding(.vertical, 10) // Optional: for better tap target
                        .listRowSpacing(0)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        
                        //                                })
                        //                                .buttonStyle(.plain)
                        //                                .contentShape(Rectangle()) // 👈 Optional
                    }.listStyle(.plain)
                    
                    //                    }
                    CustomButton(Title:"Save",IsDisabled:.constant(selectedAppCountry == nil) , action: {
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
            .frame(height: 240)
            .background(ColorConstants.WhiteA700.cornerRadius(8))
            .padding()
            .onAppear(){
                Task {
                    await lookupsvm.GetAppCountries()
                }
                print("appcountry is :",Helper.shared.getAppCountry())
            }
            .onDisappear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    print("new appcountry is :",Helper.shared.getAppCountry())
                })
            }
            
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
