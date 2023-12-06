//
//  ChatView.swift
//  duddy
//
//  Created by chatrli on 17/08/2023.
//

import SwiftUI

struct ChatView: View {
    @Binding var sessions: [ChatSession]
    @State private var selectedSession: ChatSession?
    @State private var newMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(sessions.indices, id: \.self) { index in
                    NavigationLink(destination: ConversationView(session: $sessions[index], sendMessage: { message in
                        sendMessage(sessionIndex: index, message: message)
                    })) {
                        Text("Chat at \(formatDate(sessions[index].timestamp))")
                    }
                }
                Button("New Conversation") {
                    createNewConversation()
                }
            }
            .padding()
            .listStyle(SidebarListStyle())
            
            Text("Select a conversation from the sidebar")
        }
    }
    
    func createNewConversation() {
        let newSession = ChatSession(messages: [], timestamp: Date())
        sessions.append(newSession)
    }
    
    func sendMessage(sessionIndex: Int, message: String) {
        if !message.isEmpty {
            let userMessage = Message(text: message, isUser: true)
            
            sessions[sessionIndex].messages.append(userMessage)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(sessions: .constant([]))
    }
}
