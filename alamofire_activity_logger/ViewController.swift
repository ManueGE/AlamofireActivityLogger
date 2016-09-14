//
//  ViewController.swift
//  alamofire_activity_logger
//
//  Created by Manu on 30/5/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import UIKit
import Alamofire

let successURL = "http://www.mocky.io/v2/574c43dc100000760eed69ca"
let failURL = "http://www.mocky.io/v2/574c440d100000860eed69cb"

class ViewController: UIViewController {
    
    let levels: [(LogLevel, String)] = [
        (.None, "None"),
        (.All, "All"),
        (.Info, "Info"),
        (.Error, "Error")
    ]
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var prettyPrintSwitch: UISwitch!
    @IBOutlet var includeSeparatorSwift: UISwitch!
    
    @IBOutlet var views: [UIControl]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.removeAllSegments()
        levels.enumerated().forEach { (index, element) in
            segmentedControl.insertSegment(withTitle: element.1,
                at: index,
                animated: false)
        }
        segmentedControl.selectedSegmentIndex = 1
    }
    
    // MARK: Actions
    @IBAction func didPressSuccess(_ sender: AnyObject) {
        performRequest(withURL: successURL)
    }

    @IBAction func didPressError(_ sender: AnyObject) {
        performRequest(withURL: failURL)
    }
    
    private func performRequest(withURL URL: String) {
        
        // Build options
        var options: [LogOption] = []
        
        if prettyPrintSwitch.isOn {
            options.append(.JSONPrettyPrint)
        }
        
        if includeSeparatorSwift.isOn {
            options.append(.IncludeSeparator)
        }
        
        // Level
        let level = levels[segmentedControl.selectedSegmentIndex].0
        
        self.setViewEnabled(false)
        request(URL, method: .get)
            .validate()
            .log(level: level, options: options)
            .responseData { (response) in
                self.setViewEnabled(true)
        }
    }
    
    // MARK: Helpers
    func setViewEnabled(_ enabled: Bool) {
        views.forEach { $0.isEnabled = enabled }
    }
    
    private func logResponse(request: URLRequest?, httpResponse: HTTPURLResponse?, data: Data?, error: Error?, level: LogLevel, options: [LogOption]) {}
        
}


