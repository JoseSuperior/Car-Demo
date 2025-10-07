//
//  TenantDetailView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantDetailView: View {
    let tenant: Tenant
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var showingEditTenant = false
    @State private var showingDeleteAlert = false
    @State private var showingInviteUser = false
    @State private var showingComposeEmail = false
    
    // Users for this specific tenant
    private var tenantUsers: [User] {
        MockData.getUsersForTenant(tenant)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                TenantDetailHeaderView(
                    tenant: tenant,
                    onEdit: { showingEditTenant = true },
                    onDelete: { showingDeleteAlert = true },
                    onComposeEmail: { showingComposeEmail = true },
                    onDismiss: { dismiss() }
                )
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    TenantOverviewTab(tenant: tenant, users: tenantUsers)
                        .tag(0)
                    
                    TenantUsersTab(tenant: tenant, users: tenantUsers, onInviteUser: { showingInviteUser = true })
                        .tag(1)
                    
                    TenantBillingTab(tenant: tenant)
                        .tag(2)
                    
                    TenantSettingsTab(tenant: tenant)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Tab Bar
                TenantDetailTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .background(Color.backgroundPrimary)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingEditTenant) {
            EditTenantView(tenant: tenant)
        }
        .sheet(isPresented: $showingInviteUser) {
            TenantDetailInviteUserView(tenant: tenant)
        }
        .sheet(isPresented: $showingComposeEmail) {
            TenantDetailComposeEmailView(tenant: tenant)
        }
        .alert("Delete Tenant", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle delete action
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \(tenant.practiceName)? This action cannot be undone.")
        }
    }
}

// MARK: - Header View
struct TenantDetailHeaderView: View {
    let tenant: Tenant
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onComposeEmail: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            HStack {
                Button(action: onDismiss) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.carPrimary)
                }
                
                Spacer()
                
                Text("Tenant Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Menu {
                    Button {
                        onEdit()
                    } label: {
                        Label("Edit Tenant", systemImage: "pencil")
                    }
                    
                    Button {
                        onComposeEmail()
                    } label: {
                        Label("Send Email", systemImage: "envelope")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete Tenant", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.carPrimary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // Tenant Info Card
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Tenant Logo/Avatar
                    AsyncImage(url: URL(string: tenant.logoUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.carPrimary.opacity(0.1))
                            .overlay(
                                Text(tenant.practiceName.prefix(1).uppercased())
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.carPrimary)
                            )
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(tenant.practiceName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            if tenant.missedPayment {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.error)
                            }
                        }
                        
                        Text(tenant.specialty)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        HStack(spacing: 8) {
                            Text(tenant.accountType.displayName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(tenant.accountType == .trial ? Color.warning : Color.carPrimary)
                                .cornerRadius(6)
                            
                            Text("Active since \(tenant.dateRegistered, style: .date)")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Quick Stats
                HStack(spacing: 0) {
                    StatItemView(
                        title: "Active Seats",
                        value: "\(tenant.activeSeats)",
                        icon: "person.2.fill",
                        color: .carPrimary
                    )
                    
                    Divider()
                        .frame(height: 40)
                    
                    StatItemView(
                        title: "Monthly Revenue",
                        value: "$\(String(format: "%.0f", tenant.monthlyRevenue))",
                        icon: "dollarsign.circle.fill",
                        color: .success
                    )
                    
                    Divider()
                        .frame(height: 40)
                    
                    StatItemView(
                        title: "YTD Revenue",
                        value: "$\(String(format: "%.0f", tenant.ytdRevenue))",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .success
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Stat Item View
struct StatItemView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Tab Bar
struct TenantDetailTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        ("Overview", "info.circle"),
        ("Users", "person.2"),
        ("Billing", "creditcard"),
        ("Settings", "gearshape")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 6) {
                        Image(systemName: tabs[index].1)
                            .font(.system(size: 20, weight: selectedTab == index ? .semibold : .medium))
                        
                        Text(tabs[index].0)
                            .font(.system(size: 12, weight: selectedTab == index ? .semibold : .medium))
                    }
                    .foregroundColor(selectedTab == index ? .carPrimary : .textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top
        )
    }
}

// MARK: - Overview Tab
struct TenantOverviewTab: View {
    let tenant: Tenant
    let users: [User]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Contact Information
                InfoSectionView(title: "Contact Information") {
                    VStack(spacing: 12) {
                        InfoRowView(
                            icon: "envelope.fill",
                            title: "Email",
                            value: tenant.email,
                            color: .carPrimary
                        )
                        
                        InfoRowView(
                            icon: "person.fill",
                            title: "Main Contact",
                            value: tenant.mainUser.fullName,
                            color: .carPrimary
                        )
                        
                        if let phone = tenant.mainUser.phone {
                            InfoRowView(
                                icon: "phone.fill",
                                title: "Phone",
                                value: phone,
                                color: .carPrimary
                            )
                        }
                    }
                }
                
                // Account Status
                InfoSectionView(title: "Account Status") {
                    VStack(spacing: 12) {
                        InfoRowView(
                            icon: "checkmark.circle.fill",
                            title: "Status",
                            value: tenant.missedPayment ? "Payment Issue" : "Active",
                            color: tenant.missedPayment ? .error : .success
                        )
                        
                        if let lastPayment = tenant.lastPaymentDate {
                            InfoRowView(
                                icon: "calendar.circle.fill",
                                title: "Last Payment",
                                value: lastPayment.formatted(date: .abbreviated, time: .omitted),
                                color: .textSecondary
                            )
                        }
                        
                        InfoRowView(
                            icon: "person.2.circle.fill",
                            title: "Total Users",
                            value: "\(users.count)",
                            color: .carPrimary
                        )
                    }
                }
                
                // Recent Activity
                InfoSectionView(title: "Recent Activity") {
                    VStack(spacing: 12) {
                        ActivityRowView(
                            icon: "person.badge.plus",
                            title: "User joined",
                            subtitle: "\(users.last?.fullName ?? "Unknown") joined the team",
                            date: users.last?.dateJoined ?? Date(),
                            color: .success
                        )
                        
                        ActivityRowView(
                            icon: "dollarsign.circle",
                            title: "Payment processed",
                            subtitle: "Monthly subscription payment",
                            date: tenant.lastPaymentDate ?? Date(),
                            color: .carPrimary
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Users Tab
struct TenantUsersTab: View {
    let tenant: Tenant
    let users: [User]
    let onInviteUser: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Add User button
            HStack {
                Text("Team Members (\(users.count))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: onInviteUser) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Invite User")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.carPrimary)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.backgroundPrimary)
            
            // Users List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(users) { user in
                        TenantDetailUserRowView(user: user, isOwner: user.id == tenant.mainUser.id)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.backgroundPrimary)
        }
    }
}

// MARK: - Billing Tab
struct TenantBillingTab: View {
    let tenant: Tenant
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Current Plan
                InfoSectionView(title: "Current Plan") {
                    VStack(spacing: 12) {
                        InfoRowView(
                            icon: "crown.fill",
                            title: "Plan Type",
                            value: tenant.accountType.displayName,
                            color: tenant.accountType == .trial ? .warning : .carPrimary
                        )
                        
                        InfoRowView(
                            icon: "dollarsign.circle.fill",
                            title: "Monthly Cost",
                            value: "$\(String(format: "%.0f", tenant.monthlyRevenue))",
                            color: .success
                        )
                        
                        InfoRowView(
                            icon: "person.2.fill",
                            title: "Seats Included",
                            value: "\(tenant.activeSeats)",
                            color: .carPrimary
                        )
                    }
                }
                
                // Payment History
                InfoSectionView(title: "Payment History") {
                    VStack(spacing: 12) {
                        if let lastPayment = tenant.lastPaymentDate {
                            PaymentRowView(
                                amount: tenant.monthlyRevenue,
                                date: lastPayment,
                                status: .success
                            )
                        }
                        
                        // Mock previous payments
                        PaymentRowView(
                            amount: tenant.monthlyRevenue,
                            date: Calendar.current.date(byAdding: .month, value: -1, to: tenant.lastPaymentDate ?? Date()) ?? Date(),
                            status: .success
                        )
                        
                        PaymentRowView(
                            amount: tenant.monthlyRevenue,
                            date: Calendar.current.date(byAdding: .month, value: -2, to: tenant.lastPaymentDate ?? Date()) ?? Date(),
                            status: .success
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Settings Tab
struct TenantSettingsTab: View {
    let tenant: Tenant
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Account Settings
                InfoSectionView(title: "Account Settings") {
                    VStack(spacing: 12) {
                        SettingsRowView(
                            icon: "building.2",
                            title: "Practice Name",
                            value: tenant.practiceName
                        )
                        
                        SettingsRowView(
                            icon: "stethoscope",
                            title: "Specialty",
                            value: tenant.specialty
                        )
                        
                        SettingsRowView(
                            icon: "envelope",
                            title: "Contact Email",
                            value: tenant.email
                        )
                    }
                }
                
                // System Information
                InfoSectionView(title: "System Information") {
                    VStack(spacing: 12) {
                        InfoRowView(
                            icon: "calendar.circle",
                            title: "Date Registered",
                            value: tenant.dateRegistered.formatted(date: .abbreviated, time: .omitted),
                            color: .textSecondary
                        )
                        
                        InfoRowView(
                            icon: "chart.bar.fill",
                            title: "Total Revenue",
                            value: "$\(String(format: "%.0f", tenant.ytdRevenue))",
                            color: .success
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Supporting Views

struct InfoSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

struct InfoRowView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct ActivityRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let date: Date
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text(date, style: .relative)
                .font(.system(size: 12))
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct TenantDetailUserRowView: View {
    let user: User
    let isOwner: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // User Avatar
            AsyncImage(url: URL(string: user.profileImageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.carPrimary.opacity(0.1))
                    .overlay(
                        Text(user.firstName.prefix(1).uppercased())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.carPrimary)
                    )
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(user.fullName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    if isOwner {
                        Text("OWNER")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.carPrimary)
                            .cornerRadius(4)
                    }
                }
                
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                
                if let specialty = user.specialty {
                    Text(specialty)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Circle()
                    .fill(user.isActive ? Color.success : Color.error)
                    .frame(width: 8, height: 8)
                
                Text(user.isActive ? "Active" : "Inactive")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(user.isActive ? .success : .error)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct PaymentRowView: View {
    let amount: Double
    let date: Date
    let status: PaymentStatus
    
    enum PaymentStatus {
        case success, failed, pending
        
        var color: Color {
            switch self {
            case .success: return .success
            case .failed: return .error
            case .pending: return .warning
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .failed: return "xmark.circle.fill"
            case .pending: return "clock.circle.fill"
            }
        }
        
        var title: String {
            switch self {
            case .success: return "Paid"
            case .failed: return "Failed"
            case .pending: return "Pending"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: status.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(status.color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("$\(String(format: "%.0f", amount))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Text(status.title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(status.color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.carPrimary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
                
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Modal Views (Placeholders)

struct EditTenantView: View {
    let tenant: Tenant
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Tenant")
                    .font(.title)
                Text("Edit functionality for \(tenant.practiceName)")
            }
            .navigationTitle("Edit Tenant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

struct TenantDetailInviteUserView: View {
    let tenant: Tenant
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Invite User")
                    .font(.title)
                Text("Invite user to \(tenant.practiceName)")
            }
            .navigationTitle("Invite User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") { dismiss() }
                }
            }
        }
    }
}

struct TenantDetailComposeEmailView: View {
    let tenant: Tenant
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Compose Email")
                    .font(.title)
                Text("Send email to \(tenant.practiceName)")
            }
            .navigationTitle("Compose Email")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    TenantDetailView(tenant: MockData.tenants[0])
}
