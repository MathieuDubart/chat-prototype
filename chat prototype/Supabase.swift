//
//  Supabase.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: Environment.supabaseURL,
    supabaseKey: Environment.supabaseAnonKey
)
