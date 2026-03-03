//
//  SignUpView.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import SwiftUI

struct SignUpView: View {
    @State private var authManager = AuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var registrationSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Créer un compte")
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
            
            if registrationSuccess {
                Text("Compte créé ! Vérifie tes emails pour confirmer.")
                    .foregroundColor(.green)
                    .font(.callout)
            } else {
                Button(action: {
                    Task {
                        registrationSuccess = await authManager.signUp(email: email, password: password)
                    }
                }) {
                    if authManager.isLoading {
                        ProgressView()
                    } else {
                        Text("S'inscrire")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(authManager.isLoading)
            }
        }
        .padding()
    }
}

#Preview {
    SignUpView()
}
