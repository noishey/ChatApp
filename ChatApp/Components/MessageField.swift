//
//  MessageField.swift
//  ChatApp
//
//  Created by Arjun Shenoy on 23/12/25.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var messageManager: MessagesManager
    @State private var message = ""
    var body: some View {
        HStack{
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
            Button {
                messageManager.sendMessage(text: message)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("Green"))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
        .background(Color("Gray"))
        .cornerRadius(50)
        .padding()
    }
}

#Preview {
    MessageField()
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> () = {}
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
