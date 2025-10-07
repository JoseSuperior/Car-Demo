//
//  ContentView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isFirstLaunch = true
    
    var body: some View {
        Group {
            if isFirstLaunch {
                LandingView()
            } else {
                // Main app content will go here
                MainTabView()
            }
        }
        .onAppear {
            // Check if user is logged in
            checkAuthenticationStatus()
        }
    }
    
    private func checkAuthenticationStatus() {
        // This would typically check UserDefaults or Keychain for auth token
        // For now, we'll always show the landing view
        isFirstLaunch = true
    }
}

// Placeholder for the main app interface
struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Dashboard")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
            
            Text("Recordings")
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Recordings")
                }
            
            Text("Patients")
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Patients")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.carPrimary)
    }
}

#Preview {
    ContentView()
}
