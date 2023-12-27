//
//  ChatListM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//

import Foundation


// MARK: - ChatListM
struct ChatListM: Codable,Hashable {
//    var id = UUID()
    
    var studentName: String?
    var studentImage : String?
    var lessonNum: Int?
    var teacherLessonSessionsDtos: [TeacherLessonSessionsDto]?
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case studentName = "studentName"
//        case studentImage, lessonNum,teacherLessonSessionsDtos
//    }
}

// MARK: - TeacherLessonSessionsDto
struct TeacherLessonSessionsDto: Codable,Hashable,Identifiable {
    var id: Int?
    var lessonName, creationDate: String?
    enum CodingKeys: String, CodingKey {
        case id = "bookTeacherLessonSessionDetailId"
        case lessonName, creationDate
    }
}
