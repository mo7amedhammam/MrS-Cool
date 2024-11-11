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

    @State var isPush = false
    @State var destination = AnyView(EmptyView())

    var body: some View {
        CustomNavigationView{
            VStack {
                ScrollView {
                    KFImageLoader(url:URL(string:  "https://platform.mrscool.app/assets/images/Anonymous/Parent.jpg"),placeholder: Image("Parent-Panner"), shouldRefetch: true)

                    LazyVGrid(columns: [.init(), .init(),.init()]) {
                        ForEach(listchildrenvm.Children ?? [], id:\.self) {children in
                            ChildrenCell(children: children, selectedChild: $listchildrenvm.selectedChild, deleteAction: {
                                
                                listchildrenvm.error = .question(title: "Are you sure you want to delete this item ?", image: "studenticon",imgrendermode: .original, message: "Are you want to delete this child account ?", buttonTitle: "Delete", secondButtonTitle: "Not Now",isVertical:false, mainBtnAction: {
                                    listchildrenvm.DeleteStudent(id: children.id ?? 0)
                                }, secondBtnAction: {
                                    //                                listchildrenvm.isError = false
                                })
                                listchildrenvm.isError = true
                                
                            }, detailsaction: {
                                //                            print(id)
                                listchildrenvm.selectedChild = children
                                Helper.shared.selectedchild = children
                                
                                //                            tabbarvm.destination = AnyView(SelectedStudentHome().environmentObject(listchildrenvm)
                                //                            )
                                //                            tabbarvm.ispush = true
                                destination = AnyView(
                                    SelectedStudentHome().environmentObject(listchildrenvm)
                                        .environmentObject(tabbarvm)
                                )
                                isPush = true
                                
                            })
                        }
                        
                        Button(action: {
                            listchildrenvm.error = .question(title: "Are you sure you want to delete this item ?", image: "studenticon",imgrendermode: .original, message: "Are you want to create a new \naccount ?", buttonTitle: "Create New Account", secondButtonTitle: "No, Connect to my son account",isVertical:true, mainBtnAction: {
                                tabbarvm.destination = AnyView(
                                    AddNewStudentView()
                                )
                                tabbarvm.ispush = true
                            }, secondBtnAction: {
                                tabbarvm.destination = AnyView( AddExistingStudentPhone())
                                tabbarvm.ispush = true
                            })
                            listchildrenvm.isError = true
                            
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
                                    .font(Font.semiBold(size: 10))
                                    .fontWeight(.medium)
                                    .foregroundColor(.mainBlue)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical,4)
                                
                                Text("Student".localized())
                                    .font(Font.semiBold(size: 14))
                                    .fontWeight(.medium)
                                    .foregroundColor(.mainBlue)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .frame(height:160)
                            .frame(minWidth: 0,maxWidth: (.infinity/3)-60)
                            .background(
                                CornersRadious(radius: 8, corners: .allCorners).fill(ColorConstants.Bluegray100).opacity(0.33))
                        })
                    }
                    .padding(.top,2)
                    .padding(.horizontal,2)
                }
                Spacer()
                NavigationLink(destination: destination, isActive: $isPush, label: {})

            }
            .padding()
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            .onAppear(perform: {
//                listchildrenvm.selectedChild = nil
                listchildrenvm.GetMyChildren()
                
                guard Helper.shared.selectedchild != nil else {return}
                listchildrenvm.selectedChild = Helper.shared.selectedchild
                destination = AnyView(
                    SelectedStudentHome()
                        .environmentObject(listchildrenvm)
                        .environmentObject(tabbarvm)
                )
                isPush = true
            })
            .onChange(of: listchildrenvm.selectedChild, perform: { value in
                guard value != nil else {return}
                Helper.shared.selectedchild = value
                destination = AnyView(
                    SelectedStudentHome()
                        .environmentObject(listchildrenvm)
                        .environmentObject(tabbarvm)
                )
                isPush = true
            })
            .showHud(isShowing: $listchildrenvm.isLoading)
            .showAlert(hasAlert: $listchildrenvm.isError, alertType: listchildrenvm.error)

        }
        .edgesIgnoringSafeArea(.vertical)
        .hideNavigationBar()
        .localizeView()
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
    var deleteAction:(() -> Void)?
    var detailsaction: (() -> Void)?

    var body: some View {
        VStack{
            HStack{
                Image("img_group")
                    .resizable()
                    .frame(width: 13.5, height: 13.5, alignment: .center)
                    .padding(5)
                    .background(){
                        Color.white.clipShape(Circle())
                    }
                    .padding(5)
                    .onTapGesture {
                        deleteAction?()
                    }
                
                Spacer()
            }
//            Image("studenticon")
            let imageURL : URL? = URL(string: Constants.baseURL + (children.image ?? "image").reverseSlaches())
            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
//                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.top, -27.0)
            
            Text(children.name ?? "")
                .font(Font.bold(size: 13))
//                .fontWeight(.medium)
                .foregroundStyle(selectedChild == children ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                .multilineTextAlignment(.center)
            
            Text(children.academicYearEducationLevelName ?? "")
                .font(Font.bold(size: 9))
                .fontWeight(.medium)
                .foregroundStyle(selectedChild == children ? ColorConstants.WhiteA700 : ColorConstants.Red400)
                .multilineTextAlignment(.center)
            
            Text(children.code ?? "")
                .font(Font.bold(size: 11))
                .fontWeight(.medium)
                .foregroundStyle(selectedChild == children ? ColorConstants.WhiteA700 : .studentBtnBg)
                .multilineTextAlignment(.center)
                .padding(.vertical,2)
            
            Spacer()
            Button(action:{
                    self.detailsaction?()
            },label: {
                Text("Details".localized())
                    .font(Font.bold(size:11))
                    .fontWeight(.medium)
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
      
        .frame(height:160)
        .frame(minWidth: 0,maxWidth: (.infinity/3)-60)
        .background(
            CornersRadious(radius: 8, corners: .allCorners).fill(selectedChild == children ? ColorConstants.Red400 : .parentDisableBg).opacity(selectedChild == children ? 1 : 0.33)
            .borderRadius(ColorConstants.Red400, width: 1, cornerRadius: 8, corners: [.allCorners]))
        .onTapGesture {
            selectedChild = children
            Helper.shared.selectedchild = children
        }
    }
}

