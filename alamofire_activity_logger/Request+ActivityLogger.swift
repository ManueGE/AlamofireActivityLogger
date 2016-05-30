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

var ElapsedTimeHandle: UInt8 = 0

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
 
 `JSONPrettyPrint`
 Prints the JSON body on request and response 
 */
public enum LogOptions {
    case JSONPrettyPrint
    case IncludeSeparator
}

private let NullString = "(null)"
private let SeparatorString = "*******************************"

extension Request {
    
    /** 
     Log the request and response with the given level and options. It just works if the app is in debug.
     */
    public func debugLog(level: LogLevel = .All, options: [LogOptions] = [.JSONPrettyPrint]) -> Self {
        if AppIsDebugMode {
            return log(level, options: options)
        }
        else {
            return self
        }
    }
    
    /**
     Log the request and response with the given level and options
     */
    public func log(level: LogLevel = .All, options: [LogOptions] = [.JSONPrettyPrint]) -> Self {
        
        guard level != .None else {
            return self
        }
        
        startDate = NSDate()
        return logRequest(level, options: options).logResponse(level, options: options)
    }
    
    private func logRequest(level: LogLevel, options: [LogOptions]) -> Self {
        
        guard let request = request else {
            return self
        }
        
        let method = request.HTTPMethod!
        let url = request.URL?.absoluteString ?? NullString
        let headers = prettyPrintedStringFromJSON(request.allHTTPHeaderFields) ?? NullString
        
        let separator = options.contains(.IncludeSeparator) ? "\(SeparatorString)\n" : ""
        
        switch (level) {
        case .All:
            let prettyPrint = options.contains(.JSONPrettyPrint)
            let body = stringFromData(request.HTTPBody, prettyPrint: prettyPrint) ?? NullString
            print("\(separator)[Request] \(method) '\(url)':\n\n[Headers]\n\(headers)\n\n[Body]\n\(body)\(separator)")
            
        case .Info:
            print("\(separator)[Request] \(method) '\(url)'\(separator)")
            
        default:
            break
        }
        
        return self
    }
    
    private func logResponse(level: LogLevel, options: [LogOptions]) -> Self {
        return response(completionHandler: { (request, httpResponse, data, error) in
            self.logResponse(request, httpResponse: httpResponse, data: data, error: error, level: level, options: options)
        })
    }
    
    private func logResponse(request: NSURLRequest?, httpResponse: NSHTTPURLResponse?, data: NSData?, error: NSError?, level: LogLevel, options: [LogOptions]) {
        
        guard level != .None else {
            return
        }
        
        if request == nil && httpResponse == nil {
            return
        }
        
        // options
        let prettyPrint = options.contains(.JSONPrettyPrint)
        
        // request
        let requestMethod = request?.HTTPMethod ?? NullString
        let requestUrl = request?.URL?.absoluteString ?? NullString
        
        // response
        let responseStatusCode = httpResponse?.statusCode ?? 0
        let responseHeaders = prettyPrintedStringFromJSON(httpResponse?.allHeaderFields) ?? NullString
        let responseData = stringFromData(data, prettyPrint: prettyPrint) ?? NullString
        
        // time
        let elapsedTime = String(format: "[%.4f s]", self.elapsedTime)
        
        // separator
        let separator = options.contains(.IncludeSeparator) ? "\(SeparatorString)\n" : ""
        
        // log
        if let error = error {
            switch level {
            case .None:
                break
            default:
                print("\(separator)[Response Error] \(requestMethod) '\(requestUrl)' \(elapsedTime) s: \(error)\(separator)")
            }
        }
            
        else {
            switch level {
            case .All:
                print("\(separator)[Response] \(responseStatusCode) '\(requestUrl)' \(elapsedTime):\n\n[Headers]:\n\(responseHeaders)\n\n[Body]\n\(responseData)\(separator)")
            case .Info:
                print("\(separator)[Response] \(responseStatusCode) '\(requestUrl)' \(elapsedTime)\(separator)")
            default:
                break
            }
        }
    }
    
    // MARK: Elapsed time
    var startDate: NSDate {
        get {
            return objc_getAssociatedObject(self, &ElapsedTimeHandle) as? NSDate ?? NSDate()
        }
        set {
            objc_setAssociatedObject(self, &ElapsedTimeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var elapsedTime: NSTimeInterval {
        return NSDate().timeIntervalSinceDate(startDate)
    }
}

// MARK: Helpers
private let AppIsDebugMode = _isDebugAssertConfiguration()

private func stringFromData(data: NSData?, prettyPrint: Bool) -> String? {
    
    guard let data = data else {
        return nil
    }
    
    var response: String? = nil
    
    if prettyPrint,
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
        let prettyString = prettyPrintedStringFromJSON(json) {
        response = prettyString
    }
        
    else if let dataString = String.init(data: data, encoding: NSUTF8StringEncoding) {
        response = dataString
    }
    
    return response
}

private func prettyPrintedStringFromJSON(json: AnyObject?) -> String? {
    guard let json = json else {
        return nil
    }
    
    var response: String? = nil
    
    if let data = try? NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted),
        dataString = String.init(data: data, encoding: NSUTF8StringEncoding) {
        response = dataString
    }
    
    return response
}
