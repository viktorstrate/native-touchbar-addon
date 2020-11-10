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
  
  var layoutComponents: [TouchBarComponent] = [] {
    didSet {
      DispatchQueue.main.async {
        self.updateTouchbarStrip()
        self.touchbarStripVisible = true
      }
    }
  }
  
  fileprivate lazy var touchbarStrip: NSTouchBar = {
    let strip = NSTouchBar()
    strip.defaultItemIdentifiers = []
    strip.delegate = self
    return strip
  }()
  
  var touchbarStripVisible: Bool {
    set {
      if newValue {
        NSTouchBar.presentSystemModalTouchBar(touchbarStrip, systemTrayItemIdentifier: .touchbarBrowserClose)
      } else {
        NSTouchBar.dismissSystemModalTouchBar(touchbarStrip)
      }
    }
    
    get {
      touchbarStrip.isVisible
    }
  }
  
  func updateTouchbarStrip() {
    
//    strip.defaultItemIdentifiers = [.touchbarBrowserClose]
    touchbarStrip.defaultItemIdentifiers = []
    touchbarStrip.defaultItemIdentifiers.append(contentsOf: layoutComponents.map({ $0.identifier }))
  }
  
  lazy var globalTouchBarItem: NSCustomTouchBarItem = {
    let item = NSCustomTouchBarItem(identifier: .touchbarBrowserGlobal)
    item.view = NSButton(title: "🌍", target: self, action: #selector(actionTouchbarButtonToggle))
    return item
  }()
  
  func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
    switch identifier {
    case .touchbarBrowserClose:
      let globalButton = NSCustomTouchBarItem(identifier: .touchbarBrowserClose)
      globalButton.view = NSButton(title: "Close", target: self, action: #selector(actionTouchbarButtonClose))
      return globalButton
    default:
      // Look in layoutComponents
      if let component = layoutComponents.first(where: { $0.identifier == identifier }) {
        return component.touchBarItem
      }
    }
    
    return nil
  }
  
  @objc func actionTouchbarButtonToggle() {
    touchbarStripVisible = !touchbarStripVisible
  }
  
  @objc func actionTouchbarButtonOpen() {
    touchbarStripVisible = true
  }
  
  @objc func actionTouchbarButtonClose() {
    touchbarStripVisible = false
  }
  
  func showGlobalTouchBarItem() {
    NSTouchBarItem.addSystemTrayItem(self.globalTouchBarItem)
    DFRElementSetControlStripPresenceForIdentifier(.touchbarBrowserGlobal, true)
  }
  
  func removeGlobalTouchBarItem() {
    NSTouchBarItem.removeSystemTrayItem(self.globalTouchBarItem)
  }
}
