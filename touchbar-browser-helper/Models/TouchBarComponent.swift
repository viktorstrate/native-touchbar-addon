//
//  TouchBarComponent.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Cocoa
import SwiftyJSON

class TouchBarComponent {
  enum Component {
    case button(label: String, name: String)
  }
  
  init(_ component: Component, browserCommunication: BrowserCommunication) {
    self.component = component
    self.browserCommunication = browserCommunication
    
    let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let id = String((0 ..< 8).map{ _ in alphabet.randomElement()! })
    
    self.identifier = .init("\(identifierPrefix).layout-component-\(id)")
  }
  
  let identifier: NSTouchBarItem.Identifier
  let component: Component
  fileprivate let browserCommunication: BrowserCommunication
  
  lazy var touchBarItem: NSTouchBarItem = {
    var item = NSCustomTouchBarItem(identifier: identifier)
    
    switch component {
    case .button(let label, let name):
      item.view = NSButton(title: label, target: self, action: #selector(buttonAction(_:)))
    }
    
    return item
  }()
  
  @objc func buttonAction(_ sender: NSButton) {
    
    guard case let .button(_, name) = self.component else {
      return
    }
    
    browserCommunication.sendMessage(message: JSON([
      "type": "event",
      "target": "button",
      "name": name,
    ]))
  }

}
