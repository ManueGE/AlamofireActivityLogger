//
//  ViewController.swift
//  alamofire_activity_logger
//
//  Created by Manu on 30/5/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let levels: [(LogLevel, String)] = [
        (.none, "None"),
        (.all, "All"),
        (.info, "Info"),
        (.error, "Error")
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
        performRequest(withURL: URLConstants.successURL)
    }

    @IBAction func didPressError(_ sender: AnyObject) {
        performRequest(withURL: URLConstants.failURL)
    }
    
    private func performRequest(withURL URL: String) {
        
        // Build options
        var options: [LogOption] = []
        
        if prettyPrintSwitch.isOn {
            options.append(.jsonPrettyPrint)
        }
        
        if includeSeparatorSwift.isOn {
            options.append(.includeSeparator)
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


