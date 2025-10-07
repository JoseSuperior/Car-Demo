//
//  SuperAdminDashboardView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct SuperAdminDashboardView: View {
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                SuperAdminHeaderView(onLogout: {
                    showingLogoutAlert = true
                })
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    TenantsListView()
                        .tag(0)
                    
                    SubscriptionManagementView()
                        .tag(1)
                    
                    InboxView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Tab Bar
                SuperAdminTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .background(Color.backgroundPrimary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                handleLogout()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    private func handleLogout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "isSuperAdmin")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        NotificationCenter.default.post(name: .init("LoginStateChanged"), object: nil)
    }
}

// MARK: - Super Admin Header
struct SuperAdminHeaderView: View {
    let onLogout: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Logo and Title
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.carPrimary, Color.carAccent]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "cross.case.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Cartlann Care")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Super Admin Dashboard")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // User Profile and Logout
                HStack(spacing: 12) {
                    // Stats Summary
                    HStack(spacing: 16) {
                        StatsSummaryItem(
                            title: "Active Seats",
                            value: "1,247",
                            color: .carPrimary
                        )
                        
                        StatsSummaryItem(
                            title: "Monthly Revenue",
                            value: "$45,890",
                            color: .success
                        )
                    }
                    
                    // Profile Button
                    Button(action: onLogout) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.carPrimary.opacity(0.1))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(UserDefaults.standard.string(forKey: "userEmail")?.prefix(1).uppercased() ?? "A")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.carPrimary)
                                )
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            
            // Divider
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1)
        }
    }
}

// MARK: - Stats Summary Item
struct StatsSummaryItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.textSecondary)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
        }
    }
}

// MARK: - Custom Tab Bar
struct SuperAdminTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        ("Tenants", "building.2.fill"),
        ("Subscriptions", "creditcard.fill"),
        ("Inbox", "envelope.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: tab.1)
                            .font(.system(size: 20, weight: selectedTab == index ? .semibold : .medium))
                            .foregroundColor(selectedTab == index ? .carPrimary : .textSecondary)
                        
                        Text(tab.0)
                            .font(.system(size: 11, weight: selectedTab == index ? .semibold : .medium))
                            .foregroundColor(selectedTab == index ? .carPrimary : .textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        selectedTab == index ?
                        Color.carPrimary.opacity(0.1) :
                        Color.clear
                    )
                    .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1),
            alignment: .top
        )
    }
}

#Preview {
    SuperAdminDashboardView()
}
