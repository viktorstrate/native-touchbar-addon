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
  
  func generateComponent(componentJson: JSON, browserCommunication: BrowserCommunication) -> TouchBarComponent? {
    
    guard let type = componentJson["type"].string else {
      return nil
    }
    
    let component: TouchBarComponent?
    
    switch type {
    case "button":
      
      guard let label = componentJson["label"].string else { return nil }
      guard let name = componentJson["name"].string else { return nil }
      
      component = TouchBarComponent(.button(label: label, name: name), browserCommunication: browserCommunication)
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
