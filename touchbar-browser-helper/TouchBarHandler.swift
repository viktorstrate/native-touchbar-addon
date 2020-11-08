//
//  TouchBarHandler.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Cocoa

let identifierPrefix = "com.github.viktorstrate.touchbar-browser-helper"

extension NSTouchBarItem.Identifier {
  static let touchbarBrowserGlobal = NSTouchBarItem.Identifier("\(identifierPrefix).global")
  static let touchbarBrowserClose = NSTouchBarItem.Identifier("\(identifierPrefix).close")
}

class TouchBarHandler: NSObject, NSTouchBarDelegate {
  
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
  
  @objc func actionTouchbarButtonOpen() {
    NSTouchBar.presentSystemModalTouchBar(touchbarStrip, systemTrayItemIdentifier: .touchbarBrowserClose)
  }
  
  @objc func actionTouchbarButtonClose() {
    NSTouchBar.dismissSystemModalTouchBar(touchbarStrip)
  }
  
  func showGlobalTouchBarItem() {
    NSTouchBarItem.addSystemTrayItem(self.globalTouchBarItem)
    DFRElementSetControlStripPresenceForIdentifier(.touchbarBrowserGlobal, true)
  }
  
  func removeGlobalTouchBarItem() {
    NSTouchBarItem.removeSystemTrayItem(self.globalTouchBarItem)
  }
}
