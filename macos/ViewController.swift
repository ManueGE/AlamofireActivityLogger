//
//  ViewController.swift
//  macos
//
//  Created by Manuel García-Estañ on 19/10/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {

    @IBOutlet weak var popUpButton: NSPopUpButton!
    @IBOutlet weak var prettyPrintButton: NSButton!
    @IBOutlet weak var separatorButton: NSButton!
    @IBOutlet weak var successButton: NSButton!
    @IBOutlet weak var failureButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpButton.removeAllItems()
        
        Constants.levelsAndNames.enumerated().forEach { (_, element) in
            popUpButton.addItem(withTitle: element.1)
        }
        
        popUpButton.selectItem(at: 1)
    }

    @IBAction func didPressSuccess(_ sender: AnyObject) {
        performRequest(success: true)
    }
    
    @IBAction func didPressFailure(_ sender: AnyObject) {
        performRequest(success: false)
    }
    
    private func performRequest(success: Bool) {
        
        // Build options
        var options: [LogOption] = []
        
        if prettyPrintButton.state == NSOnState {
            options.append(.jsonPrettyPrint)
        }
        
        if separatorButton.state == NSOnState {
            options.append(.includeSeparator)
        }
        
        // Level
        let index = popUpButton.indexOfSelectedItem
        let level = Constants.levelsAndNames[index].0
        
        Helper.performRequest(success: success,
                              level: level,
                              options: options) {
        }
    }
}

