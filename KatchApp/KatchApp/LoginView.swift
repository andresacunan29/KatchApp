//
//  LoginView.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showingResetPassword = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                if isRegistering {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                }
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if isRegistering {
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button(isRegistering ? "Register" : "Login") {
                    if isRegistering {
                        if password != confirmPassword {
                            alertMessage = "Passwords do not match."
                        } else if UserManager.shared.register(username: username, email: email, password: password) {
                            alertMessage = "Registration successful. Please login."
                            isRegistering = false
                        } else {
                            alertMessage = "Registration failed. Username may already exist."
                        }
                    } else {
                        if UserManager.shared.login(username: username, password: password) {
                            isLoggedIn = true
                        } else {
                            alertMessage = "Login failed. Please check your credentials."
                        }
                    }
                    showAlert = true
                }
                .padding()
                
                Button(isRegistering ? "Login" : "Register") {
                    isRegistering.toggle()
                    username = ""
                    email = ""
                    password = ""
                    confirmPassword = ""
                }
                .padding()
                
                if !isRegistering {
                    Button("Forgot Password?") {
                        showingResetPassword = true
                    }
                    .padding()
                }
            }
            .navigationTitle(isRegistering ? "Register" : "Login")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingResetPassword) {
                PasswordResetView()
            }
        }
    }
}

struct PasswordResetView: View {
    @State private var email = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirm New Password", text: $confirmNewPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Reset Password") {
                    if newPassword != confirmNewPassword {
                        alertMessage = "Passwords do not match."
                    } else if UserManager.shared.resetPassword(email: email, newPassword: newPassword) {
                        alertMessage = "Password reset successful. Please login with your new password."
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        alertMessage = "Password reset failed. Please check your email."
                    }
                    showAlert = true
                }
                .padding()
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .foregroundColor(.red)
            }
            .navigationTitle("Reset Password")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
