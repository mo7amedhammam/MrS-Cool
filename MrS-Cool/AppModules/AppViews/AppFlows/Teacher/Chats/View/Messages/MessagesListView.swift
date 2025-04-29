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
    // Add a task reference for cancellation
      @State private var fetchTask: Task<Void, Never>?
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
                if chatlistvm.ChatDetails != nil{
                    VStack{
                        CommentsHeader(header: chatlistvm.ChatDetails)
                        Divider().padding(.horizontal)
                        
//                        if let comments = chatlistvm.ChatDetails?.comments {
                        CommentsList(comments: chatlistvm.ChatDetails?.comments ?? [])
//                        }
                        
                        Divider().padding(.horizontal)
                        
                        MessageInputField(comment: $chatlistvm.comment) {
                        Task{
                             chatlistvm.CreateChatComment(chatid: selectedLessonId) }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .overlay(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                        .stroke(ColorConstants.Bluegray100,
                                lineWidth: 1))
                    .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
                        .fill(ColorConstants.WhiteA700))
                    .padding(.top)
                    .padding(.horizontal,10)
                    
                }else{
                    EmptyMessageBox()
                }
                Spacer()
            }
//            .onAppear(perform: {
//                chatlistvm.comment.removeAll()
////                chatlistvm.selectedChatId = selectedLessonId
//                    chatlistvm.GetChatComments(chatid: selectedLessonId)
//            })
//            .task {
//                await fetchComments()
//            }
            .task {
                cancelRequests()
                fetchTask = Task {
                    chatlistvm.isLoading = true
                    await fetchComments()
                    chatlistvm.isLoading = false
                }
            }
            .onDisappear {
                cancelRequests()
            }
        
        
            
        }
        .hideNavigationBar()
        .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
            hideKeyboard()
        })
        //        .onDisappear {
        ////            chatlistvm.cleanup()
        //        }
        .showHud(isShowing: $chatlistvm.isLoadingComments)
        .showAlert(hasAlert: $chatlistvm.isError, alertType: chatlistvm.error)
        
    }
    
    private func cancelRequests() {
        fetchTask?.cancel()
        chatlistvm.cleanup()
    }

//    @MainActor
//       private func fetchComments() async {
//           chatlistvm.isLoadingComments = true // Start the loading animation
//           await chatlistvm.GetChatComments(chatid: selectedLessonId)
//           chatlistvm.isLoadingComments = false // Stop the loading animation
//       }
    
    @MainActor
       private func fetchComments() async {
           chatlistvm.isLoadingComments = true // Start the loading animation
           defer { chatlistvm.isLoadingComments = false }

           do{
               try Task.checkCancellation()

               await chatlistvm.GetChatComments(chatid: selectedLessonId)

       } catch {
//           chatlistvm.isLoadingComments = false
           if error is CancellationError { return }
           // Handle other errors
       }
       }
}

#Preview {
    MessagesListView( selectedLessonId: 0)
        .environmentObject(ChatListVM())
}

import UIKit

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var maxHeight: CGFloat
    var onDone: (() -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.backgroundColor = UIColor.clear
        if nil != onDone {
            textView.returnKeyType = .done
        }
        
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight, maxHeight: maxHeight)
    }
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>, maxHeight: CGFloat) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = min(newSize.height, maxHeight)
        if result.wrappedValue != newHeight {
            DispatchQueue.main.async {
                result.wrappedValue = newHeight // Must be called asynchronously
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        
        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight, maxHeight: uiView.frame.size.height)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }
}

struct MultilineTextField: View {
    
    private var placeholder: String
    private var onCommit: (() -> Void)?
    
    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) { newValue in
            self.text = newValue
            self.updatePlaceholderVisibility()
        }
    }
    
    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false
    private var maxHeight: CGFloat = 100
    
    init (_ placeholder: String = "", text: Binding<String>, maxHeight: CGFloat = 100, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self.maxHeight = maxHeight
        self._showingPlaceholder = State(initialValue: text.wrappedValue.isEmpty)
    }
    
    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, maxHeight: maxHeight, onDone: onCommit)
            .font(Font.bold(size: 13))
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .leading)
            .onAppear {
                self.updatePlaceholderVisibility()
            }
            .onChange(of: text){_ in
                self.updatePlaceholderVisibility()
            }
    }
    
    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder.localized())
                    .font(Font.bold(size: 13))
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
    
    private func updatePlaceholderVisibility() {
        self.showingPlaceholder = self.text.isEmpty
    }
}





struct CommentsHeader :View {
    let header : StudentChatDetailsM?
    var body: some View {
        HStack{
            let isTeacher = Helper.shared.getSelectedUserType() == .Teacher
            let imageurl = isTeacher ? header?.studentImage ?? "":header?.teacherImage ?? ""
            let imageURL : URL? = URL(string: Constants.baseURL+(imageurl).reverseSlaches())
            KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                .aspectRatio(contentMode: .fill)
                .frame(width: 50,height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading,spacing: 4){
                Text(isTeacher ? header?.studentName ?? "" : header?.teacherName ?? "")
                    .font(Font.bold(size:15))
                    .foregroundColor(.mainBlue)
                
                Text(header?.subjectName ?? "")
                    .font(Font.bold(size:14))
                    .foregroundColor(.bluegray400)
            }
            Spacer()
        }
        .padding([.top,.horizontal])
    }
}

struct CommentsList:View {
    let comments : [StudentLessonSessionCommentDetailsDto]
    
    var body: some View{
        ScrollViewReader { scrollView in
            //            if let array = student.comments {
            let messages = Array(comments.enumerated())
            
            ScrollView {
                ForEach(messages, id:\.element.hashValue){ index,comment in
                    let ismine = comment.fromName != nil
                    HStack{
                        if ismine {
                            Spacer()
                        }
                        VStack(alignment:ismine ? .trailing : .leading) {
                            HStack{
                                let imageurl = ismine ? comment.fromImage ?? "":comment.toImage ?? ""
                                let imageURL : URL? = URL(string: Constants.baseURL+(imageurl ).reverseSlaches())
                                KFImageLoader(url: imageURL, placeholder: Image("img_younghappysmi"))
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40,height: 40)
                                    .clipShape(Circle())
                                    .rotationEffect(Angle(degrees: comment.fromName != nil ? 180 : 0))
                                
                                HStack(spacing: 4){
                                    Text(ismine ? comment.fromName ?? "" : comment.toName ?? "")
                                        .font(Font.semiBold(size:15))
                                        .foregroundColor(.mainBlue)
                                        .rotationEffect(Angle(degrees: ismine ? 180 : 0))
                                    
                                    Text("\(comment.creationDate ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "d MMM , yyyy  HH:mm"))
                                        .font(Font.regular(size:10))
                                        .foregroundColor(.bluegray400)
                                        .rotationEffect(Angle(degrees: ismine ? 180 : 0))
                                }
                                Spacer()
                            }
                            .rotationEffect(Angle(degrees: ismine ? 180 : 0))
                            
                            Text(comment.comment ?? "")
                                .font(Font.bold(size:12))
                                .padding(10)
                                .foregroundColor(Color.black)
                                .background(ismine ? Color.myMsgBg : ColorConstants.Red400.opacity(0.08))
                                .cornerRadius(10)
                                .lineSpacing(5)
                        }
                        
                        if comment.fromName == nil {
                            Spacer()
                        }
                    }
                    .padding()
                    .id(index)
                    .onAppear {
                        if index == comments.count - 1 {
                            // Scroll to the bottom when the last item appears
                            scrollView.scrollTo(index, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}


struct MessageInputField: View {
    @Binding var comment: String
    let onSend: () -> Void
    
    var body: some View {
        HStack {
            MultilineTextField("Send a message", text: $comment, onCommit: onSend)
            
            Button(action: onSend) {
                Image("sendmessage")
            }
            .disabled(comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(RoundedCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
            .fill(.red400.opacity(0.08)))
    }
}

struct EmptyMessageBox: View {
    var body: some View {
        VStack{
            Spacer()
            Image("messagebox")
            Text("Message box is empty".localized())
                .font(Font.regular(size:14))
                .foregroundColor(.bluegray400)
                .padding()
            Spacer()
            
        }
    }
}

#Preview {
    EmptyMessageBox()
}
