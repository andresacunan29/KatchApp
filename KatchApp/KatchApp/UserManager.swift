//
//  UserManager.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//
import Foundation

struct User: Codable {
    let username: String
    let email: String
    let password: String
}

class UserManager {
    static let shared = UserManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    func register(username: String, email: String, password: String) -> Bool {
        let lowercaseUsername = username.lowercased()
        let lowercaseEmail = email.lowercased()
        
        if userDefaults.object(forKey: lowercaseUsername) == nil {
            let user = User(username: lowercaseUsername, email: lowercaseEmail, password: password)
            userDefaults.set(try? JSONEncoder().encode(user), forKey: lowercaseUsername)
            userDefaults.set(lowercaseUsername, forKey: lowercaseEmail) // For email lookup
            return true
        }
        return false
    }
    
    func login(username: String, password: String) -> Bool {
        let lowercaseUsername = username.lowercased()
        guard let userData = userDefaults.data(forKey: lowercaseUsername),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            return false
        }
        if user.password == password {
            userDefaults.set(userData, forKey: "currentUser")
            return true
        }
        return false
    }
    
    func resetPassword(email: String, newPassword: String) -> Bool {
        let lowercaseEmail = email.lowercased()
        guard let username = userDefaults.string(forKey: lowercaseEmail),
              var userData = userDefaults.data(forKey: username),
              var user = try? JSONDecoder().decode(User.self, from: userData) else {
            return false
        }
        
        user = User(username: user.username, email: user.email, password: newPassword)
        if let encodedUser = try? JSONEncoder().encode(user) {
            userDefaults.set(encodedUser, forKey: username)
            return true
        }
        return false
    }
}
