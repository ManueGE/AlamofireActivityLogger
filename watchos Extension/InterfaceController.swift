//
//  InterfaceController.swift
//  watchOS Extension
//
//  Created by Manuel García-Estañ on 19/10/16.
//  Copyright © 2016 manuege. All rights reserved.
//

import WatchKit
import Foundation

import Alamofire
import AlamofireActivityLogger


class InterfaceController: WKInterfaceController {
    
    var prettyPrint = true
    var addSeparator = true
    var selectedLevel = LogLevel.all
    
    @IBOutlet var levelPicker: WKInterfacePicker!
    @IBOutlet var prettyPrintSwitch: WKInterfaceSwitch!
    @IBOutlet var separatorSwitch: WKInterfaceSwitch!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        prettyPrintSwitch.setOn(prettyPrint)
        separatorSwitch.setOn(addSeparator)
        
        let items: [WKPickerItem] = Constants.levelsAndNames.map { (value) in
            let item = WKPickerItem()
            item.title = value.1
            
            return item;
        }
        
        levelPicker.setItems(items)
        levelPicker.setSelectedItemIndex(1)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func didChangePrettySwitch(_ value: Bool) {
        prettyPrint = value
    }
    
    @IBAction func didChangeSeparatorSwitch(_ value: Bool) {
        addSeparator = value
    }
    
    @IBAction func didChangeLevelPicker(_ value: Int) {
        selectedLevel = Constants.levelsAndNames[value].0
    }
    
    @IBAction func didPressSuccess() {
        performRequest(success: true)
    }
    
    @IBAction func didPressFail() {
        performRequest(success: false)
    }
    
    private func performRequest(success: Bool) {
        
        // Build options
        var options: [LogOption] = []
        
        if prettyPrint {
            options.append(.jsonPrettyPrint)
        }
        
        if addSeparator {
            options.append(.includeSeparator)
        }
        
        
        Helper.performRequest(success: success,
                              level: selectedLevel,
                              options: options) {
        }
 
    }
    
}
