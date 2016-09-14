//
//  Logger.swift
//  alamofire_activity_logger
//
//  Created by Manuel García-Estañ on 14/9/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import Foundation

private let NullString = "(null)"
private let SeparatorString = "*******************************"

/**
 A set of static methods which logs request and responses
 */
internal struct Logger {
    private static func string(from data: Data?, prettyPrint: Bool) -> String? {
        
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
    
    private static func prettyPrintedString(from json: Any?) -> String? {
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
    
    internal static func logResponse(request: URLRequest?, response: ResponseInfo, level: LogLevel, options: [LogOption]) {
        
        guard level != .None else {
            return
        }
        
        let httpResponse = response.httpResponse
        let data = response.data
        let elapsedTime = response.elapsedTime
        let error = response.error
        
        if request == nil && response.httpResponse == nil {
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
    
    internal static func logRequest(request: URLRequest?, level: LogLevel, options: [LogOption]) {
        
        guard let request = request else {
            return
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
    }
}
