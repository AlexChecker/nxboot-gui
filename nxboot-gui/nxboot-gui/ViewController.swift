//
//  ViewController.swift
//  nxboot-gui
//
//  Created by alex Cheker on 10.03.2023.
//  Copyright © 2023 alex Cheker. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
        
    var pathToPayload:String!

    @IBOutlet weak var pathTo:NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func runPayload(_ sender:AnyObject)
    {
        if(pathToPayload != nil){
        if(execute(pathToPayload))
        {
            let alert:NSAlert = NSAlert()
            alert.messageText = "Payload loaded successfully!"
            alert.alertStyle = .informational
            alert.runModal()
        }
        else
        {
            let alert:NSAlert = NSAlert()
            alert.messageText = "Error while loading payload!"
            alert.alertStyle = .critical
            alert.runModal()
        }
        }
        else
        {
            let alert:NSAlert = NSAlert()
            alert.messageText = "No payload selected!"
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
    @IBAction func openPayload(_ sender:AnyObject)
    {
        let dialog = NSOpenPanel();
        dialog.title = "Select payload"
        dialog.showsResizeIndicator = false
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["bin"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK)
        {
            let result = dialog.url
            if(result != nil)
            {
                pathToPayload = result!.path
                pathTo.stringValue = String(pathToPayload.split(separator: "/").last ?? "None")
            }
        }
        
    }


}

