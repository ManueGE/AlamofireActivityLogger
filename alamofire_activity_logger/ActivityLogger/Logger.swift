//
//  Logger.swift
//  alamofire_activity_logger
//
//  Created by Manuel García-Estañ on 14/9/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import Foundation

private let nullString = "(null)"
private let separatorString = "*******************************"

/**
 A set of static methods which logs request and responses
 */
internal struct Logger {
    
    internal static func logRequest(request: URLRequest?, level: LogLevel, options: [LogOption], printer: Printer) {
        
        guard let request = request else {
            return
        }
        
        let method = request.httpMethod!
        let url = request.url?.absoluteString ?? nullString
        let headers = prettyPrintedString(from: request.allHTTPHeaderFields) ?? nullString
        
        // separator
        let openSeparator = options.contains(.includeSeparator) ? "\(separatorString)\n" : ""
        let closeSeparator = options.contains(.includeSeparator) ? "\n\(separatorString)" : ""
        
        switch (level) {
        case .all:
            let prettyPrint = options.contains(.jsonPrettyPrint)
            let body = string(from: request.httpBody, prettyPrint: prettyPrint) ?? nullString
            printer.print("\(openSeparator)[Request] \(method) '\(url)':\n\n[Headers]\n\(headers)\n\n[Body]\n\(body)\(closeSeparator)", phase: .request)
            
        case .info:
            printer.print("\(openSeparator)[Request] \(method) '\(url)'\(closeSeparator)", phase: .request)
            
        default:
            break
        }
    }
    
    internal static func logResponse(request: URLRequest?, response: ResponseInfo, level: LogLevel, options: [LogOption], printer: Printer) {
        
        guard level != .none else {
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
        let prettyPrint = options.contains(.jsonPrettyPrint)
        
        // request
        let requestMethod = request?.httpMethod ?? nullString
        let requestUrl = request?.url?.absoluteString ?? nullString
        
        // response
        let responseStatusCode = httpResponse?.statusCode ?? 0
        let responseHeaders = prettyPrintedString(from: httpResponse?.allHeaderFields) ?? nullString
        let responseData = string(from: data, prettyPrint: prettyPrint) ?? nullString
        
        // time
        let elapsedTimeString = String(format: "[%.4f s]", elapsedTime)
        
        // separator
        let openSeparator = options.contains(.includeSeparator) ? "\(separatorString)\n" : ""
        let closeSeparator = options.contains(.includeSeparator) ? "\n\(separatorString)" : ""
        
        // log
        let success = (error == nil)
        let responseTitle = success ? "Response" : "Response Error"
        switch level {
        case .all:
            printer.print("\(openSeparator)[\(responseTitle)] \(responseStatusCode) '\(requestUrl)' \(elapsedTimeString):\n\n[Headers]:\n\(responseHeaders)\n\n[Body]\n\(responseData)\(closeSeparator)", phase: .response(success: success))
        case .info:
            printer.print("\(openSeparator)[\(responseTitle)] \(responseStatusCode) '\(requestUrl)' \(elapsedTimeString)\(closeSeparator)", phase: .response(success: success))
        case .error:
            if let error = error {
                printer.print("\(openSeparator)[\(responseTitle)] \(requestMethod) '\(requestUrl)' \(elapsedTimeString) s: \(error)\(closeSeparator)", phase: .response(success: success))
            }
        default:
            break
        }
    }
    
    // MARK: - Private helpers
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

}
