//
//  Tools.swift
//  alamofire_activity_logger
//
//  Created by Manuel García-Estañ on 2/11/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import Foundation

internal let appIsDebugMode = _isDebugAssertConfiguration()

// MARK: - Levels

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

// MARK: - Options

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
    
    public static var defaultOptions: [LogOption] {
        return [.onlyDebug, .jsonPrettyPrint, .includeSeparator]
    }
}

// MARK: - Printer

/**
 The different phases of a request that can be printed
 
 `request`
 The request when it is sent
 
 `response`
 The response when it is received; includes a parameter `success` that inform if the response has finished succesfully
*/
public enum Phase {
    case request
    case response(success: Bool)
    
    /// Tells if there is an error in the phase
    public var isError: Bool {
        switch self {
        case let .response(success):
            return !success
        case .request:
            return false
        }
    }
}

/// Instances that conforms with `Printer` protocol are able to print the information from a given request
public protocol Printer {
    
    /**
     This method is called when the printer is requested to print a string. Use it to print the information in the way you need.
     - parameter string: The string to be printed.
     - parameter phase: The phase of the request that needs to be printed
     */
    func print(_ string: String, phase: Phase)
}

/// A printer that just use the native `Swift.print` function to print the string.
public struct NativePrinter: Printer {
    
    /// Creates a new instance
    public init() {}
    
    public func print(_ string: String, phase: Phase) {
        Swift.print(string)
    }
}
