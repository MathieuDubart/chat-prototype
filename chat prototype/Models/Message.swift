//
//  Message.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Foundation

struct Message: Identifiable, Decodable, Hashable {
    let id: UUID
    let userId: UUID
    let content: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case content
        case createdAt = "created_at"
    }
}
