//
//  ContentView.swift
//  ChatApp
//
//  Created by Arjun Shenoy on 19/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var messagesManager = MessagesManager()

    var body: some View {
        VStack {
            VStack {
                TitleRow()

                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: messagesManager.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color("Green"))

            MessageField()
                .environmentObject(messagesManager)
        }
        // If any child uses MessagesManager as an EnvironmentObject,
        // this makes it available in the hierarchy for previews and runtime.
        .environmentObject(messagesManager)
    }
}

#Preview {
    ContentView()
        .environmentObject(MessagesManager())
}
