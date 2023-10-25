//
//  RequestBuilder.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//
import Foundation
import Alamofire

// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// the Request URL
    var requestURL: URL {get}
    
    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }

    /// The parameters  used in the request , and encoding
    var parameter : parameterType {get}

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

public extension TargetType {
    var baseURL: URL {
        return URL(string: Constants.apiURL)!
    }
    // MARK: - Request URL
    var requestURL: URL {
        return baseURL.appendingPathComponent(path)
    }
    var headers: [String: String]? {
        var header = [String: String]()
//
//                header["Content-Type"] = "multipart/form-data"
//                header ["Accept"] = "text/plain"

        
        header["Content-Type"] = "application/json"
        header ["Accept"] = "text/plain"

        if let token = Helper.getUser()?.token {
        header["Authorization"] = "Bearer " + token
        }
        return header
    }
    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { .none }
}
public enum parameterType{
    case plainRequest
    case parameterRequest(Parameters:[String:Any],Encoding:ParameterEncoding)
    case BodyparameterRequest(Parameters:[String:Any],Encoding:ParameterEncoding)

}

/// Represents the status codes to validate through Alamofire.
public enum ValidationType {

    /// No validation.
    case none

    /// Validate success codes (only 2xx).
    case successCodes

    /// Validate success codes and redirection codes (only 2xx and 3xx).
    case successAndRedirectCodes

    /// Validate only the given status codes.
    case customCodes([Int])

    /// The list of HTTP status codes to validate.
    var statusCodes: [Int] {
        switch self {
        case .successCodes:
            return Array(200..<300)
        case .successAndRedirectCodes:
            return Array(200..<400)
        case .customCodes(let codes):
            return codes
        case .none:
            return []
        }
    }
}

extension ValidationType: Equatable {

    public static func == (lhs: ValidationType, rhs: ValidationType) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none),
             (.successCodes, .successCodes),
             (.successAndRedirectCodes, .successAndRedirectCodes):
            return true
        case (.customCodes(let code1), .customCodes(let code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
