//
//  OpenPanelBridge.swift
//  RX Preferences
//
//  Created by Andrew Finke on 5/25/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Cocoa
import RXKit

class OpenPanelBridge {

    // MARK: - Types -

    private struct AppInfoPlist: Decodable {
        let name: String
        let bundleID: String

        enum CodingKeys: String, CodingKey {
            case name = "CFBundleName"
            case bundleID = "CFBundleIdentifier"
        }
    }

    // MARK: - Helpers -

    func selectRXScript(appName: String) -> RXScript? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["scpt"]

        let suffix: String
        if appName == "Default" {
            suffix = "."
        } else {
            suffix = " and \(appName) is the frontmost app."
        }
        panel.message = "Select the AppleScript file (.scpt) to run when the button is pressed" + suffix
        if panel.runModal() == .OK,
            let url = panel.url,
            let name = url.lastPathComponent.split(separator: ".").first {
            let dest = RXURL.newScript()
            do {
                try FileManager.default.copyItem(atPath: url.path, toPath: dest.path)
            } catch {
                return nil
            }
            return RXScript(name: String(name), fileURL: dest)
        }
        return nil
    }

    func selectApp() -> (name: String, bundleID: String)? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["app"]
        panel.directoryURL = URL(string: "/Applications")
        panel.message = "Select an application to configure the device for."
        if panel.runModal() == .OK,
            let url = panel.url,
            let data = try? Data(contentsOf: url.appendingPathComponent("/Contents/Info.plist")),
            let plist = try? PropertyListDecoder().decode(AppInfoPlist.self, from: data) {
            return (name: plist.name, bundleID: plist.bundleID)
        }
        return nil
    }
}
