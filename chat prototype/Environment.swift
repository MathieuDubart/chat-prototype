//
//  Environment.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Foundation

enum Environment {
    static let supabaseURL: URL = {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SupabaseURL") as? String,
              let url = URL(string: urlString) else {
            fatalError("Supabase URL introuvable dans Info.plist ou invalide.")
        }
        return url
    }()
    
    static let supabaseAnonKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SupabaseKey") as? String,
              !key.isEmpty else {
            fatalError("Supabase Key introuvable dans Info.plist.")
        }
        return key
    }()
}
