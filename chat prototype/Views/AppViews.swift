//
//  AppViews.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import SwiftUI
import Supabase

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeFeedView()
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct HomeFeedView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var chatManager = ChatManager()
    @State private var newMessageText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messageListView
                messageInputView
            }
            .navigationTitle("Chat Global")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await chatManager.fetchHistory()
                await chatManager.startListening()
            }
        }
    }
    
    private var messageListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(chatManager.messages) { message in
                        MessageBubbleView(
                            message: message,
                            isMe: message.userId == authManager.currentUser?.id
                        )
                    }
                }
                .padding(.vertical)
            }
            .onChange(of: chatManager.messages) { _, _ in
                scrollToLastMessage(proxy: proxy)
            }
        }
    }
    
    private var messageInputView: some View {
        HStack {
            TextField("Message...", text: $newMessageText)
                .textFieldStyle(.roundedBorder)
            
            sendButton
        }
        .padding()
    }
    
    private var sendButton: some View {
        Button(action: sendMessage) {
            Image(systemName: "paperplane.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
        }
        .disabled(newMessageText.isEmpty)
    }
    
    private func sendMessage() {
        guard !newMessageText.isEmpty,
              let userId = authManager.currentUser?.id,
              let userEmail = authManager.currentUser?.email else { return }
        
        let textToSend = newMessageText
        newMessageText = ""
        
        Task {
            await chatManager.sendMessage(content: textToSend, userId: userId, email: userEmail)
        }
    }
    
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = chatManager.messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}
struct ProfileView: View {
    @Environment(AuthManager.self) private var authManager
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(authManager.currentUser?.email ?? "No valid email")
                } header: {
                    Text("Mes infos")
                }
                
                Section {
                    Button(role: .destructive) {
                        Task { await authManager.signOut() }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Se déconnecter")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Mon Profil")
        }
    }
}
// MARK: - Message Bubble Component

struct MessageBubbleView: View {
    let message: Message
    let isMe: Bool
    
    var body: some View {
        
        if !isMe {
            Text(message.senderEmail)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
        }
        
        HStack {
            
            if isMe { Spacer() }
            
            VStack{
                
                
                Text(message.content)
                    .padding(12)
                    .background(bubbleBackground)
                    .foregroundColor(bubbleTextColor)
                    .cornerRadius(16)
            }
            
            if !isMe { Spacer() }
        }
        .padding(.horizontal)
        .id(message.id)
    }
    
    private var bubbleBackground: Color {
        isMe ? Color.blue : Color.gray.opacity(0.2)
    }
    
    private var bubbleTextColor: Color {
        isMe ? .white : .primary
    }
}

