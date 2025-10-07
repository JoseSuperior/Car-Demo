//
//  SuperAdminDashboardView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct SuperAdminDashboardView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false
    @State private var switchingToTenantView = false
    @State private var showingTenantSelector = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                SuperAdminHeaderView(
                    onLogout: {
                        showingLogoutAlert = true
                    },
                    onSwitchToTenantView: {
                        showingTenantSelector = true
                    }
                )
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    TenantsListView()
                        .tag(0)
                    
                    SubscriptionManagementView()
                        .tag(1)
                    
                    FileManagerView()
                        .tag(2)
                    
                    InboxView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Tab Bar
                SuperAdminTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .background(Color.backgroundPrimary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $switchingToTenantView) {
            TenantAdminDashboardView()
        }
        .sheet(isPresented: $showingTenantSelector) {
            TenantSelectorView()
        }
        .onChange(of: userSession.currentTenant) { _ in
            if userSession.currentTenant != nil {
                switchingToTenantView = true
            }
        }
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
        userSession.logout()
        NotificationCenter.default.post(name: .init("LoginStateChanged"), object: nil)
    }
}

// MARK: - Super Admin Header
struct SuperAdminHeaderView: View {
    @EnvironmentObject var userSession: UserSession
    let onLogout: () -> Void
    let onSwitchToTenantView: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
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
                            .frame(width: 48, height: 48)
                            .shadow(color: Color.carPrimary.opacity(0.3), radius: 8, x: 0, y: 2)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cartlann Care")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "crown")
                                .font(.system(size: 11, weight: .medium))
                            
                            Text("Super Admin Dashboard")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Stats and Profile
                HStack(spacing: 12) {
                    // Stats Summary
                    HStack(spacing: 20) {
                        StatsSummaryItem(
                            title: "Active Seats",
                            value: "\(MockData.totalActiveSeats)",
                            color: .carPrimary
                        )
                        
                        Rectangle()
                            .fill(Color.gray200)
                            .frame(width: 1, height: 32)
                        
                        StatsSummaryItem(
                            title: "Monthly Revenue",
                            value: String(format: "$%.0f", MockData.totalMonthlyRevenue),
                            color: .success
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.backgroundSecondary.opacity(0.5))
                    .cornerRadius(12)
                    
                    // Profile Menu Button
                    Menu {
                        // User Info Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Super Admin")
                                .font(.system(size: 14, weight: .semibold))
                            Text(userSession.displayEmail)
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                        
                        // Switch to Tenant View
                        Button {
                            onSwitchToTenantView()
                        } label: {
                            Label("Switch to Tenant View", systemImage: "building.2")
                        }
                        
                        Divider()
                        
                        // Settings
                        Button {
                            // Navigate to settings
                        } label: {
                            Label("System Settings", systemImage: "gearshape")
                        }
                        
                        // Help & Support
                        Button {
                            // Handle help
                        } label: {
                            Label("Help & Documentation", systemImage: "questionmark.circle")
                        }
                        
                        Divider()
                        
                        // Sign Out
                        Button(role: .destructive) {
                            onLogout()
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        HStack(spacing: 10) {
                            // Avatar with crown badge
                            ZStack(alignment: .topTrailing) {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.carPrimary.opacity(0.15),
                                                Color.carPrimary.opacity(0.1)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Text(userSession.displayName.prefix(1).uppercased())
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(.carPrimary)
                                    )
                                
                                // Crown badge
                                Circle()
                                    .fill(Color.warning)
                                    .frame(width: 14, height: 14)
                                    .overlay(
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 7, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .offset(x: 2, y: -2)
                            }
                            
                            // Chevron
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.backgroundSecondary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                Color.white
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            )
            
            // Divider
            Rectangle()
                .fill(Color.gray200.opacity(0.5))
                .frame(height: 0.5)
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
        ("Files", "folder.fill"),
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
