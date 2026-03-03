//
//  ChatManager.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Foundation
import Supabase
import Observation

@Observable
@MainActor
final class ChatManager {
    var messages: [Message] = []
    private var listeningTask: Task<Void, Never>?
    
    func fetchHistory() async {
        do {
            self.messages = try await supabase
                .from("messages")
                .select()
                .order("created_at", ascending: true)
                .limit(50)
                .execute()
                .value
        } catch {
            print("Erreur historique : \(error)")
        }
    }
    
    func sendMessage(content: String, userId: UUID, email: String) async {
        let payload = [
            "user_id": userId.uuidString,
            "sender_email": email,
            "content": content
        ]
        
        do {
            try await supabase.from("messages").insert(payload).execute()
        } catch {
            print("Erreur envoi : \(error)")
        }
    }
    
    func startListening() {
        listeningTask?.cancel()
        
        listeningTask = Task {
            let channel = supabase.channel("public:messages")
            
            let insertions = channel.postgresChange(
                InsertAction.self,
                schema: "public",
                table: "messages"
            )
            
            do {
                try await channel.subscribeWithError()
            } catch {
                print("Erreur subscription : \(error)")
                return
            }
            
            for await insert in insertions {
                do {
                    let newMessage = try insert.record.decode(as: Message.self)
                    self.messages.append(newMessage)
                } catch {
                    print("Erreur décodage realtime : \(error)")
                }
            }
        }
    }
    
    func stopListening() {
        listeningTask?.cancel()
        listeningTask = nil
    }
}
