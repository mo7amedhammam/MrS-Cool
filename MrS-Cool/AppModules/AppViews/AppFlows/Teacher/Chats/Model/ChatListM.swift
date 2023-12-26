//
//  ChatListM.swift
//  MrS-Cool
//
//  Created by wecancity on 26/12/2023.
//


// MARK: - ChatListM
struct ChatListM: Codable,Hashable {
    var studentName: String?
    var lessonNum: Int?
    var teacherLessonSessionsDtos: [TeacherLessonSessionsDto]?
}

// MARK: - TeacherLessonSessionsDto
struct TeacherLessonSessionsDto: Codable,Hashable {
    var bookTeacherLessonSessionDetailID: Int?
    var lessonName, creationDate: String?

    enum CodingKeys: String, CodingKey {
        case bookTeacherLessonSessionDetailID = "bookTeacherLessonSessionDetailId"
        case lessonName, creationDate
    }
}
