//
//  ChatSession.swift
//  duddy
//
//  Created by chatrli on 18/08/2023.
//

import Foundation

struct ChatSession: Identifiable {
    var id = UUID()
    var messages: [Message]
    var timestamp: Date
}

