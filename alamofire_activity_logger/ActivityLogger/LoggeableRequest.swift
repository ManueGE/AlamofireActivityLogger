//
//  LoggeableRequest.swift
//  alamofire_activity_logger
//
//  Created by Manu on 30/5/16.
//  Copyright © 2016 manuege. All rights reserved.
//
import Foundation
import Alamofire

private let appIsDebugMode = _isDebugAssertConfiguration()

/**
 Log levels
 
 `none`
 Do not log requests or responses.
 
 `all`
 Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
 
 `info`
 Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
 
 `error`
 Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
 */
public enum LogLevel {
    case none
    case all
    case info
    case error
}

/**
 Login options
 
 `onlyDebug`
 Only logs if the app is in Debug mode
 
 `jsonPrettyPrint`
 Prints the JSON body on request and response
 
 `includeSeparator`
 Include a separator string at the begining and end of each section
 */
public enum LogOption {
    case onlyDebug
    case jsonPrettyPrint
    case includeSeparator
    
    static var defaultOptions: [LogOption] {
        return [.onlyDebug, .jsonPrettyPrint, .includeSeparator]
    }
}

/**
 A struct that put together the relevant info from a Response
 */
public struct ResponseInfo {
    public var httpResponse: HTTPURLResponse?
    public var data: Data?
    public var error: Error?
    public var elapsedTime: TimeInterval
}

/**
 Make a Request conform this protocol to be able to log its request/response
 */
public protocol LoggeableRequest: AnyObject {
    
    /// The request sent
    var request: URLRequest? { get }
    
    /**
     Use this method to fetch the info needed to buld a `ResponseInfo` instance. Once the `ResponseInfo` has been build, you must call the `completion` parameter .
     - parameter completion: The block that must be called when the asynchronous process has finished.
     */
    func fetchResponseInfo(completion: @escaping (ResponseInfo) -> Void)
}

public extension LoggeableRequest {
    
    /**
     Log the request and response with the given level and options
     */
    public func log(level: LogLevel = .all, options: [LogOption] = LogOption.defaultOptions) -> Self {
        
        guard level != .none else {
            return self
        }
        
        let debugOption = options.contains(.onlyDebug)
        if debugOption && !appIsDebugMode {
            return self
        }
        
        Logger.logRequest(request: request, level: level, options: options)
        fetchResponseInfo { response in
            Logger.logResponse(request: self.request, response: response, level: level, options: options)
        }
        
        return self
    }
}


extension DataRequest: LoggeableRequest {
    public func fetchResponseInfo(completion: @escaping (ResponseInfo) -> Void) {
        
        responseData { (response) in
            
            var error: Error? = nil
            if case .failure(let e) = response.result {
                error = e
            }
            
            let logResponse = ResponseInfo(httpResponse: response.response,
                                           data: response.data,
                                           error: error,
                                           elapsedTime:  response.timeline.requestDuration)
            completion(logResponse)
        }
        
    }
}

extension DownloadRequest: LoggeableRequest {
    public func fetchResponseInfo(completion: @escaping (ResponseInfo) -> Void) {
        
        responseData { (response) in
            
            var error: Error? = nil
            var data: Data? = nil
            
            switch response.result {
            case let .success(value):
                data = value
            case let .failure(value):
                error = value
            }
            
            let logResponse = ResponseInfo(httpResponse: response.response,
                                           data: data,
                                           error: error,
                                           elapsedTime:  response.timeline.requestDuration)
            completion(logResponse)
        }
    }
}
