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
    case button(label: String, icon: String?)
    case slider(label: String?, value: Double, color: NSColor?)
  }
  
  let name: String
  
  init(name: String, component: Component, browserCommunication: BrowserCommunication) {
    self.name = name
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
//    var item = NSCustomTouchBarItem(identifier: identifier)
    let item: NSTouchBarItem
    
    switch component {
    case .button(let label, let iconName):
      
      let buttonItem = NSButtonTouchBarItem(identifier: identifier, title: label, target: self, action: #selector(buttonAction(_:)))
      
      if let iconName = iconName, let image = NSImage(named: iconName) {
        buttonItem.image = image
      }
      
      item = buttonItem
      
    case .slider(let label, let value, let color):
    
      let sliderItem = NSSliderTouchBarItem(identifier: identifier)
      sliderItem.target = self
      sliderItem.action = #selector(sliderAction(_:))
      
      sliderItem.label = label
      
      let slider = NSSlider()
      
      slider.doubleValue = value
      slider.trackFillColor = color
      
      sliderItem.slider = slider
      
      item = sliderItem
    
    }
    
    return item
  }()
  
  @objc func buttonAction(_ sender: NSButton) {
    
    guard case .button(_, _) = self.component else {
      return
    }
    
    browserCommunication.sendMessage(message: JSON([
      "type": "action",
      "target": "button",
      "name": name,
    ]))
  }
  
  @objc func sliderAction(_ sender: NSSlider) {
    
    guard let event = NSApplication.shared.currentEvent else {
      return
    }
    
    
    
    if event.subtype == .windowExposed {
      return
    }
    
    browserCommunication.sendMessage(message: JSON([
      "type": "action",
      "target": "slider",
      "name": name,
      "value": sender.doubleValue,
    ]))
    
  }

}
