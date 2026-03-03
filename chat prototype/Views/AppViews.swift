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
            VStack {
                // 1. La zone des messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(chatManager.messages) { message in
                                let isMe = message.userId == authManager.currentUser?.id
                                
                                HStack {
                                    if isMe { Spacer() }
                                    
                                    Text(message.content)
                                        .padding(12)
                                        .background(isMe ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundColor(isMe ? .white : .primary)
                                        .cornerRadius(16)
                                    
                                    if !isMe { Spacer() }
                                }
                                .padding(.horizontal)
                                .id(message.id) // Crucial pour le scroll automatique
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: chatManager.messages) { _, _ in
                        // Auto-scroll vers le bas au nouveau message
                        if let lastMessage = chatManager.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 2. La zone de saisie
                HStack {
                    TextField("Message...", text: $newMessageText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: {
                        guard !newMessageText.isEmpty,
                              let userId = authManager.currentUser?.id else { return }
                        
                        let textToSend = newMessageText
                        newMessageText = "" // On vide le champ direct
                        
                        Task {
                            await chatManager.sendMessage(content: textToSend, userId: userId)
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(newMessageText.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Chat Global")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                // Au chargement, on chope l'historique et on ouvre les websockets
                await chatManager.fetchHistory()
                await chatManager.startListening()
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
