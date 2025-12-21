//
//  Message.swift
//  ChatApp
//
//  Created by Arjun Shenoy on 21/12/25.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
