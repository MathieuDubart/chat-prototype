//
//  ContentView.swift
//  chat prototype
//
//  Created by Mathieu Dubart on 03/03/2026.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var authManager = AuthManager()
    @State private var isLoginMode = true
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                VStack {
                    if isLoginMode {
                        LoginView()
                    } else {
                        SignUpView()
                    }
                    
                    Divider()
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isLoginMode.toggle()
                        }
                    }) {
                        Text(isLoginMode ? "Pas de compte ? Inscris-toi" : "Déjà un compte ? Connecte-toi")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .environment(authManager)
        .task {
            authManager.startListening()
        }
    }
}

#Preview {
    ContentView()
}
