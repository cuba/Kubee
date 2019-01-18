//
//  RenameViewController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
import Cocoa

class RenameViewController: NSViewController {
    enum TextFieldType: String {
        case filter = "filter"
        case replace = "replace"
        
        var persistanceKey: String {
            switch self {
            case .filter: return Persistance.filter.key
            case .replace: return Persistance.replace.key
            }
        }
        
        func parsedString(from components: [FilterComponent]) -> ParsedString {
            switch self {
            case .filter: return Filter(components: components)
            case .replace: return ReplaceFilter(components: components)
            }
        }
        
        func save(string: String) {
            Persistor.pack(string, key: persistanceKey)
        }
        
        func load() -> String {
            return Persistor.string(persistanceKey) ?? ""
        }
    }
    
    @IBOutlet weak var filterLabel: NSTextField!
    @IBOutlet weak var renameToLabel: NSTextField!
    @IBOutlet weak var filterTextField: NSTextField!
    @IBOutlet weak var renameToTextField: NSTextField!
    @IBOutlet weak var filterErrorIndicator: ErrorIndicatorView!
    @IBOutlet weak var renameToErrorIndicator: ErrorIndicatorView!
    
    private var lastValidFilterString: String?
    private var lastValidRenameToString: String?
    private var filterErrorInfo: String?
    private var renameToErrorInfo: String?
    
    fileprivate var errorPopover = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare error popover
        errorPopover.contentViewController = ViewControllerProvider.filterError.viewController
        filterErrorIndicator.mouseOverDelegate = self
        renameToErrorIndicator.mouseOverDelegate = self
        filterErrorIndicator.title = Text.Title.parsingError.localized
        renameToErrorIndicator.title = Text.Title.parsingError.localized
        
        // Set labels
        filterLabel.stringValue = Text.TextField.filter.label
        filterLabel.placeholderString = Text.TextField.filter.placeholder
        renameToLabel.stringValue = Text.TextField.replace.label
        renameToLabel.placeholderString = Text.TextField.replace.placeholder
        
        // Load previous filter
        filterTextField.stringValue = TextFieldType.filter.load()
        renameToTextField.stringValue = TextFieldType.replace.load()
        
        // Set text field identifiers
        filterTextField.identifier = TextFieldType.filter.rawValue
        renameToTextField.identifier = TextFieldType.replace.rawValue
        
        parse(textField: filterTextField)
        parse(textField: renameToTextField)
    }
}

extension RenameViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        let textField = obj.object as! NSTextField
        parse(textField: textField, testOnly: true)
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let textField = obj.object as! NSTextField
        parse(textField: textField, testOnly: false)
    }
    
    fileprivate func parse(textField: NSTextField, testOnly: Bool = false) {
        guard let identifier = textField.identifier else { return }
        guard let type = TextFieldType(rawValue: identifier) else { return }
        
        let string = textField.stringValue
        let parsed = parse(string: string, for: type)
        guard !testOnly else { return }
        
        if let filter = parsed as? Filter {
            FileRenameManager.shared.set(filter)
        } else if let replaceFilter = parsed as? ReplaceFilter {
            FileRenameManager.shared.set(replaceFilter)
        }
    }
    
    private func parse(string: String, for type: TextFieldType) -> ParsedString? {
        hideError(for: type)
        let parser = FilterParser(string: string)
        
        do {
            let components = try parser.parse()
            var parsed = type.parsedString(from: components)
            
            guard parsed.validate() && parsed.error == nil else {
                showError(parsed.error, for: type)
                return nil
            }
            
            type.save(string: string)
            return parsed
        } catch let error {
            showError(error, for: type)
        }
        
        return nil
    }
    
    private func hideError(for type: TextFieldType) {
        switch type {
        case .filter:
            filterErrorIndicator.isHidden = true
        case .replace:
            renameToErrorIndicator.isHidden = true
        }
        
        errorPopover.close()
    }
    
    private func showError(_ error: Error?, for type: TextFieldType) {
        switch type {
        case .filter: showFilterError(error)
        case .replace: showReplaceFilterError(error)
        }
    }
    
    private func showFilterError(_ error: Error?) {
        filterErrorIndicator.isHidden = false
        filterErrorIndicator.title = Text.Title.parsingError.localized
        filterErrorIndicator.message = error?.localizedDescription
    }
    
    private func showReplaceFilterError(_ error: Error?) {
        renameToErrorIndicator.isHidden = false
        renameToErrorIndicator.title = Text.Title.parsingError.localized
        renameToErrorIndicator.message = error?.localizedDescription
    }
}

extension RenameViewController: ErrorIndicatorMouseOverDelegate {
    func errorIndicatorMouseEntered(_ errorIndicatorView :ErrorIndicatorView) {
        if !errorPopover.isShown {
            let rect = errorIndicatorView.bounds
            let viewController = errorPopover.contentViewController as! FilterErrorViewController
            viewController.errorTitle = errorIndicatorView.title
            viewController.errorMessage = errorIndicatorView.message
            errorPopover.show(relativeTo: rect, of: errorIndicatorView, preferredEdge: NSRectEdge.maxX)
        }
    }
    
    func errorIndicatorMouseExited(_ errorIndicatorView :ErrorIndicatorView) {
        errorPopover.close()
    }
}
