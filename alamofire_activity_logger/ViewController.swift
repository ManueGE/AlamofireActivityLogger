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
        levels.enumerate().forEach { (index, element) in
            segmentedControl.insertSegmentWithTitle(element.1,
                atIndex: index,
                animated: false)
        }
        segmentedControl.selectedSegmentIndex = 1
    }
    
    // MARK: Actions
    @IBAction func didPressSuccess(sender: AnyObject) {
        performRequest(withURL: successURL)
    }
    
    @IBAction func didPressError(sender: AnyObject) {
        performRequest(withURL: failURL)
    }
    
    private func performRequest(withURL URL: String) {
        
        // Build options
        var options: [LogOption] = []
        
        if prettyPrintSwitch.on {
            options.append(.JSONPrettyPrint)
        }
        
        if includeSeparatorSwift.on {
            options.append(.IncludeSeparator)
        }
        
        // Level
        let level = levels[segmentedControl.selectedSegmentIndex].0
        
        self.setViewEnabled(false)
        request(.GET, URL)
            .validate()
            .log(level, options: options)
            .responseData { (response) in
                self.setViewEnabled(true)
        }
    }
    
    // MARK: Helpers
    func setViewEnabled(enabled: Bool) {
        views.forEach( { $0.enabled = enabled } )
    }
}


