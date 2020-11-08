//
//  BrowserMessager.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Foundation
import SwiftyJSON

class BrowserCommunication {
  
  var delegate: BrowserCommunicationDelegate?
  
  fileprivate let jsonDecoder = JSONDecoder()
  fileprivate let jsonEncoder = JSONEncoder()
  
  fileprivate func processMessage(_ message: String) {
    NSLog("Message: %@", message)
    
    guard let jsonMessage = try? JSON(data: message.data(using: .utf8)!) else {
      NSLog("Could not parse message as json")
      return
    }
    
    self.delegate?.processMessage(jsonMessage, browserCommunication: self)
  }
  
  func sendMessage(message: JSON) {
    NSLog("Sending message")
    
    guard let messageData = try? message.rawData() else {
      NSLog("Failed to format json")
      return
    }
    
    let size = UInt32(messageData.count)
    var data = withUnsafeBytes(of: size) {
      Data($0)
    }
    
    data.append(messageData)
    
    FileHandle.standardOutput.write(data)
  }
  
  func waitForCommands() {
    DispatchQueue.global(qos: .background).async {
      let input = FileHandle.standardInput
      
      var data = Data()
      
      while true {
        // Get at least the message size (4 bytes)
        while data.count < 4 {
          data.append(input.availableData)
        }
        
        // Parse size
        let messageSize: Int = data.withUnsafeBytes {
          Int( $0.load(as: UInt32.self) )
        }
        
        // Remove parsed size bytes from 'data'
        if data.count == 4 {
          data = Data()
        } else {
          data = data.advanced(by: 4)
        }
        
        // Read at least the whole message
        while data.count < messageSize {
          data.append(input.availableData)
        }
        
        // Parse the message at utf8
        let message = String(data: data.prefix(messageSize), encoding: .utf8)!
        
        // Remove parsed message from 'data'
        if data.count == messageSize {
          data = Data()
        } else {
          data = data.advanced(by: messageSize)
        }
        
        // Process the parsed message
        self.processMessage(message)
      }
      
    }
  }
  
}

protocol BrowserCommunicationDelegate {
  func processMessage(_ message: JSON, browserCommunication: BrowserCommunication)
}
