//
//  ConversationView.swift
//  duddy
//
//  Created by chatrli on 18/08/2023.
//

import SwiftUI
import CoreML
import NaturalLanguage

struct ConversationView: View {
    
    @State var showResult: Bool = false
    
    @Binding var session: ChatSession
    let sendMessage: (String) -> Void

    @State private var newMessage: String = ""

    // Load models using the auto-generated class
    var moodClassifier: duddyMoodClassifier? = {
        guard let modelURL = Bundle.main.url(forResource: "duddyMoodClassifier", withExtension: "mlmodelc") else {
            fatalError("Failed to load the mood model")
        }
        return try? duddyMoodClassifier(contentsOf: modelURL)
    }()
    
    var deviceClassifier: duddyDeviceClassifier_5? = {
        guard let modelURL = Bundle.main.url(forResource: "duddyDeviceClassifier 5", withExtension: "mlmodelc") else {
            fatalError("Failed to load the device model")
        }
        return try? duddyDeviceClassifier_5(contentsOf: modelURL)
    }()
    
    var issueClassifier: duddyIssueClassifier_5 = {
        guard let modelURL = Bundle.main.url(forResource: "duddyIssueClassifier 5", withExtension: "mlmodelc") else {
            fatalError("Failed to load the issue model")
        }
        return try! duddyIssueClassifier_5(contentsOf: modelURL)
    }()
    
    var articleClassifier: duddyArticleClassifier? = {
        guard let modelURL = Bundle.main.url(forResource: "duddyArticleClassifier", withExtension: "mlmodelc") else {
            fatalError("Failed to load the article model")
        }
        return try! duddyArticleClassifier(contentsOf: modelURL)
    }()
    
    var subIssueClassifier: duddySubIssueClassifier? = {
        guard let modelURL = Bundle.main.url(forResource: "duddySubIssueClassifier", withExtension: "mlmodelc") else {
            fatalError("Failed to load sub issue model")
        }
        return try! duddySubIssueClassifier(contentsOf: modelURL)
    }()

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(session.messages, id: \.id) { message in
                        MessageView(message: message)
                    }
                }
                .padding()
            }

            Divider()

            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    sendButtonTapped()
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
    }

    func sendButtonTapped() {
        sendMessage(newMessage)
        simulateTypingAnimation(for: newMessage)
        newMessage = ""
    }

    func simulateTypingAnimation(for userMessage: String) {
        
        let moodInput = duddyMoodClassifierInput(text: userMessage)
        let deviceInput = duddyDeviceClassifier_5Input(text: userMessage)
        let issueInput = duddyIssueClassifier_5Input(text: userMessage)
        let articleInput = duddyArticleClassifierInput(text: userMessage)
        let subIssueInput = duddySubIssueClassifierInput(text: userMessage)

        // Make predictions
        if let moodPrediction = try? moodClassifier?.prediction(input: moodInput),
           let devicePrediction = try? deviceClassifier?.prediction(input: deviceInput),
           let articlePrediction = try? articleClassifier?.prediction(input: articleInput),
           let subIssuePrediction = try? subIssueClassifier?.prediction(input: subIssueInput),
           let issuePrediction = try? issueClassifier.prediction(input: issueInput) {
            
            // Access the predicted sentiment label and device label directly
            let sentiment = moodPrediction.label
            let device = devicePrediction.label
            let subIssue = subIssuePrediction.label
            let issue = issuePrediction.label
            let article = articlePrediction.label
            
            let articleURL = "https://support.apple.com/en-us/\(article)"
            
            let reply = "Product: \(device)\nIssue category: \(issue)\nIssue sub-category: \(subIssue)\nRecommend article(s): \(articleURL)\nUser mood: \(sentiment)"

            // Animation
            let typingMessage = Message(text: "", isUser: false, isTyping: true)
            session.messages.append(typingMessage)

            let characters = Array(reply)
            for (index, character) in characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    session.messages[session.messages.count - 1].text.append(character)
                    if index == characters.count - 1 {
                        session.messages[session.messages.count - 1].isTyping = false
                    }
                }
            }
        }
    }
}
