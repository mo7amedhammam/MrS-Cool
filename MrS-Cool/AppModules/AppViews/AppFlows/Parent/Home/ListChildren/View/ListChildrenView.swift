//
//  ListChildrenView.swift
//  MrS-Cool
//
//  Created by wecancity on 16/03/2024.
//

import SwiftUI

struct ListChildrenView: View {
    @EnvironmentObject var tabbarvm : StudentTabBarVM
    @EnvironmentObject var listchildrenvm : ListChildrenVM
//    @State private var selectedChild : ChildrenM = ChildrenM.init()

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [.init(), .init(),.init()]) {
                    ForEach(listchildrenvm.Children ?? [], id:\.self) {children in
                        ChildrenCell(children: children, selectedChild: $listchildrenvm.selectedChild){
//                            print(id)
                            listchildrenvm.selectedChild = children
                            Helper.shared.selectedchild = children
                            tabbarvm.destination = AnyView(
                                SelectedStudentHome().environmentObject(listchildrenvm)
                            )
                            tabbarvm.ispush = true
                        }
                    }
                    
                    Button(action: {
                        tabbarvm.error = .question(title: "Are you sure you want to delete this item ?", image: "studenticon",imgrendermode: .original, message: "Are you want to create a new \naccount ?", buttonTitle: "Create New Account", secondButtonTitle: "No, Connect to my son account",isVertical:true, mainBtnAction: {
                            tabbarvm.destination = AnyView(
                                AddNewStudentView()
                            )
                            tabbarvm.ispush = true
                        }, secondBtnAction: {
                            tabbarvm.destination = AnyView( AddExistingStudentPhone()
                            )
                            tabbarvm.ispush = true
                            
                        })
                        tabbarvm.isError = true
                        
                        
                    }, label: {
                        VStack (spacing:0){
                            HStack{
                                Image(systemName: "plus")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.mainBlue)
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .padding(5)
                                    .background(){
                                        Color.white.clipShape(Circle())
                                    }
                                    .padding(5)
                                
                                Spacer()
                            }
                            Image("studenticon")
                                .resizable()
                                .frame(width: 75,
                                       height: 75, alignment: .center)
                            
                            Text("Add New".localized())
                                .font(Font.SoraSemiBold(size: 8))
                                .foregroundColor(.mainBlue)
                                .multilineTextAlignment(.center)
                                .padding(.top,4)
                            
                            Text("Student".localized())
                                .font(Font.SoraSemiBold(size: 12))
                                .foregroundColor(.mainBlue)
                                .multilineTextAlignment(.center)
                            
                        Spacer()
                        }
                        .frame(height:150)
                        .frame(minWidth: 0,maxWidth: 110)
                        .background(
                            CornersRadious(radius: 8, corners: .allCorners).fill(ColorConstants.Bluegray100).opacity(0.33))
                    })
                    
                }
            }
         Spacer()
        }
        .onAppear(perform: {
            listchildrenvm.GetMyChildren()
        })
        .padding()
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
        })
            .showAlert(hasAlert: $tabbarvm.isError, alertType: tabbarvm.error)
        
    }
}

#Preview {
    ListChildrenView()
        .environmentObject(StudentTabBarVM())
        .environmentObject(ListChildrenVM())
}

struct ChildrenCell: View {
    var children:ChildrenM
    @Binding var selectedChild:ChildrenM?

    var detailsaction: (() -> Void)?

    var body: some View {
        VStack{
            HStack{
                Image("img_group")
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .center)
                    .padding(5)
                    .background(){
                        Color.white.clipShape(Circle())
                    }
                    .padding(5)
                
                Spacer()
            }
//            Image("studenticon")
            let imageURL : URL? = URL(string: Constants.baseURL + (children.image ?? "image"))
            KFImageLoader(url: imageURL, placeholder: Image("studenticon"))
//                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.top, -27.0)
            
            Text(children.name ?? "name")
                .font(Font.SoraSemiBold(size: 10))
                .foregroundStyle(selectedChild == children ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                .multilineTextAlignment(.center)
            
            Text(children.academicYearEducationLevelName ?? "egyption education")
                .font(Font.SoraSemiBold(size: 7))
                .foregroundStyle(selectedChild == children ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                .multilineTextAlignment(.center)
            
            Text(children.code ?? "ss-1234")
                .font(Font.SoraSemiBold(size: 10))
                .foregroundStyle(selectedChild == children ? ColorConstants.WhiteA700 : .studentBtnBg)
                .multilineTextAlignment(.center)
                .padding(.vertical,2)
            
            Spacer()
            Button(action:{
                    self.detailsaction?()
            },label: {
                Text("Details".localized())
                    .font(Font.SoraSemiBold(size:9))
                    .foregroundStyle(selectedChild == children ? ColorConstants.Red400 : .whiteA700)
            })
            .frame(width:90,height:20)
//            .contentShape(CornersRadious(radius: 12, corners: .allCorners))
            .background(
                Capsule()
                    .foregroundColor(selectedChild == children ? ColorConstants.WhiteA700 : ColorConstants.Red400)
            )
            Spacer()
        }
      
        .frame(height:150)
        .frame(minWidth: 0,maxWidth: 110)
        .background(
            CornersRadious(radius: 8, corners: .allCorners).fill(selectedChild == children ? ColorConstants.Red400 : .parentDisableBg).opacity(selectedChild == children ? 1 : 0.33)
            .borderRadius(ColorConstants.Red400, width: 1, cornerRadius: 8, corners: [.allCorners]))
        .onTapGesture {
            selectedChild = children
        }
    }
}
