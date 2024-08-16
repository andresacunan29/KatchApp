//
//  ContentView.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingIntro = true
    @State private var isLoggedIn = false
    
    var body: some View {
        Group {
            if isShowingIntro {
                IntroView(isShowingIntro: $isShowingIntro)
            } else if !isLoggedIn {
                LoginView(isLoggedIn: $isLoggedIn)
            } else {
                HomePage(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear(perform: checkLoginStatus)
    }
    
    private func checkLoginStatus() {
        if let _ = UserDefaults.standard.data(forKey: "currentUser") {
            isLoggedIn = true
        }
    }
}

struct IntroView: View {
    @Binding var isShowingIntro: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack {
                Image("appicon")
                    .resizable()
                    .cornerRadius(15.0)
                    .aspectRatio(contentMode: .fit)
                    .padding(.all)
                Text("KatchApp")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isShowingIntro = false
            }
        }
    }
}
