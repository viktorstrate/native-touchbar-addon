//
//  AppDelegate.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 07/11/2020.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate  {
  
  let touchbarHandler = TouchBarHandler()
  let browserCommunication = BrowserCommunication()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    
    NSWorkspace.shared.notificationCenter.addObserver(self,
      selector: #selector(appActivatedEvent),
      name: NSWorkspace.didActivateApplicationNotification,
      object:nil)
    
    if let foregroundApp = NSWorkspace.shared.frontmostApplication {
      foremostApplicationChanged(to: foregroundApp)
    }
    
    browserCommunication.waitForCommands()
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
  @objc func appActivatedEvent(notification: Notification) {
    
    guard let foregroundApp = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication else {
      return
    }
    
    foremostApplicationChanged(to: foregroundApp)
  }
  
  func foremostApplicationChanged(to foregroundApp: NSRunningApplication) {
    if foregroundApp.bundleIdentifier == "org.mozilla.firefox" {
      self.touchbarHandler.showGlobalTouchBarItem()
    } else {
      self.touchbarHandler.removeGlobalTouchBarItem()
    }
  }

}

