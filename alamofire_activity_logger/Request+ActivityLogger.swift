//
//  Request+ActivityLogger.swift
//  alamofire_activity_logger
//
//  Created by Manu on 30/5/16.
//  Copyright © 2016 manuege. All rights reserved.
//
import Foundation
import Alamofire
import ObjectiveC

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

private let NullString = "(null)"
private let SeparatorString = "*******************************"

public protocol LogeableRequest: AnyObject {
    func logResponse(level: LogLevel, options: [LogOption]) -> Self
    var request: URLRequest? { get }
}

public extension LogeableRequest {
    
    /**
     Log the request and response with the given level and options
     */
    public func log(level: LogLevel = .All, options: [LogOption] = LogOption.defaultOptions) -> Self {
        
        guard level != .None else {
            return self
        }
        
        let debugOption = options.contains(.OnlyDebug)
        if debugOption && !AppIsDebugMode {
            return self
        }
    
        return logRequest(level: level, options: options).logResponse(level: level, options: options)
    }
    
    private func logRequest(level: LogLevel, options: [LogOption]) -> Self {
        
        guard let request = request else {
            return self
        }
        
        let method = request.httpMethod!
        let url = request.url?.absoluteString ?? NullString
        let headers = prettyPrintedString(from: request.allHTTPHeaderFields) ?? NullString
        
        // separator
        let openSeparator = options.contains(.IncludeSeparator) ? "\(SeparatorString)\n" : ""
        let closeSeparator = options.contains(.IncludeSeparator) ? "\n\(SeparatorString)" : ""
        
        switch (level) {
        case .All:
            let prettyPrint = options.contains(.JSONPrettyPrint)
            let body = string(from: request.httpBody, prettyPrint: prettyPrint) ?? NullString
            print("\(openSeparator)[Request] \(method) '\(url)':\n\n[Headers]\n\(headers)\n\n[Body]\n\(body)\(closeSeparator)")
            
        case .Info:
            print("\(openSeparator)[Request] \(method) '\(url)'\(closeSeparator)")
            
        default:
            break
        }
        
        return self
    }
}

extension DataRequest: LogeableRequest {
    public func logResponse(level: LogLevel, options: [LogOption]) -> Self {
        responseData { (response) in
            
            var error: Error? = nil
            if case .failure(let e) = response.result {
                error = e
            }
            
            logResponsee(request: response.request,
                         httpResponse: response.response,
                         data: response.data,
                         error: error,
                         elapsedTime:  response.timeline.requestDuration,
                         level: level,
                         options: options)
        }
        
        return self
    }
}

extension DownloadRequest: LogeableRequest {
    public func logResponse(level: LogLevel, options: [LogOption]) -> Self {
        responseData { (response) in
            
            var error: Error? = nil
            var data: Data? = nil
            
            switch response.result {
            case let .success(value):
                data = value
            case let .failure(value):
                error = value
            }
            
            logResponsee(request: response.request,
                         httpResponse: response.response,
                         data: data,
                         error: error,
                         elapsedTime:  response.timeline.requestDuration,
                         level: level,
                         options: options)
        }
        
        return self
    }
}



// MARK: Helpers
private let AppIsDebugMode = _isDebugAssertConfiguration()

private func string(from data: Data?, prettyPrint: Bool) -> String? {
    
    guard let data = data else {
        return nil
    }
    
    var response: String? = nil
    
    if prettyPrint,
        let json = try? JSONSerialization.jsonObject(with: data, options: []),
        let prettyString = prettyPrintedString(from: json) {
        response = prettyString
    }
        
    else if let dataString = String.init(data: data, encoding: .utf8) {
        response = dataString
    }
    
    return response
}

private func prettyPrintedString(from json: Any?) -> String? {
    guard let json = json else {
        return nil
    }
    
    var response: String? = nil
    
    if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
        let dataString = String.init(data: data, encoding: .utf8) {
        response = dataString
    }
    
    return response
}

func logResponsee(request: URLRequest?, httpResponse: HTTPURLResponse?, data: Data?, error: Error?, elapsedTime: TimeInterval, level: LogLevel, options: [LogOption]) {
    
    guard level != .None else {
        return
    }
    
    if request == nil && httpResponse == nil {
        return
    }
    
    // options
    let prettyPrint = options.contains(.JSONPrettyPrint)
    
    // request
    let requestMethod = request?.httpMethod ?? NullString
    let requestUrl = request?.url?.absoluteString ?? NullString
    
    // response
    let responseStatusCode = httpResponse?.statusCode ?? 0
    let responseHeaders = prettyPrintedString(from: httpResponse?.allHeaderFields) ?? NullString
    let responseData = string(from: data, prettyPrint: prettyPrint) ?? NullString
    
    // time
    let elapsedTimeString = String(format: "[%.4f s]", elapsedTime)
    
    // separator
    let openSeparator = options.contains(.IncludeSeparator) ? "\(SeparatorString)\n" : ""
    let closeSeparator = options.contains(.IncludeSeparator) ? "\n\(SeparatorString)" : ""
    
    // log
    let responseTitle = error == nil ? "Response" : "Response Error"
    switch level {
    case .All:
        print("\(openSeparator)[\(responseTitle)] \(responseStatusCode) '\(requestUrl)' \(elapsedTimeString):\n\n[Headers]:\n\(responseHeaders)\n\n[Body]\n\(responseData)\(closeSeparator)")
    case .Info:
        print("\(openSeparator)[\(responseTitle)] \(responseStatusCode) '\(requestUrl)' \(elapsedTimeString)\(closeSeparator)")
    case .Error:
        if let error = error {
            print("\(openSeparator)[\(responseTitle)] \(requestMethod) '\(requestUrl)' \(elapsedTimeString) s: \(error)\(closeSeparator)")
        }
    default:
        break
    }
}
