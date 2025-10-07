//
//  ContentView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var isSuperAdmin = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                if isSuperAdmin {
                    SuperAdminDashboardView()
                } else {
                    TenantAdminDashboardView()
                }
            } else {
                LandingView()
            }
        }
        .onAppear {
            checkAuthenticationStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("LoginStateChanged"))) { _ in
            checkAuthenticationStatus()
        }
    }
    
    private func checkAuthenticationStatus() {
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        isSuperAdmin = UserDefaults.standard.bool(forKey: "isSuperAdmin")
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
