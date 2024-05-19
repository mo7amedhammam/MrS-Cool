//
//  MessagesListView.swift
//  MrS-Cool
//
//  Created by wecancity on 27/12/2023.
//

import SwiftUI

struct MessagesListView: View {
    @EnvironmentObject var chatlistvm : ChatListVM
    var selectedLessonId : Int
    var body: some View {
        VStack {
            CustomTitleBarView(title: "Messages")
            
            VStack(spacing:5){ // (Title - Data - Submit Button)
                Group{
                    HStack(){
                        Image("img_message2")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(ColorConstants.MainColor)
                            .frame(width: 35, height: 35, alignment: .center)
                        
                        SignUpHeaderTitle(Title: "Messages")
                        Spacer()
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                if let student = chatlistvm.ChatDetails{
                    VStack{
                        HStack{
                            let imageurl = student.comments?.first(where:{$0.fromImage != nil })?.fromImage ?? ""
//                            AsyncImage(url: URL(string: Constants.baseURL+imageurl)){image in
//                                image
//                                    .resizable()
//                            }placeholder: {
//                                Image("img_younghappysmi")
//                                    .resizable()
//                            }
                            let imageURL : URL? = URL(string: Constants.baseURL+(imageurl ).reverseSlaches())
                            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50,height: 50)
                            .clipShape(Circle())
                            VStack(alignment: .leading,spacing: 4){
                                Text(student.studentName ?? "")
                                    .font(Font.SoraSemiBold(size:15))
                                    .foregroundColor(.mainBlue)
                                
                                Text(student.subjectName ?? "")
                                    .font(Font.SoraSemiBold(size:15))
                                    .foregroundColor(.bluegray400)
                            }
                            Spacer()
                        }
                        .padding([.top,.horizontal])
                        Divider().padding(.horizontal)
                        
                        if let array = student.comments{
                            ScrollViewReader { scrollView in
                                ScrollView {
                                    ForEach(Array(array.enumerated()), id:\.element.hashValue){ index,comment in
                                        HStack{
                                            if comment.fromName != nil {
                                                Spacer()
                                            }
                                            VStack(alignment:comment.fromName != nil ? .trailing : .leading) {
                                                HStack{
                                                    let imageurl = comment.fromName != nil ? comment.fromImage ?? "":comment.toImage ?? ""
//                                                    AsyncImage(url: URL(string: Constants.baseURL+imageurl)){image in
//                                                        image
//                                                            .resizable()
//                                                    }
//                                                placeholder: {
//                                                    Image("img_younghappysmi")
//                                                        .resizable()
//                                                }
                                                    let imageURL : URL? = URL(string: Constants.baseURL+(imageurl ).reverseSlaches())
                                                    KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))

                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40,height: 40)
                                                .clipShape(Circle())
                                                .rotationEffect(Angle(degrees: comment.fromName != nil ? 180 : 0))
                                                    
                                                    HStack(spacing: 4){
                                                        Text(comment.fromName != nil ? comment.fromName ?? "from name" :comment.toName ?? "to name")
                                                            .font(Font.SoraSemiBold(size:15))
                                                            .foregroundColor(.mainBlue)
                                                            .rotationEffect(Angle(degrees: comment.fromName != nil ? 180 : 0))
                                                        
                                                        Text(comment.creationDate ?? "creationDate")
                                                            .font(Font.SoraRegular(size:10))
                                                            .foregroundColor(.bluegray400)
                                                            .rotationEffect(Angle(degrees: comment.fromName != nil ? 180 : 0))
                                                    }
                                                    Spacer()
                                                }
                                                .rotationEffect(Angle(degrees: comment.fromName != nil ? 180 : 0))
                                                
                                                Text(comment.comment ?? "")
                                                    .padding(10)
                                                    .foregroundColor(Color.black)
                                                    .background(comment.fromName != nil ? Color.clear : ColorConstants.Red400.opacity(0.08))
                                                    .cornerRadius(10)
                                            }
                                            
                                            if comment.fromName == nil {
                                                Spacer()
                                            }
                                        }
                                        .padding()
                                        .id(index)
                                        .onAppear {
                                            if index == array.count - 1 {
                                                // Scroll to the bottom when the last item appears
                                                scrollView.scrollTo(index, anchor: .bottom)
                                            }
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        
                        Divider().padding(.horizontal)
                        HStack{
                            TextField("Send a message".localized(), text: $chatlistvm.comment)
                                .font(Font.SoraSemiBold(size:15))
                                .foregroundColor(.mainBlue)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            Button(action: {
                                chatlistvm.CreateChatComment()
                            }, label: {
                                Image("sendmessage")
                            })
                        }
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .background(RoundedCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
                            .fill(.red400.opacity(0.08)))
                        .padding(.horizontal)
                        .padding(.bottom,8)
                        
                    }
                    .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                        .stroke(ColorConstants.Bluegray100,
                                lineWidth: 1))
                    .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                        .fill(ColorConstants.WhiteA700))
                    .padding(.top)
                    .padding(.horizontal,10)
                }else{
                    VStack{
                        Spacer()
                        Image("messagebox")
                        Text("Message box is empty".localized())
                            .font(Font.SoraRegular(size:14))
                            .foregroundColor(.bluegray400)
                            .padding()
                        Spacer()
                        
                    }
                }
                
                
                Spacer()
            }
            
            .onAppear(perform: {
//                chatlistvm.isLoading = false
                chatlistvm.selectedChatId = selectedLessonId
                chatlistvm.GetChatComments()
            })
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
//        .onDisappear {
////            chatlistvm.cleanup()
//        }
        .showHud(isShowing: $chatlistvm.isLoading)
        .showAlert(hasAlert: $chatlistvm.isError, alertType: chatlistvm.error)
        
    }
    
}

#Preview {
    MessagesListView( selectedLessonId: 0)
        .environmentObject(ChatListVM())
}



