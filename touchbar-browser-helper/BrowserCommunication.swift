//
//  BrowserMessager.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Foundation

class BrowserCommunication {
  
  fileprivate let jsonDecoder = JSONDecoder()
  fileprivate let jsonEncoder = JSONEncoder()
  
  fileprivate func processMessage(_ message: String) {
    NSLog("Message: %@", message)
    
    guard let nativeMessage = try? jsonDecoder.decode(NativeMessageRequest.self, from: message.data(using: .utf8)!) else {
      NSLog("Invalid message structure")
      return
    }
    
    switch nativeMessage.type {
    case .ping:
      NSLog("Received ping")
      let pong: [String: String] = [
        "type": "ping",
        "value": "pong",
      ]
      let json = try! jsonEncoder.encode(pong)
      sendMessage(message: json)
    }
    
  }
  
  func sendMessage(message: Data) {
    NSLog("Sending message")
    
    let size = UInt32(message.count)
    var data = withUnsafeBytes(of: size) {
      Data($0)
    }
    
    data.append(message)
    
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
