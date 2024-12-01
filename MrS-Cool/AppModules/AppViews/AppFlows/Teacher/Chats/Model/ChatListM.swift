//
//  ChatListM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//

import Foundation


// MARK: - ChatListM - // teacher
struct ChatListM: Codable,Hashable {
//    var id = UUID()
    
    var studentName: String?
    var studentImage : String?
    var lessonNum: Int?
    var teacherLessonSessionsDtos: [TeacherLessonSessionsDto]?
    
    enum CodingKeys: String, CodingKey {
        case studentName = "studentName"
        case studentImage
        case lessonNum,teacherLessonSessionsDtos
    }
}

// MARK: - TeacherLessonSessionsDto -
struct TeacherLessonSessionsDto: Codable,Hashable,Identifiable {
    var id: Int?
    var lessonName, creationDate: String?
    enum CodingKeys: String, CodingKey {
        case id = "bookTeacherLessonSessionDetailId"
        case lessonName, creationDate
    }
}

// MARK: - ChatDetailsM -
struct ChatDetailsM: Codable,Hashable,Identifiable {
    var id: Int?
    var teacherName, studentName, subjectName: String?
    var comments: [CommentDetailsDto]?

    enum CodingKeys: String, CodingKey {
        case id = "bookTeacherLessonSessionDetailId"
        case teacherName, studentName, subjectName
        case comments = "teacherLessonSessionCommentDetailsDtos"
    }
}

// MARK: - TeacherLessonSessionCommentDetailsDto -
struct CommentDetailsDto: Codable,Hashable {
    var comment, fromName, toName, fromImage: String?
    var toImage, creationDate: String?
}


// MARK: - StudentChatListM -
struct StudentChatListM: Codable,Hashable {
    var studentId:Int?
    var teacherName: String?
    var teacherImage : String?
    var lessonNum,teacherSubjectAcademicSemesterYearId: Int?
    var teacherLessonSessionsDtos: [TeacherLessonSessionsDto]?
    
    enum CodingKeys: String, CodingKey {
        case studentId
        case teacherName = "teacherName"
        case teacherImage = "teacherImage"
        case lessonNum,teacherLessonSessionsDtos
        case teacherSubjectAcademicSemesterYearId
    }
}

// MARK: - StudentLessonDetailsM -
struct StudentChatDetailsM: Codable,Hashable {
    var bookTeacherLessonSessionDetailID,teacherSubjectAcademicSemesterYearId: Int?
    var teacherName, teacherImage, studentName, studentImage: String?
    var subjectName: String?
    var comments: [StudentLessonSessionCommentDetailsDto]?

    enum CodingKeys: String, CodingKey {
        case bookTeacherLessonSessionDetailID = "bookTeacherLessonSessionDetailId",teacherSubjectAcademicSemesterYearId
        case teacherName, teacherImage, studentName, studentImage, subjectName
        case comments = "teacherLessonSessionCommentDetailsDtos"
    }
}

// MARK: - StudentLessonSessionCommentDetailsDto
struct StudentLessonSessionCommentDetailsDto: Codable,Hashable {
    var comment, fromName, toName: String?
    var fromImage,toImage, creationDate: String?
}

