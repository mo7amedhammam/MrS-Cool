//
//  StudentTabBarVM.swift
//  MrS-Cool
//
//  Created by wecancity on 14/01/2024.
//

import Combine
import SwiftUI

class StudentTabBarVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    //    MARK: --- inputs ---
    @Published var ispush : Bool = false
    @Published var destination = AnyView(StudentEditProfileView())
    
    
    //    MARK: --- outpust ---
    @Published var isLoading : Bool?
    @Published var isError : Bool = false
    //    @Published var error: Error?
    @Published var error: AlertType = .error(title: "", image: "", message: "", buttonTitle: "", secondButtonTitle: "")
    
    //    @Published var isTeacherHasSubjects: Bool = false
//    @Published var letsPreview : Bool = false

//    @Published var StudentSubjects : [StudentSubjectsM]? = [StudentSubjectsM.init(id: 0, name: "arabic", image: "tab1"),StudentSubjectsM.init(id: 1, name: "arabic1", image: "tab2"),StudentSubjectsM.init(id: 2, name: "arabic2", image: "tab2")]
//    @Published var SelectedStudentSubjects : StudentSubjectsM = StudentSubjectsM()
//    
//    @Published var StudentMostViewedLessons : [StudentMostViewedLessonsM] = [StudentMostViewedLessonsM.init(id: 0, lessonName: "grammer", subjectName: "arabic", lessonBrief: "brief 0", availableTeacher: 12, minPrice: 220, maxPrice: 550)]
//    @Published var SelectedStudentMostViewedLesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM()
//
//    @Published var StudentMostBookedLessons : [StudentMostViewedLessonsM] = [StudentMostViewedLessonsM.init(id: 0, lessonName: "grammer", subjectName: "arabic", lessonBrief: "brief 2", availableTeacher: 12, minPrice: 220, maxPrice: 550)]
//    @Published var SelectedStudentMostBookedLesson : StudentMostViewedLessonsM = StudentMostViewedLessonsM()
//
//    @Published var StudentMostViewedSubjects : [StudentMostViewedSubjectsM] = [StudentMostViewedSubjectsM.init(id: 0, subjectName: "subjects name", image: "image", subjectBrief: "brief", lessonsCount: 3, teacherCount: 12) ]
//    @Published var SelectedStudentMostViewedSubject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
//
//    @Published var StudentMostBookedsubjects : [StudentMostViewedSubjectsM] = [StudentMostViewedSubjectsM.init(id: 0, subjectName: "subjects name", image: "image", subjectBrief: "brief", lessonsCount: 3, teacherCount: 12)]
//    @Published var SelectedStudentMostBookedSubject : StudentMostViewedSubjectsM = StudentMostViewedSubjectsM()
//
//    @Published var StudentMostViewedTeachers : [StudentMostViewedTeachersM] = [StudentMostViewedTeachersM.init(id: 0, teacherName: "teacher name", teacherImage: "image", teacherLessonId: 2, teacherSubjectId: 3, duration: 120, teacherReview: 5, price: 220, teacherRate: 3.5) ]
//    @Published var SelectedStudentMostViewedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()
//
//    @Published var StudentMostRatedTeachers : [StudentMostViewedTeachersM] = [StudentMostViewedTeachersM.init(id: 0, teacherName: "teacher name", teacherImage: "image", teacherLessonId: 2, teacherSubjectId: 3, duration: 120, teacherReview: 8, price: 220, teacherRate: 3.5)]
//    @Published var SelectedStudentMostRatedTeachers : StudentMostViewedTeachersM = StudentMostViewedTeachersM()


    init()  {
//        GetStudentSubjects()
//        DispatchQueue.global(qos: .background).async {[weak self] in
//            guard let self = self else{return}
//            // Perform the background task here
//            GetStudentLessons(mostType: .mostviewed)
//            GetStudentLessons(mostType: .mostBooked)
//
//            GetStudentMostSubjects(mostType: .mostviewed)
//            GetStudentMostSubjects(mostType: .mostBooked)
//            
//            GetStudentTeachers(mostType: .mostviewed)
//            GetStudentTeachers(mostType: .topRated)
//        }
    }
}





