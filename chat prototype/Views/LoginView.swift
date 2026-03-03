//
//  SignInView.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Connexion")
                .font(.title).bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            SecureField("Mot de passe", text: $password)
                .textFieldStyle(.roundedBorder)
            
            if let error = authManager.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                Task {
                    let success = await authManager.signIn(email: email, password: password)
                    if success {
                        // L'utilisateur est connecté, le changement d'écran doit être délégué au routeur
                        print("✅ Connexion réussie.")
                    }
                }
            }) {
                if authManager.isLoading {
                    ProgressView()
                } else {
                    Text("Se connecter")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(authManager.isLoading)
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
