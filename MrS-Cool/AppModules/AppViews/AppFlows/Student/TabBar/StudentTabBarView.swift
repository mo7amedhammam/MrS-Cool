//
//  StudentTabBarView.swift
//  MrS-Cool
//
//  Created by wecancity on 03/01/2024.
//


import SwiftUI

struct StudentTabBarView: View {
    @State private var selectedIndex = 1
    private let tabBarItems = [
        TabBarItem(icon: "tab0", selectedicon: "tab0", title: ""),
        TabBarItem(icon: "tab1", selectedicon: "tab1", title: ""),
        TabBarItem(icon: "tab2", selectedicon: "tab2selected", title: ""),
        TabBarItem(icon: "tab3", selectedicon: "tab3", title: ""),
        TabBarItem(icon: "tab4", selectedicon: "tab4", title: "")
    ]
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Group{
                        Text("Hi ")+Text("Student ")+Text(",\(selectedIndex)".localized())
                        
                        Text("Lets Start Learning! ".localized())
                            .font(Font.SoraRegular(size: 11))
                            .padding(.vertical,0.5)
                    }
                    .font(Font.SoraBold(size: 18))
                    .foregroundColor(.whiteA700)
                    
                }
                
                Spacer()
            }
            .padding()
            .background(
                CornersRadious(radius: 10, corners: [.bottomLeft,.bottomRight])
                    .fill(ColorConstants.MainColor)
                    .edgesIgnoringSafeArea(.top)
            )
            
            TabView(selection: $selectedIndex) {
                
                StudentHomeView()
                    .tag(0)
                
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                StudentHomeView()
                    .tag(1)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                StudentHomeView()
                    .tag(2)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                StudentHomeView()
                    .tag(3)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
                
                StudentHomeView()
                    .tag(4)
                    .gesture(
                        DragGesture().onChanged { _ in
                            // Disable swipe gestures
                        }
                    )
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
            CustomTabBarView(selectedIndex: $selectedIndex,tabBarItems:tabBarItems)
            
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
    StudentTabBarView()
}

enum HomeTabs {
    case tab0,tab1,tab2,tab3,tab4
}
struct CustomTabBarView: View {
    @Binding var selectedIndex : Int
    let tabBarItems : [TabBarItem]
    private let middleTabWidth: CGFloat = 60
    private let middleTabHeight: CGFloat = 66
    private let middleTabCurveHeight: CGFloat = 30
    var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 0) {
                ForEach(0..<tabBarItems.count) { index in
                    TabBarItemView(
                        item: tabBarItems[index],
                        isSelected: selectedIndex == index,
                        onTap: {
                            selectedIndex = index
                        }
                    )
                    .offset(y:index == tabBarItems.count / 2  ? -12 : 8 )
                    if index == tabBarItems.count / 2 - 1 {
                        Spacer()
                    }
                }
            }
            .frame(height: middleTabHeight)
            .background(content: {
                tabshape(midpoint: UIScreen.main.bounds.midX+4)
                    .fill(ColorConstants.WhiteA700)
                    .shadow(color: ColorConstants.Black900.opacity(0.2), radius: 10, x: 0, y: 0)
                    .edgesIgnoringSafeArea(.bottom)
                
            })
            //            }
            //            .frame(height: middleTabHeight)
        }
        
        //        .frame(height: middleTabHeight)
        
    }
}

struct TabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(isSelected ? item.selectedicon:item.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(item.title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabBarItem {
    let icon: String
    let selectedicon: String
    let title: String
}

struct tabshape:Shape {
    var midpoint:CGFloat
    func path(in rect:CGRect) -> Path {
        return Path{ path in
            path.addPath(Rectangle().path(in: rect))
            
            path.move(to: .init(x: midpoint - 60, y: 0))
            let to = CGPoint(x: midpoint, y: -25)
            let cont1 = CGPoint(x: midpoint - 25 , y: 0)
            let cont2 = CGPoint(x: midpoint - 25, y: -25)
            path.addCurve(to: to, control1: cont1, control2: cont2)
            
            let to1 = CGPoint(x: midpoint + 60, y: 0)
            let cont3 = CGPoint(x: midpoint + 25 , y: -25)
            let cont4 = CGPoint(x: midpoint + 25, y: 0)
            path.addCurve(to: to1, control1: cont3, control2: cont4)
            
        }
    }
}
