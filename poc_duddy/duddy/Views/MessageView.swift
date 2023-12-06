//
//  MessageView.swift
//  duddy
//
//  Created by chatrli on 17/08/2023.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.text)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                HStack {
                    Text(message.text)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
    }
}


struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message(text: "Hello!", isUser: true))
    }
}
