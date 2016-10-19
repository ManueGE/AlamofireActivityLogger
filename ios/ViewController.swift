//
//  ViewController.swift
//  alamofire_activity_logger
//
//  Created by Manu on 30/5/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireActivityLogger

class ViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var prettyPrintSwitch: UISwitch!
    @IBOutlet var includeSeparatorSwift: UISwitch!
    
    @IBOutlet var views: [UIControl]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.removeAllSegments()
        
        Constants.levelsAndNames.enumerated().forEach { (index, element) in
            segmentedControl.insertSegment(withTitle: element.1,
                at: index,
                animated: false)
        }
        
        segmentedControl.selectedSegmentIndex = 1
    }
    
    // MARK: Actions
    @IBAction func didPressSuccess(_ sender: AnyObject) {
        performRequest(success: true)
    }

    @IBAction func didPressError(_ sender: AnyObject) {
        performRequest(success: false)
    }
    
    private func performRequest(success: Bool) {
        
        // Build options
        var options: [LogOption] = []
        
        if prettyPrintSwitch.isOn {
            options.append(.jsonPrettyPrint)
        }
        
        if includeSeparatorSwift.isOn {
            options.append(.includeSeparator)
        }
        
        // Level
        let level = Constants.levelsAndNames[segmentedControl.selectedSegmentIndex].0
        
        Helper.performRequest(success: success,
                              level: level,
                              options: options) { 
                                
                                self.setViewEnabled(true)
        }
    }
    
    // MARK: Helpers
    func setViewEnabled(_ enabled: Bool) {
        views.forEach { $0.isEnabled = enabled }
    }
    
}


