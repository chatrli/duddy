//
//  Message.swift
//  duddy
//
//  Created by chatrli on 17/08/2023.
//

import Foundation

struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isUser: Bool
    var isTyping: Bool = false
}
