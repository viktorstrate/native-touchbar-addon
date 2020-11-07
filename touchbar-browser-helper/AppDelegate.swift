//
//  AppDelegate.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 07/11/2020.
//

import Cocoa

let identifierPrefix = "com.github.viktorstrate.touchbar-browser-helper"

extension NSTouchBarItem.Identifier {
  static let touchbarBrowserGlobal = NSTouchBarItem.Identifier("\(identifierPrefix).global")
  static let touchbarBrowserClose = NSTouchBarItem.Identifier("\(identifierPrefix).close")
}

class AppDelegate: NSObject, NSApplicationDelegate, NSTouchBarDelegate {
  
  lazy var touchbarStrip: NSTouchBar = {
    let strip = NSTouchBar()
    strip.defaultItemIdentifiers = [.touchbarBrowserClose]
    strip.delegate = self
    return strip
  }()
  
  lazy var globalTouchBarItem: NSCustomTouchBarItem = {
    let item = NSCustomTouchBarItem(identifier: .touchbarBrowserGlobal)
    item.view = NSButton(title: "🌍", target: self, action: #selector(actionTouchbarButtonOpen))
    return item
  }()
  
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    
    NSWorkspace.shared.notificationCenter.addObserver(self,
      selector: #selector(appActivatedEvent),
      name: NSWorkspace.didActivateApplicationNotification,
      object:nil)
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  func showGlobalTouchBarItem() {
    NSTouchBarItem.addSystemTrayItem(self.globalTouchBarItem)
    DFRElementSetControlStripPresenceForIdentifier(.touchbarBrowserGlobal, true)
  }
  
  func removeGlobalTouchBarItem() {
    NSTouchBarItem.removeSystemTrayItem(self.globalTouchBarItem)
  }
  
  @objc func appActivatedEvent(notification: Notification) {
    
    guard let foregroundApp = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication else {
      return
    }
    
    if foregroundApp.bundleIdentifier == "org.mozilla.firefox" {
      self.showGlobalTouchBarItem()
    } else {
      self.removeGlobalTouchBarItem()
    }
  }
  
  @objc func actionTouchbarButtonOpen() {
    print("Global touchbar button clicked")
    
    NSTouchBar.presentSystemModalTouchBar(touchbarStrip, systemTrayItemIdentifier: .touchbarBrowserClose)
  }
  
  @objc func actionTouchbarButtonClose() {
    print("Close touchbar")
    
    NSTouchBar.dismissSystemModalTouchBar(touchbarStrip)
  }

  func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
    switch identifier {
    case .touchbarBrowserClose:
      let globalButton = NSCustomTouchBarItem(identifier: .touchbarBrowserClose)
      globalButton.view = NSButton(title: "Close", target: self, action: #selector(actionTouchbarButtonClose))
      return globalButton
    default:
      return nil
    }
  }

}

