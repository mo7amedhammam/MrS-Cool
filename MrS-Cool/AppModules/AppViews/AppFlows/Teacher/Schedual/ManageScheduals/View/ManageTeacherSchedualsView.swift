//
//  ManageTeacherSchedualsView.swift
//  MrS-Cool
//
//  Created by wecancity on 28/11/2023.
//

import SwiftUI

//@available(iOS 16.0, *)
struct ManageTeacherSchedualsView: View {
    //        @Environment(\.dismiss) var dismiss
    @StateObject var lookupsvm = LookUpsVM()
    //    @EnvironmentObject var signupvm : SignUpViewModel
    @StateObject var manageteacherschedualsvm = ManageTeacherSchedualsVM()
    
    @State var isPush = false
    @State var destination = AnyView(EmptyView())
//    @State private var isEditing = false
    
    @State var showFilter : Bool = false
    var selectedSubject:TeacherSubjectM?
    @ObservedObject private var keyboard = KeyboardResponder()

   @State var isStartDateBeforeEndDate = true
    private func handleStartEndDate(startDate: String?, endDate: String?) ->Bool {
//           if isStartDate {
               guard let startdate = startDate?.toDate(withFormat: "dd MMM yyyy"),
                     let enddate = endDate?.toDate(withFormat: "dd MMM yyyy") else {
                   return true
               }
               return startdate <= enddate
//           } else {
//               guard let ,
//                     let startDate = viewModel.startDate?.toDate(withFormat: "dd MMM yyyy") else {
//                   return
//               }
//               isStartDateBeforeEndDate = startDate <= newEndDate
//           }
       }
//   }
    @State var showConfirmDelete : Bool = false

    @State var date:String = "\(Date().formatDate(format: "dd MMM yyyy hh:mm a"))"

    var body: some View {
            VStack {
                CustomTitleBarView(title: "Manage my Schedules")
                
                GeometryReader { gr in
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{ // (Title - Data - Submit Button)
                            Group{
                                VStack(alignment: .leading, spacing: 0){
                                    // -- Data Title --
                                    Group{
                                        Text("Notice : All lesson schedules are in Egypt Standard Time: The current time in Egypt".localized())
                                        + Text("\( date )".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd MMM yyyy hh:mm a"))
                                    }
                                    .foregroundColor(ColorConstants.Red400)
                                    .font(Font.bold(size: 13))
                                    .lineSpacing(5)
                                    
                                    HStack(alignment: .top){
                                        SignUpHeaderTitle(Title: "Add New Schedule")
                                    }
                                    .padding(.top,5)
                                    // -- inputs --
                                    Group {
                                        CustomDropDownField(iconName:"img_vector",placeholder: "Day *", selectedOption: $manageteacherschedualsvm.day,options:lookupsvm.daysList,isvalid:manageteacherschedualsvm.isdayvalid)
                                        
                                        
                                        CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$manageteacherschedualsvm.startDate,startDate:Date(),endDate:manageteacherschedualsvm.endDate?.toDate(withFormat:"dd MMM yyyy hh:mm:ss") ?? nil,datePickerComponent:.date,isvalid:manageteacherschedualsvm.isstartDatevalid)
                                            .onChange(of: manageteacherschedualsvm.startDate){newval in
                                                guard newval != nil && manageteacherschedualsvm.endDate != nil else {return}
                                                isStartDateBeforeEndDate = handleStartEndDate(startDate:newval, endDate: manageteacherschedualsvm.endDate)

                                            }
                                        if !isStartDateBeforeEndDate{
                                            Text("End date must be greater than start date".localized())
                                                .foregroundColor(ColorConstants.Red400)
                                                .font(Font.regular(size: 10))
                                                .animation(.default)
                                        }

                                        CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$manageteacherschedualsvm.endDate,startDate:manageteacherschedualsvm.startDate?.toDate(withFormat:"dd MMM yyyy") ?? Date(),endDate:manageteacherschedualsvm.endDate?.toDate(withFormat:"dd MMM yyyy hh:mm:ss") ?? nil ,datePickerComponent:.date,Disabled:manageteacherschedualsvm.startDate == nil,isvalid:manageteacherschedualsvm.isendDatevalid)
                                            .onChange(of: manageteacherschedualsvm.endDate){newval in
                                            guard newval != nil && manageteacherschedualsvm.startDate != nil else {return}
                                                isStartDateBeforeEndDate = handleStartEndDate(startDate: manageteacherschedualsvm.startDate, endDate: newval)
                                        }
                                        
                                        CustomDatePickerField(iconName:"img_maskgroup7cl",rightIconName: "",placeholder: "Start Time", selectedDateStr:$manageteacherschedualsvm.startTime,timeZone: appTimeZone ?? TimeZone.current,datePickerComponent:.hourAndMinute,isvalid:manageteacherschedualsvm.isstartTimevalid)
                                        
                                        CustomDatePickerField(iconName:"img_maskgroup7cl",rightIconName: "",placeholder: "End Time", selectedDateStr:$manageteacherschedualsvm.endTime,timeZone:appTimeZone ?? TimeZone.current,datePickerComponent:.hourAndMinute,isvalid:manageteacherschedualsvm.isendTimevalid)
                                    }
                                    .padding([.top])
                                }
//                                .padding(.top,20)
                                
                                HStack {
                                    Group{
                                        CustomButton(Title: "Save" ,IsDisabled: .constant(false), action: {
                                            guard handleStartEndDate(startDate: manageteacherschedualsvm.startDate, endDate: manageteacherschedualsvm.endDate) else {return}
                                            manageteacherschedualsvm.CreateTeacherSchedual()
                                        })
                                        CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                            manageteacherschedualsvm.clearTeacherSchedual()
                                        })
                                    }
                                    .frame(width:120,height: 40)
                                    
                                }.padding(.vertical)
                                
                                HStack(){
                                    SignUpHeaderTitle(Title: "Manage My Schedules")
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
                            .padding(.horizontal)
                            
                            List(manageteacherschedualsvm.TeacherScheduals ?? [] ,id:\.self){ schedual in
                                ManageSchedualCell(model: schedual, deleteBtnAction: {
                                    manageteacherschedualsvm.error = .question( image: "img_group", message: "Are you sure you want to delete this item ?", buttonTitle: "Delete", secondButtonTitle: "Cancel", mainBtnAction: {
                                        manageteacherschedualsvm.DeleteTeacherSchedual(id: schedual.id)
                                    })
                                    showConfirmDelete.toggle()
                                })
                                .listRowSpacing(0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .padding(.vertical,-4)
                            }
//                            .scrollContentBackground(.hidden)
                            .listStyle(.plain)
                            .frame(height: gr.size.height/2)
                            Spacer()
                        }
                        .frame(minHeight: gr.size.height)
                    }
                }
                .onAppear(perform: {
                    lookupsvm.GetDays()
                    manageteacherschedualsvm.GetTeacherScheduals()
                    Task{date = await Helper.shared.GetEgyptDateTime()}
                })
            }
            .hideNavigationBar()
            .background(ColorConstants.Gray50.ignoresSafeArea().onTapGesture {
                hideKeyboard()
            })
            .onDisappear {
                manageteacherschedualsvm.cleanup()
            }
            .showHud(isShowing: $manageteacherschedualsvm.isLoading)
            .showAlert(hasAlert: $manageteacherschedualsvm.isError, alertType: manageteacherschedualsvm.error)
            .showAlert(hasAlert: $showConfirmDelete, alertType: manageteacherschedualsvm.error)

            .overlay{
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
                                    .font(Font.bold(size: 18))
                                    .foregroundColor(.mainBlue)
                                //                                            Spacer()
                            }
                            
                            ScrollView{
                                VStack{
                                    Group {
                                        CustomDropDownField(iconName:"img_vector",placeholder: "Day", selectedOption: $manageteacherschedualsvm.filterDay,options:lookupsvm.daysList)
                                        
                                        CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "Start Date", selectedDateStr:$manageteacherschedualsvm.filterStartDate,datePickerComponent:.date)
                                        
                                        CustomDatePickerField(iconName:"img_group148",rightIconName: "img_daterange",placeholder: "End Date", selectedDateStr:$manageteacherschedualsvm.filterEndDate,datePickerComponent:.date)
                                        
                                    }
                                    .padding(.top,5)
                                    
                                    Spacer()
                                    HStack {
                                        Group{
                                            CustomButton(Title:"Apply Filter",IsDisabled: .constant(false), action: {
                                                manageteacherschedualsvm.isFiltering = true
                                                manageteacherschedualsvm.GetTeacherScheduals()
                                                showFilter = false
                                            })
                                            
                                            CustomBorderedButton(Title:"Clear",IsDisabled: .constant(false), action: {
                                                manageteacherschedualsvm.isFiltering = false
                                                manageteacherschedualsvm.clearFilter()
                                                manageteacherschedualsvm.GetTeacherScheduals()
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
                        .frame(height:370)
    //                    .keyboardAdaptive()
                    }
                }
            }
        
        NavigationLink(destination: destination, isActive: $isPush, label: {})
        
    }
}

//@available(iOS 16.0, *)
#Preview {
    ManageTeacherSchedualsView()
//        .environmentObject(LookUpsVM())
//        .environmentObject(ManageTeacherSchedualsVM())
}
