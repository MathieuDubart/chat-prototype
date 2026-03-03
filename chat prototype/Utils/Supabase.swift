//
//  Supabase.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: EnvironmentVariables.supabaseURL,
    supabaseKey: EnvironmentVariables.supabaseAnonKey,
    options: SupabaseClientOptions(
        auth: SupabaseClientOptions.AuthOptions(
            emitLocalSessionAsInitialSession: true
        )
    )
)
