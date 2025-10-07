//
//  ContentView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userSession = UserSession.shared
    
    var body: some View {
        Group {
            if userSession.isLoggedIn {
                DashboardContainerView()
                    .environmentObject(userSession)
            } else {
                LandingView()
                    .environmentObject(userSession)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("LoginStateChanged"))) { _ in
            // UserSession will handle the state changes automatically
        }
    }
}

// MARK: - Dashboard Container
struct DashboardContainerView: View {
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        Group {
            if userSession.isSuperAdmin && userSession.currentTenant == nil {
                // Super Admin view - managing all tenants
                SuperAdminDashboardView()
            } else {
                // Tenant view - either regular tenant or super admin viewing a specific tenant
                TenantAdminDashboardView()
            }
        }
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
