//
//  AuthManager.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import Foundation
import Supabase
import Observation

@Observable
@MainActor
final class AuthManager {
    var isAuthenticated = false
    var currentUser: User?
    var isLoading = false
    var errorMessage: String?

    func startListening() {
        Task {
            for await state in supabase.auth.authStateChanges {
                self.currentUser = state.session?.user
                self.isAuthenticated = state.session != nil
            }
        }
    }
    
    private func validate(email: String, password: String) -> Bool {
        if email.isEmpty || !email.contains("@") {
            errorMessage = "Format d'email invalide."
            return false
        }
        if password.count < 6 {
            errorMessage = "Le mot de passe doit faire au moins 6 caractères."
            return false
        }
        return true
    }
    
    func signUp(email: String, password: String) async -> Bool {
        guard validate(email: email, password: password) else { return false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let _ = try await supabase.auth.signUp(email: email, password: password)
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func signIn(email: String, password: String) async -> Bool {
        guard validate(email: email, password: password) else { return false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let _ = try await supabase.auth.signIn(email: email, password: password)
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = "Email ou mot de passe incorrect."
            return false
        }
    }
    
    func signOut() async {
        isLoading = true
        do {
            try await supabase.auth.signOut()
        } catch {
            print("Erreur de déconnexion : \(error.localizedDescription)")
        }
        isLoading = false
    }
}
