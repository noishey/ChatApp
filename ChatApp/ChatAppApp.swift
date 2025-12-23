//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Arjun Shenoy on 19/12/25.
//

import SwiftUI
import Firebase

@main
struct ChatAppApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
