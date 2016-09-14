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
 
 `None`
 Do not log requests or responses.
 
 `All`
 Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
 
 `Info`
 Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
 
 `Error`
 Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
 */
public enum LogLevel {
    case None
    case All
    case Info
    case Error
}

/**
 Login options
 
 `OnlyDebug`
 Only logs if the app is in Debug mode
 
 `JSONPrettyPrint`
 Prints the JSON body on request and response
 
 `IncludeSeparator`
 Include a separator string at the begining and end of each section
 */
public enum LogOption {
    case OnlyDebug
    case JSONPrettyPrint
    case IncludeSeparator
    
    static var defaultOptions: [LogOption] {
        return [.OnlyDebug, .JSONPrettyPrint, .IncludeSeparator]
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
    public func log(level: LogLevel = .All, options: [LogOption] = LogOption.defaultOptions) -> Self {
        
        guard level != .None else {
            return self
        }
        
        let debugOption = options.contains(.OnlyDebug)
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
