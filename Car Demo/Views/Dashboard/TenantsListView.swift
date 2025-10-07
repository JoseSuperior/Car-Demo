//
//  TenantsListView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantsListView: View {
    @State private var searchText = ""
    @State private var sortBy: SortOption = .practiceName
    @State private var sortOrder: SortOrder = .ascending
    @State private var showingAddTenant = false
    @State private var selectedTenant: Tenant?
    
    private let mockTenants = MockData.tenants
    
    private var filteredAndSortedTenants: [Tenant] {
        let filtered = searchText.isEmpty ? mockTenants : mockTenants.filter { tenant in
            tenant.practiceName.localizedCaseInsensitiveContains(searchText) ||
            tenant.mainUser.email.localizedCaseInsensitiveContains(searchText) ||
            tenant.mainUser.fullName.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { tenant1, tenant2 in
            let comparison: ComparisonResult
            switch sortBy {
            case .practiceName:
                comparison = tenant1.practiceName.localizedCompare(tenant2.practiceName)
            case .dateRegistered:
                comparison = tenant1.dateRegistered.compare(tenant2.dateRegistered)
            case .monthlyRevenue:
                comparison = tenant1.monthlyRevenue < tenant2.monthlyRevenue ? .orderedAscending :
                           tenant1.monthlyRevenue > tenant2.monthlyRevenue ? .orderedDescending : .orderedSame
            }
            
            return sortOrder == .ascending ? comparison == .orderedAscending : comparison == .orderedDescending
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Controls
            VStack(spacing: 16) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("Search tenants by name or email...", text: $searchText)
                        .font(.system(size: 16))
                        .foregroundColor(.textPrimary)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
                
                // Sort Controls and Add Button
                HStack {
                    // Sort Controls
                    HStack(spacing: 12) {
                        Menu {
                            Button("Practice Name") { sortBy = .practiceName }
                            Button("Date Registered") { sortBy = .dateRegistered }
                            Button("Monthly Revenue") { sortBy = .monthlyRevenue }
                        } label: {
                            HStack(spacing: 6) {
                                Text("Sort: \(sortBy.displayName)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.backgroundSecondary)
                            .cornerRadius(8)
                        }
                        
                        Button(action: {
                            sortOrder = sortOrder == .ascending ? .descending : .ascending
                        }) {
                            Image(systemName: sortOrder == .ascending ? "arrow.up" : "arrow.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.carPrimary)
                                .frame(width: 32, height: 32)
                                .background(Color.carPrimary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer()
                    
                    // Add Tenant Button
                    Button(action: { showingAddTenant = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text("Add Tenant")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.carPrimary)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.backgroundPrimary)
            
            // Tenants List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredAndSortedTenants) { tenant in
                        TenantRowView(tenant: tenant)
                            .onTapGesture {
                                selectedTenant = tenant
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.backgroundPrimary)
        }
        .sheet(isPresented: $showingAddTenant) {
            AddTenantView()
        }
        .fullScreenCover(item: $selectedTenant) { tenant in
            TenantDetailView(tenant: tenant)
        }
    }
}

// MARK: - Tenant Row View
struct TenantRowView: View {
    let tenant: Tenant
    
    var body: some View {
        VStack(spacing: 0) {
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
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.carPrimary)
                        )
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                // Tenant Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tenant.practiceName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        // Payment Status Indicator
                        if tenant.missedPayment {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.error)
                        }
                    }
                    
                    Text(tenant.mainUser.email)
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    HStack {
                        Text(tenant.mainUser.fullName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textPrimary)
                        
                        Text("•")
                            .foregroundColor(.textSecondary)
                        
                        Text(tenant.specialty)
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Stats
                VStack(alignment: .trailing, spacing: 4) {
                    Text(tenant.accountType.displayName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tenant.accountType == .trial ? Color.warning : Color.carPrimary)
                        .cornerRadius(6)
                    
                    Text("\(tenant.activeSeats) seats")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    Text("$\(String(format: "%.0f", tenant.monthlyRevenue))/mo")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.success)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Add Tenant View
struct AddTenantView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var practiceName = ""
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var specialty = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Add New Tenant")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Create a new tenant account for a medical practice")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Practice Name",
                            placeholder: "Enter practice name",
                            text: $practiceName
                        )
                        
                        CustomTextField(
                            title: "Admin Email",
                            placeholder: "admin@practice.com",
                            text: $email,
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )
                        
                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "First Name",
                                placeholder: "John",
                                text: $firstName
                            )
                            
                            CustomTextField(
                                title: "Last Name",
                                placeholder: "Doe",
                                text: $lastName
                            )
                        }
                        
                        CustomTextField(
                            title: "Specialty",
                            placeholder: "Cardiology",
                            text: $specialty
                        )
                    }
                    
                    CustomButton(
                        title: "Create Tenant",
                        action: {
                            // Mock creation
                            dismiss()
                        },
                        style: .primary,
                        size: .large,
                        isDisabled: practiceName.isEmpty || email.isEmpty || firstName.isEmpty || lastName.isEmpty
                    )
                    .padding(.top, 20)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.carPrimary)
                }
            }
        }
    }
}

// MARK: - Enums
enum SortOption: CaseIterable {
    case practiceName
    case dateRegistered
    case monthlyRevenue
    
    var displayName: String {
        switch self {
        case .practiceName: return "Practice Name"
        case .dateRegistered: return "Date Registered"
        case .monthlyRevenue: return "Monthly Revenue"
        }
    }
}

enum SortOrder {
    case ascending
    case descending
}

#Preview {
    TenantsListView()
}
