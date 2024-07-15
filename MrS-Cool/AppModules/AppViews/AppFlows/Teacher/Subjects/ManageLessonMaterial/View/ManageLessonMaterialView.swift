//
//  ManageLessonMaterialView.swift
//  MrS-Cool
//
//  Created by wecancity on 25/11/2023.
//

import SwiftUI

struct ManageLessonMaterialView: View {    //        @Environment(\.dismiss) var dismiss
    @EnvironmentObject var lookupsvm : LookUpsVM
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @EnvironmentObject var managelessonmaterialvm : ManageLessonMaterialVM
    
    //    @State var isPush = false
    //    @State var destination = EmptyView()
    @State private var isEditing = false
    @State private var isSheetPresented = false
    @State private var selectedFileType: fileTypesList = .image // Track the selected file type
    
    @State private var showImageSheet = false
    @State private var imagesource: UIImagePickerController.SourceType? = .camera // Track the selected file type
    @State private var startPickingImage = false
    @State private var startPickingPdf = false
    
    @State private var isPreviewPresented = false
    @State var previewurl : String = ""
    
    @State var showFilter : Bool = false
    @State var filtermaterialType : DropDownOption?
    @State var filtermaterialName : String = ""

    @State var currentLesson:TeacherUnitLesson?
    var body: some View {
        ZStack {
            VStack {
                CustomTitleBarView(title: "Manage My Lesson Material")
                
                GeometryReader { gr in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                VStack(alignment: .leading, spacing: 0){
                                    // -- Data Title --
                                    HStack(alignment: .top){
                                        SignUpHeaderTitle(Title:  "Lesson Information")
                                        Spacer()
                                    }
                                    //                                .padding(.bottom )
                                    
                                    // -- inputs --
                                    Group {
                                        HStack(alignment:.top){
                                            VStack(alignment:.leading){
                                                Text("Education Type".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.educationTypeName ?? "")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:20)
                                                
                                                Text("Academic Year".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.academicYearName ?? "")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:20)
                                                
                                                Text("Lesson".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.lessonName ?? "")
                                                    .font(Font.SoraRegular(size: 14))
                                            }
                                            Spacer()
                                            VStack(alignment:.leading){
                                                Text("Education Level".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.educationLevelName ?? "")
                                                    .font(Font.SoraRegular(size: 14))
                                                
                                                Spacer().frame(height:20)
                                                
                                                Text("Subject".localized())
                                                    .font(Font.SoraSemiBold(size: 16))
                                                
                                                Text(currentLesson?.subjectSemesterYearName ?? "")
                                                    .font(Font.SoraRegular(size: 14))
                                            }
                                        }
                                        
                                    }
                                    .foregroundColor(.mainBlue)
                                    .padding([.top,.horizontal])
                                    
                                }
                                .padding(.top,5)
                                
                                VStack {
                                    GeometryReader { gr in
                                        ScrollViewReader{ scrollViewProxy in
                                            ScrollView(.vertical, showsIndicators: false) {
                                                VStack{ // (Title - Data - Submit Button)
                                                    Group{
                                                        VStack(alignment: .leading, spacing: 0){
                                                            // -- Data Title --
                                                            SignUpHeaderTitle(Title:managelessonmaterialvm.isEditing ? "Update My Material" : "Add New Material")
                                                                .id(1)
                                                            
                                                            // -- inputs --
                                                            Group {
                                                                CustomDropDownField(iconName:"img_group_512390",placeholder: "Material Type", selectedOption: $managelessonmaterialvm.materialType,options:lookupsvm.materialTypesList,isvalid:managelessonmaterialvm.ismaterialTypevalid)
                                                                
                                                                CustomTextField(iconName:"img_group_512388",placeholder: "Material Title", text: $managelessonmaterialvm.materialNameEn,isvalid:managelessonmaterialvm.ismaterialNameEnvalid)
                                                                    .onChange(of: managelessonmaterialvm.materialNameEn) { newValue in
                                                                        managelessonmaterialvm.materialNameEn = newValue.filter { $0.isEnglish }
                                                                    }
                                                                
                                                                
                                                                CustomTextField(iconName:"img_group_512388",placeholder: "اسم المحتوى", text: $managelessonmaterialvm.materialName,isvalid:managelessonmaterialvm.ismaterialNamevalid).reversLocalizeView()
                                                                    .onChange(of: managelessonmaterialvm.materialName) { newValue in
                                                                        managelessonmaterialvm.materialName = newValue.filter { $0.isArabic }
                                                                    }
                                                                
                                                                
                                                                //                                                        CustomTextField(iconName:"img_group_512386",placeholder: "Order", text: $managelessonmaterialvm.documentOrder,keyboardType: .asciiCapableNumberPad)
                                                                
                                                                CustomTextField(iconName:"img_group_512411",placeholder: "URL", text: $managelessonmaterialvm.materialUrl,keyboardType: .URL,Disabled:managelessonmaterialvm.isdocumentFilevalid,isvalid:(managelessonmaterialvm.ismaterialUrlvalid ?? true || managelessonmaterialvm.isdocumentFilevalid ?? true),isdimmed:managelessonmaterialvm.isdocumentFilevalid)
                                                                
                                                            }
                                                            .padding([.top])
                                                            .padding(.horizontal,2)
                                                            
                                                            if managelessonmaterialvm.materialImg != nil || managelessonmaterialvm.materialPdf != nil{
                                                                VStack(alignment: .center,spacing:15) {
                                                                    Image("img_maskgroup192")
                                                                    HStack(alignment:.top,spacing: 10){
                                                                        Button(action: {
                                                                            managelessonmaterialvm.materialImg = nil
                                                                            managelessonmaterialvm.materialPdf = nil
                                                                        }, label: {
                                                                            Image("img_group")
                                                                                .resizable()
                                                                                .frame(width: 15, height: 18,alignment: .leading)
                                                                                .aspectRatio(contentMode: .fill)
                                                                        })
                                                                        
                                                                        Text("Your file uploaded successfully".localized())
                                                                            .font(Font.SoraRegular(size:12))
                                                                            .foregroundColor(ColorConstants.Gray900)
                                                                            .multilineTextAlignment(.center)
                                                                    }
                                                                }
                                                                .padding(.top)
                                                                .frame(minWidth:0,maxWidth:.infinity)
                                                            }else{
                                                                if managelessonmaterialvm.materialUrl.count > 0 && !managelessonmaterialvm.materialUrl.isValidURL() {
                                                                    Text("Invalid URL".localized())
                                                                        .lineSpacing(4)
                                                                        .frame(minWidth: 0,maxWidth: .infinity)
                                                                        .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                                                                        .foregroundColor(ColorConstants.Red400)
                                                                        .multilineTextAlignment(.center)
                                                                        .padding(.top)
                                                                }
                                                                if managelessonmaterialvm.materialImg != nil || managelessonmaterialvm.materialPdf != nil && !(managelessonmaterialvm.isdocumentFilevalid ?? true){
                                                                    Text("File or image not selected".localized())
                                                                        .lineSpacing(4)
                                                                        .frame(minWidth: 0,maxWidth: .infinity)
                                                                        .font(Font.SoraRegular(size: getRelativeHeight(12.0)))
                                                                        .foregroundColor(ColorConstants.Red400)
                                                                        .multilineTextAlignment(.center)
                                                                        .padding(.top)
                                                                }
                                                                
                                                                CustomButton(imageName:"img_group_512394",Title: "Choose Files",IsDisabled: .constant(managelessonmaterialvm.materialUrl.count > 0)){
                                                                    hideKeyboard()
                                                                    isSheetPresented = true
                                                                }
                                                                .frame(height: 50)
                                                                .padding(.top)
                                                                .padding(.horizontal,80)
                                                                
                                                                Text("Files supported: PDF, JPG, PNG,\nTIFF, GIF, WORD\nMaximum size is : 2MB".localized())
                                                                    .lineSpacing(4)
                                                                    .frame(minWidth: 0,maxWidth: .infinity)
                                                                    .font(Font.SoraRegular(size: 12.0))
                                                                    .foregroundColor(ColorConstants.Gray901)
                                                                    .multilineTextAlignment(.center)
                                                                    .padding(.top)
                                                            }
                                                        }.padding(.top,20)
                                                        
                                                        HStack {
                                                            Group{
                                                                CustomButton(Title:managelessonmaterialvm.isEditing ? "Update" : "Save",IsDisabled: .constant(false), action: {
                                                                    if managelessonmaterialvm.isEditing{
                                                                        managelessonmaterialvm.UpdateLessonMaterial(fileType: selectedFileType)
                                                                    }else{
                                                                        managelessonmaterialvm.CreateLessonMaterial(fileType: selectedFileType)
                                                                    }
                                                                })
                                                                CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                                    if managelessonmaterialvm.isEditing{
                                                                        managelessonmaterialvm.isEditing = false
                                                                        managelessonmaterialvm.editingMaterial = nil
                                                                    }else{
                                                                        managelessonmaterialvm.clearTeachersMaterial()
                                                                    }
                                                                })
                                                            }
                                                            .frame(width:120,height: 40)
                                                        }
                                                        .padding(.vertical)
                                                        //                        if teacherdocumentsvm.TeacherDocuments.count > 0{
                                                        HStack(){
                                                            SignUpHeaderTitle(Title: "Manage My Material")
                                                            Spacer()
                                                            Image("img_maskgroup62_clipped")
                                                                .resizable()
                                                                .renderingMode(.template)
                                                                .foregroundColor(ColorConstants.MainColor)
                                                                .frame(width: 25, height: 25, alignment: .center)
                                                                .onTapGesture(perform: {
                                                                    showFilter = true
                                                                })
                                                        }
                                                    }
                                                    if (managelessonmaterialvm.TeacherLessonMaterialList ?? []).count > 0{
                                                        List(managelessonmaterialvm.TeacherLessonMaterialList ?? [] ,id:\.self){ material in
                                                            
                                                            ManageLessonMaterialCell(model: material,editBtnAction:{
                                                                managelessonmaterialvm.isEditing = true
                                                                managelessonmaterialvm.editingMaterial = material
                                                                scrollViewProxy.scrollTo(1)
                                                            }, deleteBtnAction: {
                                                                managelessonmaterialvm.error = .question(title: "Are you sure you want to delete this item ?", image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                                                    managelessonmaterialvm.DeleteLessonMaterial(id: material.id)
                                                                    managelessonmaterialvm.clearTeachersMaterial()
                                                                })
                                                                managelessonmaterialvm.isError.toggle()
                                                                
                                                            }, previewBtnAction: {
                                                                previewurl = (material.materialURL ?? "")
                                                                previewurl.openAsURL()
                                                                
                                                                //                                                            isPreviewPresented.toggle()
                                                                
                                                                //                                                            print("previewurl: \(previewurl)")
                                                                
                                                                //                                                            UIApplication.shared.open(URL(string: previewurl)!)
                                                                
                                                            }
                                                            )
                                                            .listRowSpacing(0)
                                                            .listRowSeparator(.hidden)
                                                            .listRowBackground(Color.clear)
                                                            .padding(.vertical,-4)
                                                        }
                                                        //                                                    .scrollContentBackground(.hidden)
                                                        .listStyle(.plain)
                                                        .frame(height: gr.size.height/3*3)
                                                        .padding(.horizontal,-18)
                                                    }
                                                }
                                                //                                        .frame(minHeight: gr.size.height)
                                            }
                                        }
                                    }
                                    
                                    
                                    //MARK: -------- imagePicker From Camera and Library ------
                                    .confirmationDialog(Text("Choose_File_Type".localized()), isPresented: $isSheetPresented) {
                                        Button("Image".localized()) {
                                            selectedFileType = .image
                                            showImageSheet = true
                                            print("upload image")
                                            // Call a function to show an image picker
                                        }
                                        Button("PDF".localized()) {
                                            selectedFileType = .pdf
                                            startPickingPdf = true
                                            print("upload pdf")
                                            // Call a function to add a PDF document
                                        }
                                        Button("Cancel".localized(), role: .cancel) { }
                                    } message: {Text("this is the file type you will add".localized())}
                                    
                                    //MARK: -------- imagePicker From Camera and Library ------
                                        .confirmationDialog("Choose_Image_From".localized(), isPresented: $showImageSheet) {
                                            Button("photo_Library".localized()) {
                                                self.imagesource = .photoLibrary
                                                self.showImageSheet = false
                                                self.startPickingImage = true
                                            }
                                            Button("Camera".localized()) {
                                                self.imagesource = .camera
                                                self.showImageSheet = false
                                                self.startPickingImage = true
                                            }
                                            Button("Cancel".localized(), role: .cancel) { }
                                        } message: {Text("Choose_Image_From".localized())}
                                    
                                        .sheet(isPresented: $startPickingImage) {
                                            if let sourceType = imagesource {
                                                // Pick an image from the photo library:
                                                ImagePicker(sourceType: sourceType , selectedImage: $managelessonmaterialvm.materialImg)
                                            }
                                        }
                                        .fileImporter(isPresented: $startPickingPdf, allowedContentTypes: [.pdf], onCompletion: {result in
                                            
                                            switch result {
                                            case .success(let url):
                                                managelessonmaterialvm.materialPdf = url
                                                
                                            case .failure(let failure):
                                                print("Importer error: \(failure)")
                                            }
                                        })
                                    //                                        .fullScreenCover(isPresented: $isPreviewPresented, onDismiss: {
                                    //                                        // Optional: Handle actions on closing the preview sheet
                                    //                                    }, content: {
                                    //
                                    //                                        Webview(url: URL(string:previewurl)!)
                                    //                                    })
                                }
                                
                            }
                            .padding(.horizontal)
                            
                            
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
                }
            }
            
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            .onAppear(perform: {
                managelessonmaterialvm.TeacherLessonId = currentLesson?.id ?? 0
                lookupsvm.GetMaterialTypes()
                managelessonmaterialvm.GetLessonMaterial()
            })
            .onChange(of: managelessonmaterialvm.TeacherLessonMaterialM?.teacherLessonMaterialBasicData , perform: { value in
                guard currentLesson?.academicYearName == nil else{return}
                if let lesson = value{
                    currentLesson = TeacherUnitLesson(lessonName: lesson.lessonName, educationTypeName: lesson.educationTypeName, educationLevelName: lesson.educationLevelName, academicYearName: lesson.academicYearName, subjectSemesterYearName: lesson.subjectSemesterYearName)
                }
            })
            
            .showHud(isShowing: $managelessonmaterialvm.isLoading)
            .showAlert(hasAlert: $managelessonmaterialvm.isError, alertType: managelessonmaterialvm.error)
            
            if showFilter{
                // Blurred Background and Sheet
                Color.mainBlue
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                    .blur(radius: 4) // Adjust the blur radius as needed
                DynamicHeightSheet(isPresented: $showFilter){
                    
                    VStack {
                        ColorConstants.Bluegray100
                            .frame(width:50,height:5)
                            .cornerRadius(2.5)
                            .padding(.top,2.5)
                        HStack {
                            Text("Filter".localized())
                                .font(Font.SoraBold(size: 18))
                                .foregroundColor(.mainBlue)
                            //                                            Spacer()
                        }
                        
                        ScrollView{
                            VStack{
                                Group{
                                    CustomDropDownField(iconName:"img_group_512390",placeholder: "Material Type", selectedOption: $filtermaterialType,options:lookupsvm.materialTypesList)
                                    
                                    CustomTextField(iconName:"img_group_512388",placeholder: "Material Title", text: $filtermaterialName)
                                }
                                .padding(.top,5)
                                //                                Spacer()
                                HStack {
                                    Group{
                                        CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                            managelessonmaterialvm.filtermaterialType = filtermaterialType
                                            managelessonmaterialvm.filtermaterialName = filtermaterialName
                                            managelessonmaterialvm.GetLessonMaterial()
                                            showFilter = false
                                        })
                                        
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            filtermaterialType = nil
                                            filtermaterialName = ""
                                            managelessonmaterialvm.clearFilter()
                                            managelessonmaterialvm.GetLessonMaterial()
                                            showFilter = false
                                        })
                                    } .frame(width:130,height:40)
                                        .padding(.vertical)
                                }
                                //                                    Spacer()
                            }
                            .padding(.horizontal,3)
                            .padding(.top)
                        }
                        
                    }
                    .padding()
                    .frame(height:300)
                    //                    .keyboardAdaptive()
                }
                
            }
        }
    }
}

#Preview {
    ManageLessonMaterialView()
        .environmentObject(LookUpsVM())
    //        .environmentObject(SignUpViewModel())
        .environmentObject(ManageLessonMaterialVM())
    
}



//import UIKit
import WebKit
struct Webview: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> WebviewController {
        let webviewController = WebviewController()
        
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)
        
        return webviewController
    }
    
    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        //
    }
}

class WebviewController: UIViewController, WKNavigationDelegate {
    lazy var webview: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()
    
    deinit {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview.navigationDelegate = self
        self.view.addSubview(self.webview)
        
        self.webview.frame = self.view.frame
        self.webview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            self.webview.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        self.webview.addSubview(self.progressbar)
        self.setProgressBarPosition()
        
        webview.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        self.progressbar.progress = 0.1
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func setProgressBarPosition() {
        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.webview.removeConstraints(self.webview.constraints)
        self.webview.addConstraints([
            self.progressbar.topAnchor.constraint(equalTo: self.webview.topAnchor, constant: self.webview.scrollView.contentOffset.y * -1),
            self.progressbar.leadingAnchor.constraint(equalTo: self.webview.leadingAnchor),
            self.progressbar.trailingAnchor.constraint(equalTo: self.webview.trailingAnchor),
        ])
    }
    
    // MARK: - Web view progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if self.webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { () in
                    self.progressbar.alpha = 0.0
                }, completion: { finished in
                    self.progressbar.setProgress(0.0, animated: false)
                })
            } else {
                self.progressbar.isHidden = false
                self.progressbar.alpha = 1.0
                progressbar.setProgress(Float(self.webview.estimatedProgress), animated: true)
            }
            
        case "contentOffset":
            self.setProgressBarPosition()
            
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
