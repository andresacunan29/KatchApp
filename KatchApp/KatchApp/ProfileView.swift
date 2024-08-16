//
//  ProfileView.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//
import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @State private var username: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Username: \(username)")
                        .font(.headline)
                    Text("Email: \(email)")
                        .font(.headline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Button(action: {
                    // Perform logout
                    UserDefaults.standard.removeObject(forKey: "currentUser")
                    isLoggedIn = false
                }) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .onAppear(perform: loadUserData)
        }
    }
    
    private func loadUserData() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            username = user.username
            email = user.email
        }
    }
}
