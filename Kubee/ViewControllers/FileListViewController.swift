//
//  FileListViewController.swift
//  Kubee
//
//  Created by Jacob Sikorski on 2017-04-08.
//  Copyright © 2017 Studio MDE Inc. All rights reserved.
//

import Foundation
import Cocoa

class FileListViewController: NSViewController {
    fileprivate final let FILE_ERROR_VIEW_NIB_NAME = "FilterErrorView"
    
    @IBOutlet weak var fileListTableView: NSTableView!
    
    fileprivate(set) var fileList: FileList
    fileprivate var errorPopover = NSPopover()
    
    var preparedUndoManager: AnyObject {
        return undoManager?.prepare(withInvocationTarget: self) as AnyObject
    }
    
    required init?(coder: NSCoder) {
        fileList = FileList()
        super.init(coder: coder)
        
        NSApplication.shared().nextResponder = self
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(addAction) {
            return true
        } else if menuItem.action == #selector(removeAction) {
            return self.fileListTableView.selectedRowIndexes.count > 0
        } else if menuItem.action == #selector(removeAllAction) {
            return fileList.files.count > 0
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filterErrorViewController = FilterErrorViewController(nibName: FILE_ERROR_VIEW_NIB_NAME, bundle: nil)
        errorPopover.contentViewController = filterErrorViewController
        
        fileListTableView.delegate = self;
        fileListTableView.dataSource = self;
        TableCellViewProvider.file.registerCell(for: fileListTableView)
        
        FileRenameManager.shared.register(filterChangeDelegate: self)
        FileRenameManager.shared.register(replaceFilterChangeDelegate: self)
    }
    
    @IBAction func addAction(_ sender: AnyObject){
        let openPanel: NSOpenPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = true
        
        if openPanel.runModal() == NSModalResponseOK {
            let urls = openPanel.urls
            addUrls(urls)
        }
        
        undoManager?.removeAllActions()
    }
    
    @IBAction func removeAction(_ sender: AnyObject) {
        let indexes = self.fileListTableView.selectedRowIndexes
        removeFilesAtIndexes(indexes)
        undoManager?.removeAllActions()
    }
    
    @IBAction func removeAllAction(_ sender: AnyObject) {
        let indexes = IndexSet(integersIn: NSMakeRange(0, fileList.count).toRange()!)
        removeFilesAtIndexes(indexes)
        undoManager?.removeAllActions()
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        let fileManager = FileManager.default
        var indexes: [Int] = []
        
        for index in 0..<fileList.count {
            let file = fileList.files[index]
            
            if !fileManager.fileExists(atPath: file.path) {
                indexes.append(index)
            }
        }
        
        removeFilesAtIndexes(IndexSet(indexes))
        undoManager?.removeAllActions()
    }
    
    @IBAction func renameAction(_ sender: AnyObject) {
        refreshAction(sender)
        
        if fileList.count > 0 {
            undoManager?.beginUndoGrouping()
            
            for index in 0..<fileList.count {
                renameFile(at: index, undo: false)
            }
            
            undoManager?.setActionName(Text.Label.renameFiles.localized)
            undoManager?.endUndoGrouping()
        }
    }
    
    func renameFile(at index: Int, undo: Bool = false) {
        preparedUndoManager.renameFile(at: index, undo: !undo)
        fileList.renameFile(at: index, undo: undo)
        let columnIndexes = IndexSet([0])
        let rowIndexes = IndexSet([index])
        fileListTableView.reloadData(forRowIndexes: rowIndexes, columnIndexes: columnIndexes)
    }
}

//MARK: FileManagment

extension FileListViewController {
    func addRemove(_ urls: [URL], remove: Bool) {
        if !remove {
            urls.forEach({ self.addUrl($0, level: 0) })
        } else {
            urls.forEach({ self.removeUrl($0, level: 0) })
        }
    }
    
    func addUrls(_ urls: [URL], level: UInt = 0) {
        urls.forEach({ self.addUrl($0, level: level) })
    }
    
    func addUrl(_ url: URL, level: UInt = 0) {
        let fileManager = FileManager.default
        var isDirectory :ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return }
        
        guard !isDirectory.boolValue else {
            addDirectoryURLs(url, level: level)
            return
        }
        
        if fileList.add(url) {
            var indexes = IndexSet()
            indexes.insert(fileList.count - 1)
            fileListTableView.insertRows(at: indexes, withAnimation: NSTableViewAnimationOptions())
        }
    }
    
    func removeUrl(_ url: URL, level: UInt = 0) {
        let urls = fileList.urls
        guard let index = urls.index(of: url) else { return }
        guard index >= 0, index < fileList.count else { return }
        
        let indexSet = IndexSet([index])
        self.fileListTableView.removeRows(at: indexSet, withAnimation: NSTableViewAnimationOptions())
        let _ = self.fileList.removeFiles(at: indexSet)
    }
    
    func addDirectoryURLs(_ url: URL, level: UInt = 0) {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue  {
                do {
                    let urls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                    
                    for subUrl in urls {
                        addUrl(subUrl, level: level + 1)
                    }
                } catch {
                    // TODO: Show Error
                }
            }
        }
    }
    
    func removeFilesAtIndexes(_ indexes: IndexSet) {
        let urls: [URL] = indexes.map({ self.fileList.file(at: $0).url })
        urls.forEach({ self.removeUrl($0, level: 0) })
    }
}

//MARK: NSTableViewDataSource

extension FileListViewController: NSTableViewDataSource {
    func numberOfSectionsInTableView(_ tableView: NSTableView) -> Int {
        return 1
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fileList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = TableCellViewProvider.file.dequeCell(for: tableView, owner: self) as! FileTableCellView
        return configureCell(cell, row: row)
    }
    
    func configureCell(_ cell: FileTableCellView, row: Int) -> FileTableCellView {
        let file = fileList.file(at: row)
        cell.filename.stringValue = file.filename
        cell.preview.stringValue = file.preview
        cell.path.stringValue = file.renamedUrl.path
        cell.errorIndicator.isHidden = file.isValid
        cell.errorIndicator.mouseOverDelegate = self
        
        if let error = file.error {
            cell.errorIndicator.title = Text.Title.renamingError.localized
            cell.errorIndicator.message = error.localizedDescription
        }
        
        return cell
    }
}

//MARK: NSTableViewDelegate

extension FileListViewController: NSTableViewDelegate {
    
}

extension FileListViewController: FilterChangeDelegate {
    func filterHasChanged(_ filter: Filter?) {
        fileList.apply(filter ?? Filter())
        fileListTableView.reloadData()
    }

    func filterComponentChanged(_ filterComponent: FilterComponent) {
        if fileList.replace(filterComponent) {
            fileListTableView.reloadData()
        }
    }
}

extension FileListViewController: ReplaceFilterChangeDelegate {
    func replaceFilterHasChanged(for replaceFilter: ReplaceFilter?) {
        fileList.apply(replaceFilter ?? ReplaceFilter())
        fileListTableView.reloadData()
    }
}

extension FileListViewController: ErrorIndicatorMouseOverDelegate {
    func errorIndicatorMouseEntered(_ errorIndicatorView: ErrorIndicatorView) {
        if !errorPopover.isShown {
            let rect = errorIndicatorView.bounds
            let viewController = errorPopover.contentViewController as! FilterErrorViewController
            viewController.errorTitle = errorIndicatorView.title
            viewController.errorMessage = errorIndicatorView.message
            errorPopover.show(relativeTo: rect, of: errorIndicatorView, preferredEdge: NSRectEdge.maxX)
        }
    }
    
    func errorIndicatorMouseExited(_ errorIndicatorView: ErrorIndicatorView) {
        errorPopover.close()
    }
}
