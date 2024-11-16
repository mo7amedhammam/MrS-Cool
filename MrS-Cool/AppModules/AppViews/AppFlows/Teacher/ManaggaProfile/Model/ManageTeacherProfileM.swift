//
//  ManageTeacherProfileM.swift
//  MrS-Cool
//
//  Created by wecancity on 12/11/2023.
//

// MARK: - ManageTeacherProfileM
struct ManageTeacherProfileM: Codable {
    var id: Int?
    var code: String?
    var image: String?
    var mobile: String?
    var email: String?
    var birthdate: String?
    var countryID, governorateID: Int?
    var statusName: String?
    var statusID: Int?
    var rate: Float?
    var creationDate, countryName, governorateName, cityName,genderName: String?
    var name: String?
    var cityID, genderID: Int?
    var isTeacher: Bool?
    var teacherBio: String?
    var bankName, iban: String?
    var bankId: Int?

    enum CodingKeys: String, CodingKey {
        case id, code, image, mobile, email, birthdate
        case countryID = "countryId"
        case governorateID = "governorateId"
        case statusName
        case statusID = "statusId"
        case rate, creationDate, countryName, governorateName, cityName, name,genderName
        case cityID = "cityId"
        case genderID = "genderId"
        case isTeacher, teacherBio
        case bankName,bankId,iban
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
