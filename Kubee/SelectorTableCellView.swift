//
//  SelectorTableCellView.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2015-06-28.
//  Copyright © 2015 Jacob Sikorski. All rights reserved.
//

import Cocoa

class SelectorTableCellView: NSTableCellView, NSTextFieldDelegate {
    fileprivate final let SELECTOR_TEXT_FIELD_IDENTIFIER = "selector"
    fileprivate final let REPLACE_TEXT_FIELD_IDENTIFIER = "replace"
    fileprivate final let WITH_TO_TEXT_FIELD_IDENTIFIER = "with"
    
    @IBOutlet weak var selectorTextField: NSTextField!
    @IBOutlet weak var replaceLabel: NSTextField!
    @IBOutlet weak var withLabel: NSTextField!
    @IBOutlet weak var transformationLabel: NSTextField!
    @IBOutlet weak var replaceTextField: NSTextField!
    @IBOutlet weak var withTextField: NSTextField!
    @IBOutlet weak var textTransformationMenu: NSMenu!
    @IBOutlet weak var lowercaseMenuItem: NSMenuItem!
    @IBOutlet weak var uppercaseMenuItem: NSMenuItem!
    @IBOutlet weak var capitalizeMenuItem: NSMenuItem!
    @IBOutlet weak var noneMenuItem: NSMenuItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lowercaseMenuItem.tag = TextTransformation.lowercase.hashValue + 1
        uppercaseMenuItem.tag = TextTransformation.uppercase.hashValue + 1
        capitalizeMenuItem.tag = TextTransformation.capitalize.hashValue + 1
        noneMenuItem.tag = TextTransformation.none.hashValue + 1
    }
    
    var filterComponent: FilterComponent? {
        didSet {
            let with = filterComponent!.settings.with
            let replace = filterComponent!.settings.replace
            
            self.selectorTextField.stringValue = filterComponent!.value
            
            if replace != nil {
                self.replaceTextField.stringValue = replace!
            } else {
                self.replaceTextField.stringValue = ""
            }
            
            if with != nil {
                self.withTextField.stringValue = with!
            } else {
                self.withTextField.stringValue = ""
            }
            
            self.textTransformationMenu!.performActionForItem(at: filterComponent!.settings.transformation.hashValue)
        }
    }
    
    func menu(_ menu: NSMenu, willHighlightItem item: NSMenuItem?) {
        if let tag = item?.tag, let transformation = TextTransformation(rawValue: tag - 1) {
            transformationSelected(transformation)
        }
    }
    
    func transformationSelected(_  transformation: TextTransformation) {
        filterComponent?.settings.transformation = transformation
        
        if let component = self.filterComponent {
            FileRenameManager.shared.updateFilterComponent(component)
        }
    }

    override func controlTextDidEndEditing(_ obj: Notification) {
        let textField = obj.object as! NSTextField
        let string = textField.stringValue;
        
        if textField.identifier == REPLACE_TEXT_FIELD_IDENTIFIER {
            filterComponent?.settings.replace = string
        } else if textField.identifier == WITH_TO_TEXT_FIELD_IDENTIFIER {
            filterComponent?.settings.with = string
        } else if textField.identifier == SELECTOR_TEXT_FIELD_IDENTIFIER {
            //TODO: Allow to edit this field
            return
        }
        
        FileRenameManager.shared.updateFilterComponent(filterComponent!)
    }
}
