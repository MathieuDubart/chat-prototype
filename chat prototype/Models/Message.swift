//
//  Message.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Foundation

import Foundation

struct Message: Identifiable, Decodable, Hashable {
    let id: UUID
    let userId: UUID
    let senderEmail: String
    let content: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case senderEmail = "sender_email"
        case content
        case createdAt = "created_at"
    }
}
