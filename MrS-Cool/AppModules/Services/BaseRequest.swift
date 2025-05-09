//
//  BaseRequest.swift
//  Health
//
//  Created by wecancity on 03/09/2023.
//
//import Foundation
//import UIKit
import Alamofire
import Combine

func buildparameter(paramaters:parameterType)->([String:Any],ParameterEncoding){
    switch paramaters{
    case .plainRequest:
        return ([:],URLEncoding.default)
    case .parameterRequest(Parameters: let Parameters, Encoding: let Encoding):
        return(Parameters,Encoding)
    case .BodyparameterRequest(Parameters: let Parameters, Encoding: let Encoding):
        return(Parameters,Encoding)
        
            case .parameterdGetRequest(Parameters: let Parameters, Encoding: let Encoding):
                return(Parameters,Encoding)
        
    }
}


@available(iOS 13.0, *)
final class BaseNetwork{
    static let shared = BaseNetwork()
    
    // MARK: --- (Combine) CAll API with Future ---
//    // more modern and aligned with Swift's async/await concurrency model
//    static func CallApi<T: TargetType, M: Codable>(_ target: T, _ Model: M.Type) -> AnyPublisher<M, NetworkError> {
//        return Future<M, NetworkError> { promise in
//            let totalStartTime = Date()
//            
//            // Step 1: Network Check
////            let networkCheckStartTime = Date()
//            guard Helper.shared.isConnectedToNetwork() else {
////                print("Network check time: \(Date().timeIntervalSince(networkCheckStartTime)) seconds")
//                return promise(.failure(.noConnection))
//            }
////            print("Network check time: \(Date().timeIntervalSince(networkCheckStartTime)) seconds")
//            
//            // Step 2: Prepare Parameters and Headers
////            let preparationStartTime = Date()
//            let parameters = buildparameter(paramaters: target.parameter)
//            let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
////            print("Parameter and header preparation time: \(Date().timeIntervalSince(preparationStartTime)) seconds")
//            
//            print(target.requestURL)
//            print(parameters)
//
//            // Step 3: Make the Network Request
//            let requestStartTime = Date()
//            
//            AF.request(target.requestURL, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: headers)
//                .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
//                    
//                    let requestTime = Date().timeIntervalSince(requestStartTime)
//                    print("Network request time: \(requestTime) seconds")
//                    
//                    // Step 4: Decode and Handle Response
//                    let decodingStartTime = Date()
//                    
//                    if response.response?.statusCode == 401 {
//                        print("Total time: \(Date().timeIntervalSince(totalStartTime)) seconds")
//                        promise(.failure(.unauthorized(code: response.response?.statusCode ?? 0, error: NetworkError.expiredTokenMsg.errorDescription ?? "")))
//                    } else {
//                        switch response.result {
//                        case .success(let model):
////                            print("Decoding time: \(Date().timeIntervalSince(decodingStartTime)) seconds")
////                            print("Total time: \(Date().timeIntervalSince(totalStartTime)) seconds")
//                            promise(.success(model))
//                        case .failure(let error):
////                            print("Decoding time: \(Date().timeIntervalSince(decodingStartTime)) seconds")
////                            print("Total time: \(Date().timeIntervalSince(totalStartTime)) seconds")
//                            promise(.failure(.unknown(code: 0, error: error.localizedDescription)))
//                        }
//                    }
//                }
//        }.eraseToAnyPublisher()
//    }
    static func CallApi<T: TargetType, M: Codable>(_ target: T, _ modelType: M.Type) -> AnyPublisher<M, NetworkError> {
        return Future<M, NetworkError> { promise in
            let startTime = Date()
            
            // Step 1: Check Network Connection
            guard Helper.shared.isConnectedToNetwork() else {
                return promise(.failure(.noConnection))
            }
            
            // Step 2: Prepare Parameters and Headers
            let parameters = buildparameter(paramaters: target.parameter)
            let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
            
            // Log request details for debugging
            print("Request URL: \(target.requestURL)")
            print("Parameters: \(parameters)")
            
            // Step 3: Make the Network Request
            AF.request(target.requestURL,
                       method: target.method,
                       parameters: parameters.0,
                       encoding: parameters.1,
                       headers: headers)
                .validate(statusCode: 200..<502) // Automatically validate acceptable response codes
                .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
                    let elapsedTime = Date().timeIntervalSince(startTime)
                    print("Total API call time: \(elapsedTime) seconds")
                    
                    switch response.result {
                    case .success(let model):
                        promise(.success(model))
                        
                    case .failure(let error):
                        handleError(response: response, error: error, promise: promise)
                    }
                }
        }.eraseToAnyPublisher()
    }

    // MARK: - Error Handling Helper
    private static func handleError<M>(response: AFDataResponse<M>, error: AFError, promise: @escaping (Result<M, NetworkError>) -> Void) {
        if let statusCode = response.response?.statusCode {
            if statusCode == 401 {
                promise(.failure(.unauthorized(
                    code: statusCode,
                    error: NetworkError.expiredTokenMsg.errorDescription ?? "Unauthorized"
                )))
            } else {
                promise(.failure(.unknown(
                    code: statusCode,
                    error: error.localizedDescription
                )))
            }
        } else {
            promise(.failure(.unknown(
                code: 0,
                error: error.localizedDescription
            )))
        }
    }
    
//    private let session: Session
//        
//        private init() {
//            let configuration = URLSessionConfiguration.default
//            configuration.timeoutIntervalForRequest = 30
//            configuration.timeoutIntervalForResource = 30
//            self.session = Session(configuration: configuration)
//        }
//    
//
//    func request<T: TargetType, M: Codable>(_ target: T, _ Model: M.Type) async throws -> M {
//        guard Helper.shared.isConnectedToNetwork() else {
//            throw NetworkError.noConnection
//        }
//        
//        let url = try target.asURL()
//        
//        let parameters = buildparameter(paramaters: target.parameter)
//        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
//        
//        print(target.requestURL)
//        print(target.method)
//        print(parameters)
//        print(headers ?? [:])
//
//        let response = try await session.request(
//            url,
//            method: target.method,
//            parameters: parameters.0,
//            encoding: parameters.1,
//            headers: headers
//        )
//        .validate(statusCode: 200..<502) // Validate status codes in the 200 range
//        .serializingDecodable(M.self) // Decode to BaseResponse
//        .value
//        
//        print("response : \n", response)
//        
//        // Check the success property of the BaseResponse
////        if let success = response.success, success == false {
////            throw NetworkError.unknown(
////                code: response.messageCode ?? 0,
////                error: response.message ?? "Unknown error"
////            )
////        }
//        
//        // Return the data if there's no error
////        guard let data = response.data else {
////            throw NetworkError.unknown(
////                code: response.messageCode ?? 0,
////                error: response.message ?? "No data received"
////            )
////        }
//        
//        return response
//    }


    private let session: URLSession = {
           let config = URLSessionConfiguration.default
           config.timeoutIntervalForRequest = 30
           config.timeoutIntervalForResource = 30
           return URLSession(configuration: config)
       }()
       
       private var activeTasks: [URLSessionTask] = []
       private let taskQueue = DispatchQueue(label: "network.tasks.queue")
       
    func cancelAllRequests() {
           taskQueue.sync {
               activeTasks.forEach { $0.cancel() }
               activeTasks.removeAll()
           }
       }
       
        func request<T: TargetType, M: Codable>(_ target: T, _ modelType: M.Type) async throws -> M {
           // Check for cancellation first
           try Task.checkCancellation()
           
           guard Helper.shared.isConnectedToNetwork() else {
               throw NetworkError.noConnection
           }
           
           let url = try target.asURL()
           var request = URLRequest(url: url)
           request.httpMethod = target.method.rawValue
           
           // Add headers
           target.headers?.forEach { key, value in
               request.addValue(value, forHTTPHeaderField: key)
           }
           
           // Handle parameters
           let params = buildparameter(paramaters: target.parameter).0
           let parameters = buildparameters(paramaters: buildparameter(paramaters: target.parameter).0)
            switch (target.method, parameters.1) {
                case (.get, _), (_, .urlEncoding):
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    components?.queryItems = parameters.0?.map {
                        URLQueryItem(name: $0.key, value: "\($0.value)")
                    }
                    if let urlWithQuery = components?.url {
                        request.url = urlWithQuery
                    }
                default:
                    if let params = parameters.0 {
                        request.httpBody = try JSONSerialization.data(withJSONObject: params)
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                }
            
           // Check cancellation again before making request
           try Task.checkCancellation()
           
           let task = session.dataTask(with: request)
           
           taskQueue.sync {
               activeTasks.append(task)
           }
           
           do {
               let (data, response) = try await session.data(for: request)

               taskQueue.sync {
                   activeTasks.removeAll { $0 == task }
               }
               
               guard let httpResponse = response as? HTTPURLResponse else {
                   throw NetworkError.invalidJSON("invalid response")
               }
               
               guard (200..<502).contains(httpResponse.statusCode) else {
                   throw NetworkError.serverError(code:  httpResponse.statusCode, error: "serverError")
               }
               
               return try JSONDecoder().decode(M.self, from: data)
           } catch {
//               taskQueue.sync {
//                   activeTasks.removeAll { $0 == task }
//               }
               
               if let urlError = error as? URLError, urlError.code == .cancelled {
                   throw NetworkError.requestCancelled
               }
               throw error
           }
       }

    // Helper enum to match Alamofire's ParameterEncoding
    enum ParameterEncoding {
        case jsonEncoding
        case urlEncoding
        // Add other encoding types as needed
    }

    // Modified buildparameter to return URLSession-compatible types
    private func buildparameters(paramaters: [String: Any]?) -> (parameters: [String: Any]?, encoding: ParameterEncoding) {
        // Your existing parameter building logic
        // Return appropriate encoding type based on your needs
        return (paramaters, .jsonEncoding) // Default to JSON encoding
    }



    
    
    // combine -> return anypublisher
//        static func callApi<T: TargetType, M: Codable>(_ target: T, _ modelType: M.Type) -> AnyPublisher<M, Error> {
//            guard Helper.shared.isConnectedToNetwork() else {
//                   return Fail(error: NetworkError.noConnection)
//                       .eraseToAnyPublisher()
//               }
//    
//               let parameters = buildparameter(paramaters: target.parameter)
//               let headers = HTTPHeaders(target.headers ?? [:])
//    
//               let (requestURL, method, parametersDict, encoding) = (target.requestURL, target.method, parameters.0, parameters.1)
//               print("url",requestURL)
//               print("parameters",parametersDict)
//               print("headers",headers )
//    
//               return AF.request(requestURL, method: method, parameters: parametersDict, encoding: encoding, headers: headers)
//                   .publishDecodable(type: M.self, decoder: JSONDecoder())
//                   .tryMap { response in
//                       if let model = response.value {
//                           return model
//                       } else {
//                           if let error = response.error {
//                               let responsecode = response.response?.statusCode ?? 0
//                               if responsecode == 401 {
//                                   throw NetworkError.unauthorized(code: responsecode, error: NetworkError.expiredTokenMsg.localizedDescription)
//                               } else {
//                                   throw NetworkError.unknown(code: responsecode, error: error.localizedDescription)
//                               }
//                           } else {
//                               throw NetworkError.unknown(code: 0, error: "No response data")
//                           }
//                       }
//                   }
//                   .receive(on: DispatchQueue.main) // Receive on the main thread if you want to update UI
//                   .eraseToAnyPublisher()
//           }
    
    // async throw using withCheckedThrowingContinuation
//        static func asyncCallApi<T: TargetType, M: Codable>(_ target: T,_ modelType: M.Type) async throws -> M {
//            guard Helper.shared.isConnectedToNetwork() else {
//                throw NetworkError.noConnection
//            }
//    
//            let parameters = buildparameter(paramaters: target.parameter)
//            let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
//    
//            let (requestURL, method, parametersarr, encoding) = (target.requestURL, target.method, parameters.0, parameters.1)
//            print("url",requestURL)
//            print("parameters",parametersarr)
//            print("headers",headers ?? [:])
//    
//            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<M, Error>) in
//                AF.request(requestURL, method: method, parameters: parametersarr, encoding: encoding, headers: headers)
//                    .responseDecodable(of: M.self, decoder: JSONDecoder()) { dataResponse in
//                        do {
//                            guard let responsecode = dataResponse.response?.statusCode else {
//                                throw NetworkError.unknown(code: 0, error: "No response code")
//                            }
//    
//                            switch dataResponse.result {
//                            case .success(let model):
//                                continuation.resume(returning: model)
//                            case .failure(let error):
//                                if responsecode == 401 {
//                                    continuation.resume(throwing: NetworkError.unauthorized(code: responsecode, error: NetworkError.expiredTokenMsg.localizedDescription))
//                                } else {
//                                    continuation.resume(throwing: NetworkError.unknown(code: responsecode, error: error.localizedDescription))
//                                }
//                            }
//                        } catch {
//                            continuation.resume(throwing: error)
//                        }
//                    }
//            }
//    
//            return response
//        }
    
    
    
    // closure call back
    //    static func callApi<T: TargetType, M: Codable>(
    //        _ target: T,
    //        _ modelType: M.Type,
    //        completion: @escaping (Result<M, NetworkError>) -> Void
    //    ) {
    //        guard Helper.isConnectedToNetwork() else{
    //            completion(.failure(NetworkError.noConnection))
    //            return
    //        }
    //
    //        let parameters = buildparameter(paramaters: target.parameter)
    //        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
    //        print(headers ?? [:])
    //
    //        AF.request(target.requestURL, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: headers)
    //            .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
    //                guard let responsecode = response.response?.statusCode else{return}
    //                switch response.result {
    //                case .success(let model):
    //                    completion(.success(model))
    //                case .failure(let error):
    //                    if responsecode == 401{
    //                        completion(.failure(.unauthorized(code: responsecode, error: NetworkError.expiredTokenMsg.localizedDescription)))
    //                    }else{
    //                        completion(.failure(.unknown(code: responsecode, error: error.localizedDescription)))
    //                    }
    //                }
    //
    //            }
    //    }
    
    // MARK: - (Combine - Future) Multipart API with parameters
    // Define a new method to upload a file as multipart data using Combine
    static func uploadApi<T: TargetType, M: Codable>(
        _ target: T,
        _ Model: M.Type,
        progressHandler: @escaping (Double) -> Void
    ) -> AnyPublisher<M, NetworkError> {
        return Future<M, NetworkError> { promise in
            guard Helper.shared.isConnectedToNetwork() else {
                promise(.failure(.noConnection))
                return
            }
            
            let parameters = buildparameter(paramaters: target.parameter)
            var headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
            headers?["Content-Type"] = "multipart/form-data"
            
            print(target.requestURL)
            print(target.method)
            print(parameters)
            print(headers ?? [:])
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in parameters.0 {
                        // -- image --
                        if let tempImg = value as? UIImage {
                            if let data = tempImg.jpegData(compressionQuality: 0.5), (tempImg.size.width) > 0 {
                                multipartFormData.append(data, withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                            }
                        }
                        // -- pdf --
                        //"group.wecancityagency.MrS-Cool"
                        else if let tempURL = value as? URL {

                            guard tempURL.startAccessingSecurityScopedResource() else { return }
                            defer { tempURL.stopAccessingSecurityScopedResource() }

                            // Check if the file exists
                            if FileManager.default.fileExists(atPath: tempURL.path) {
                            print("File exists at path:", tempURL.path)
                                do{
                                    // Check if can read file
                                    let data = try Data(contentsOf: tempURL)
                                    
                                    multipartFormData.append(data, withName: key, fileName: tempURL.lastPathComponent, mimeType: "application/pdf")
                                }catch{
                                    print("can't read file", error)
                                }
                        } else {
                            // Handle file not found or incorrect path
                            print("File does not exist at path:", tempURL.path)
                        }
                            
                        }
                        // -- parameters --
                        // Handle other parameter types (String, Int, NSArray)
                        else {
                            if let tempData = "\(value)".data(using: .utf8) {
                                multipartFormData.append(tempData, withName: key)
                            }
                        }
                    }
                },
                to: target.requestURL,
                method: target.method,
                headers: headers
            )
            .uploadProgress { progress in
                let completedProgress = progress.fractionCompleted
                progressHandler(completedProgress)
                print("progress: \(completedProgress * 100)%")
            }
            .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
                print(response)
                switch response.result {
                case .success(let model):
                    promise(.success(model))
                case .failure(let error):
                    promise(.failure(.unknown(code: 0, error: error.localizedDescription)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
    
    // MARK: - (Completion handler) CAll API with promiseKit
    //    static func uploadApi<T: TargetType, M: Codable>(
    //        _ target: T,
    //        _ Model: M.Type,
    //        progressHandler: @escaping (Double) -> Void,
    //        completion: @escaping (Result<M, NetworkError>) -> Void
    //    ) {
    //        guard Helper.isConnectedToNetwork() else{
    //            completion(.failure(NetworkError.noConnection))
    //            return
    //        }
    //        let parameters = buildparameter(paramaters: target.parameter)
    //        let headers: HTTPHeaders? = Alamofire.HTTPHeaders(target.headers ?? [:])
    //        print(target.requestURL)
    //        print(target.method)
    //        print(parameters)
    //        print(headers ?? [:])
    //
    //        AF.upload(multipartFormData: { (multipartFormData) in
    //            for (key , value) in parameters.0 {
    //
    //                if let tempImg = value as? UIImage {
    //                    if let data = tempImg.jpegData(compressionQuality: 0.9), (tempImg.size.width ) > 0 {
    //
    ////                    if let data = tempImg.pngData(), (tempImg.size.width ) > 0 {
    //                        // Be careful and put the file name in withName parameter
    //                        multipartFormData.append(data, withName: key , fileName: "file.jpeg", mimeType: "image/jpeg")
    //                    }
    //                }
    //                else if let tempURL = value as? URL {
    //                    if let data = try? Data(contentsOf: tempURL), tempURL.pathExtension.lowercased() == "pdf" {
    //                        multipartFormData.append(data, withName: key, fileName: "file.pdf", mimeType: "application/pdf")
    //                    }
    //                }
    //                else if let tempStr = value as? String {
    //                    multipartFormData.append(tempStr.data(using: .utf8)!, withName: key)
    //                }
    //                else if let tempInt = value as? Int {
    //                    multipartFormData.append("\(tempInt)".data(using: .utf8)!, withName: key)
    //                }
    //                else if let tempArr = value as? NSArray {
    //                    tempArr.forEach { element in
    //                        let keyObj = key + "[]"
    //                        if let string = element as? String {
    //                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
    //                        } else if let num = element as? Int {
    //                            let value = "\(num)"
    //                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
    //                        }
    //                    }
    //                }
    //            }
    //        },
    //                  to: target.requestURL,
    //                  method: target.method,
    //                  headers: headers
    //        )
    //        .uploadProgress { progress in
    //            let completedProgress = progress.fractionCompleted
    //            progressHandler(completedProgress)
    //            print("progress: %.0f%% \(completedProgress)")
    //        }
    //        .responseDecodable(of: M.self, decoder: JSONDecoder()) { response in
    //            print(response)
    //            switch response.result {
    //            case .success(let model):
    //                completion(.success(model))
    //            case .failure(let error):
    //                completion(.failure(.unknown(code: 0, error: error.localizedDescription)))
    //            }
    //        }
    //    }
    
    // -- Download File --
    static func downloadFile(
        from sourceURL: URL,
        to destinationURL: URL,
        progressHandler: @escaping (Double) -> Void,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let destination: DownloadRequest.Destination = { _, _ in
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(sourceURL, to: destination)
            .downloadProgress { progress in
                let completedProgress = progress.fractionCompleted
                progressHandler(completedProgress)
            }
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    static func downloadFileWithProgress(
           from sourceURL: URL,
           to destinationURL: URL
       ) -> AnyPublisher<Double, Error> {
           let destination: DownloadRequest.Destination = { _, _ in
               return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
           }
           
           let subject = PassthroughSubject<Double, Error>()
           
           AF.download(sourceURL, to: destination)
               .downloadProgress { progress in
                   subject.send(progress.fractionCompleted)
               }
               .response { response in
                   switch response.result {
                   case .success:
                       subject.send(completion: .finished)
                   case .failure(let error):
                       subject.send(completion: .failure(error))
                   }
               }
           
           return subject.eraseToAnyPublisher()
       }
    
}



public enum NetworkError: Error, Equatable {
    case expiredTokenMsg
    case badURL(_ error: String)
    case apiError(code: Int, error: String)
    case invalidJSON(_ error: String)
    case unauthorized(code: Int, error: String)
    case badRequest(code: Int, error: String)
    case serverError(code: Int, error: String)
    case noResponse(_ error: String)
    case unableToParseData(_ error: String)
    case unknown(code: Int, error: String)
    case noConnection
    case requestCancelled

}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL(let errorMsg):
            return NSLocalizedString("Bad Url", comment: errorMsg)
        case .apiError(_, let errorMsg):
            return errorMsg
        case .invalidJSON(let errorMsg):
            return NSLocalizedString("00", comment: errorMsg)
        case .unauthorized(_, let errorMsg):
            return errorMsg
        case .badRequest(_, let errorMsg):
            return errorMsg
        case .serverError(_, let errorMsg):
            return errorMsg
        case .noResponse(let errorMsg):
            return errorMsg
        case .unableToParseData(let errorMsg):
            return errorMsg
        case .unknown(_, let errorMsg):
            return errorMsg
        case .expiredTokenMsg:
            return "tokenExpired"
        case .noConnection:
            return "noConnection"
        case .requestCancelled:
            return "request Cancelled"
            
        }
    }
}

struct BGDecoder {
    
    static func decode<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
}
