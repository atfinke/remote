//
//  Macintosh.swift
//  RXd
//
//  Created by Andrew Finke on 6/29/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import AppKit
import os.log

class Macintosh {
    
    // MARK: - Types -
    
    enum State {
        case on(bundleID: String), wakingFromSleep, sleeping
    }
    
    // MARK: - Properties -
    
    var onStateChange: ((_ state: State) -> Void)? {
        didSet {
            updateToFrontmostApp()
        }
    }
    private var isScreenLocked = false
    private let log = OSLog(subsystem: "com.andrewfinke.RX", category: "RXd macOS")
    
    // MARK: - Initalization -
    
    init() {
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: nil,
            using: { notification in
                let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
                self.update(to: app)
            })
        
        DistributedNotificationCenter.default().addObserver(
            forName: NSNotification.Name("com.apple.screenIsLocked"),
            object: nil,
            queue: nil,
            using: { _ in
                os_log("com.apple.screenIsLocked", log: self.log, type: .info)
                self.onStateChange?(.sleeping)
                self.isScreenLocked = true
            })
        
        DistributedNotificationCenter.default().addObserver(
            forName: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil,
            queue: nil,
            using: { _ in
                os_log("com.apple.screenIsUnlocked", log: self.log, type: .info)
                self.onStateChange?(.wakingFromSleep)
                self.isScreenLocked = false
            })
        
    }
    
    // MARK: - Updates -
    
    private func updateToFrontmostApp() {
        update(to: NSWorkspace.shared.frontmostApplication)
    }
    
    private func update(to app: NSRunningApplication?) {
        guard let bundleID = app?.bundleIdentifier, bundleID != "com.apple.loginwindow", !isScreenLocked else { return }
        os_log("frontmost app: %{public}s", log: self.log, type: .info, bundleID)
        
        onStateChange?(.on(bundleID: bundleID))
    }
    
}
