//
//  MessagesManager.swift
//  ChatApp
//
//  Created by Arjun Shenoy on 23/12/25.
//

import Foundation
import Combine
import FirebaseFirestore

class MessagesManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId: String = ""
    
    // Create an instance of our Firestore database
    let db = Firestore.firestore()
    
    // On initialize of the MessagesManager class, get the messages from Firestore
    init() {
        getMessages()
    }

    // Read messages from Firestore in real-time with the addSnapshotListener
    func getMessages() {
        // Order by server timestamp so newest is last
        db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self else { return }
                
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                
                self.messages = documents.compactMap { document -> Message? in
                    let data = document.data()
                    
                    guard
                        let id = data["id"] as? String,
                        let text = data["text"] as? String,
                        let received = data["received"] as? Bool
                    else {
                        return nil
                    }
                    
                    // Server timestamp may be nil on the first local event
                    let timestampValue: Date
                    if let ts = data["timestamp"] as? Timestamp {
                        timestampValue = ts.dateValue()
                    } else if let date = data["timestamp"] as? Date {
                        timestampValue = date
                    } else {
                        // Fallback to now; will correct on next snapshot when server sets timestamp
                        timestampValue = Date()
                    }
                    
                    return Message(id: id, text: text, received: received, timestamp: timestampValue)
                }
                
                // Firestore already ordered, but break ties for equal timestamps to keep stable order
                self.messages.sort {
                    if $0.timestamp == $1.timestamp {
                        return $0.id < $1.id
                    } else {
                        return $0.timestamp < $1.timestamp
                    }
                }
                
                if let id = self.messages.last?.id {
                    self.lastMessageId = id
                }
            }
    }
    
    // Add a message in Firestore
    func sendMessage(text: String) {
        // Generate an ID locally; server will set timestamp
        let newId = UUID().uuidString
        
        let data: [String: Any] = [
            "id": newId,
            "text": text,
            "received": false,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("messages").document().setData(data) { error in
            if let error = error {
                print("Error adding message to Firestore: \(error)")
            }
        }
    }
}
