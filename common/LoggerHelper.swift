//
//  LoggerHelper.swift
//  alamofire_activity_logger
//
//  Created by Manuel García-Estañ on 19/10/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireActivityLogger

private struct URLConstants {
    static let successURL = "http://www.mocky.io/v2/574c43dc100000760eed69ca"
    static let failURL = "http://www.mocky.io/v2/574c440d100000860eed69cb"
}

struct Constants {
    static let levelsAndNames: [(LogLevel, String)] = [
        (.none, "None"),
        (.all, "All"),
        (.info, "Info"),
        (.error, "Error")
    ]
}

struct Helper {
    
    static func performRequest(success: Bool, level: LogLevel, options: [LogOption], completion: @escaping () -> Void) {
        
        let url = success ? URLConstants.successURL : URLConstants.failURL;
        
        request(url, method: .get)
            .validate()
            .log(level: level, options: options, printer: NativePrinter())
            .responseData { (response) in
                completion()
        }
    }
}

struct MyPrinter: Printer {
    func print(_ string: String, phase: Phase) {
        if phase.isError {
            Swift.print("🍎\n\(string)")
        }
        else {
            Swift.print("🍏\n\(string)")
        }
    }
}
