//
//  ViewController.swift
//  tvos
//
//  Created by Manuel García-Estañ on 19/10/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireActivityLogger

class TVViewController: UIViewController {

    @IBOutlet var levelSegmentedControl: UISegmentedControl!
    @IBOutlet var prettySegmentedControl: UISegmentedControl!
    @IBOutlet var separatorSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelSegmentedControl.removeAllSegments()
        
        Constants.levelsAndNames.enumerated().forEach { (index, element) in
            levelSegmentedControl.insertSegment(withTitle: element.1,
                                           at: index,
                                           animated: false)
        }
        
        levelSegmentedControl.selectedSegmentIndex = 1
        prettySegmentedControl.selectedSegmentIndex = 0
        separatorSegmentedControl.selectedSegmentIndex = 0
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
        
        if prettySegmentedControl.selectedSegmentIndex == 0 {
            options.append(.jsonPrettyPrint)
        }
        
        if separatorSegmentedControl.selectedSegmentIndex == 0 {
            options.append(.includeSeparator)
        }
        
        // Level
        let level = Constants.levelsAndNames[levelSegmentedControl.selectedSegmentIndex].0
        
        Helper.performRequest(success: success,
                              level: level,
                              options: options) {
                                
        }
    }
}

