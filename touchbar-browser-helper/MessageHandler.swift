//
//  MessageHandler.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Foundation
import SwiftyJSON

class MessageHandler: BrowserCommunicationDelegate {
  
  fileprivate let jsonDecoder = JSONDecoder()
  fileprivate let jsonEncoder = JSONEncoder()
  
  let touchbarHandler: TouchBarHandler
  
  init(touchbarHandler: TouchBarHandler) {
    self.touchbarHandler = touchbarHandler
  }
  
  func processMessage(_ message: JSON, browserCommunication: BrowserCommunication) {
    
    guard let messageType = message["type"].string else {
      let error = jsonError(type: "null", reason: "Message missing type: \(message["type"].error!)")
      browserCommunication.sendMessage(message: error)
      return
    }
    
    NSLog("Process message of type '\(messageType)'")
    
    switch messageType {
    case "ping":
      handlePingRequest(browserCommunication: browserCommunication)
    case "change_layout":
      handleChangeLayout(message, browserCommunication: browserCommunication)
    case "update_item":
      handleUpdateItem(message, browserCommunication: browserCommunication)
    case "dismiss_touchbar":
      handleDismissTouchbar()
    default:
      let error = jsonError(type: messageType, reason: "Unknown message type")
      browserCommunication.sendMessage(message: error)
    }
  }
  
  func handlePingRequest(browserCommunication: BrowserCommunication) {
    let pong: [String: Any] = [
      "type": "ping",
      "success": true,
      "value": "pong",
    ]
    browserCommunication.sendMessage(message: JSON(pong))
  }
  
  func handleChangeLayout(_ message: JSON, browserCommunication: BrowserCommunication) {
    let layout = message["layout"].arrayValue
    
    let components: [TouchBarComponent] = layout
      .map { generateComponent(componentJson: $0, browserCommunication: browserCommunication) }
      .compactMap { $0 }
    
    touchbarHandler.layoutComponents = components
  }
  
  func handleUpdateItem(_ message: JSON, browserCommunication: BrowserCommunication) {
    guard let name = message["name"].string else {
      return
    }
    
    guard let component = touchbarHandler.layoutComponents.first(where: { $0.name == name }) else {
      return
    }
    
    switch component.component {
    case .button:
      guard let button = component.touchBarItem as? NSButtonTouchBarItem else {
        return
      }
      
      DispatchQueue.main.async {
        if let newLabel = message["values"]["label"].string {
          button.title = newLabel
        }
        
        if let newIcon = message["values"]["icon"].string {
          button.image = NSImage(named: newIcon)
        }
      }
      
    case .slider:
      guard let slider = component.touchBarItem as? NSSliderTouchBarItem else {
        return
      }
      
      DispatchQueue.main.async {
        if let newValue = message["values"]["value"].double {
          if (slider.slider as? CustomSlider)?.tracking == false {
            slider.doubleValue = newValue
          }
        }
        
        if let newLabel = message["values"]["label"].string {
          slider.label = newLabel
        }
        
        if let newColor = message["values"]["color"].string {
          slider.slider.trackFillColor = NSColor.from(hex: newColor)
        }
      }
      
    }
    
  }
  
  func handleDismissTouchbar() {
    DispatchQueue.main.async {
      self.touchbarHandler.touchbarStripVisible = false
    }
  }
  
  func generateComponent(componentJson: JSON, browserCommunication: BrowserCommunication) -> TouchBarComponent? {
    
    guard let type = componentJson["type"].string else { return nil}
    guard let name = componentJson["name"].string else { return nil }
    
    let component: TouchBarComponent?
    
    switch type {
    case "button":
      
      let label = componentJson["label"].stringValue
      let icon = componentJson["icon"].string
      
      component = TouchBarComponent(name: name, component: .button(label: label, icon: icon), browserCommunication: browserCommunication)
    
    case "slider":
      
      let label = componentJson["label"].string
      let value = componentJson["value"].doubleValue
      
      let color: NSColor?
      if let hex = componentJson["color"].string {
        color = NSColor.from(hex: hex)
      } else {
        color = nil
      }
      
      component = TouchBarComponent(name: name, component: .slider(label: label, value: value, color: color), browserCommunication: browserCommunication)
    
    default:
      component = nil
    }
    
    return component
  }
  
  func jsonError(type: String, reason: String) -> JSON {
    NSLog("Message handler error on type \(type): \(reason)")
    return JSON([
      "type": type,
      "success": false,
      "message": reason,
    ])
  }
  
}
