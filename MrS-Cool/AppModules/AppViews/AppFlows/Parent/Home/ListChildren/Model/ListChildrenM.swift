//
//  ListChildrenM.swift
//  MrS-Cool
//
//  Created by wecancity on 17/03/2024.
//

//import Foundation

// MARK: - ChildrenM -
struct ChildrenM: Codable,Hashable {
    var id: Int?
    var code, image, academicYearEducationLevelName: String?
    var academicYearEducationLevelID: Int?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id, code, image, academicYearEducationLevelName
        case academicYearEducationLevelID = "academicYearEducationLevelId"
        case name
    }
}
