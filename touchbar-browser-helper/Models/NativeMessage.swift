//
//  NativeMessage.swift
//  touchbar-browser-helper
//
//  Created by Viktor Strate Kløvedal on 08/11/2020.
//

import Foundation

struct NativeMessageRequest: Codable {
  enum MessageType: String, Codable {
    case ping
  }
  
  let type: MessageType
}
