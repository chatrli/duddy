//
//  ContentView.swift
//  duddy
//
//  Created by chatrli on 17/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var chatSessions: [ChatSession] = []
    
    var body: some View {
        ChatView(sessions: $chatSessions)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
