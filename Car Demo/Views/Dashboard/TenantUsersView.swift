//
//  TenantUsersView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct TenantUsersView: View {
    @State private var searchText = ""
    @State private var sortBy: UserSortOption = .firstName
    @State private var sortOrder: SortOrder = .ascending
    @State private var showingAddUser = false
    @State private var selectedUser: User?
    @State private var showingUserDetail = false
    
    private let mockUsers = MockData.tenantUsers
    
    private var filteredAndSortedUsers: [User] {
        let filtered = searchText.isEmpty ? mockUsers : mockUsers.filter { user in
            user.fullName.localizedCaseInsensitiveContains(searchText) ||
            user.email.localizedCaseInsensitiveContains(searchText) ||
            (user.specialty?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
        
        return filtered.sorted { user1, user2 in
            let comparison: ComparisonResult
            switch sortBy {
            case .firstName:
                comparison = user1.firstName.localizedCompare(user2.firstName)
            case .lastName:
                comparison = user1.lastName.localizedCompare(user2.lastName)
            case .email:
                comparison = user1.email.localizedCompare(user2.email)
            case .role:
                comparison = user1.role.rawValue.localizedCompare(user2.role.rawValue)
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
                    
                    TextField("Search users by name or email...", text: $searchText)
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
                            Button("First Name") { sortBy = .firstName }
                            Button("Last Name") { sortBy = .lastName }
                            Button("Email") { sortBy = .email }
                            Button("Role") { sortBy = .role }
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
                    
                    // Add User Button
                    Button(action: { showingAddUser = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text("Invite User")
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
            
            // Users List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredAndSortedUsers) { user in
                        UserRowView(user: user)
                            .onTapGesture {
                                selectedUser = user
                                showingUserDetail = true
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.backgroundPrimary)
        }
        .sheet(isPresented: $showingAddUser) {
            InviteUserView()
        }
        .sheet(isPresented: $showingUserDetail) {
            if let user = selectedUser {
                UserDetailView(user: user)
            }
        }
    }
}

// MARK: - User Row View
struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
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
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.carPrimary)
                    )
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(user.fullName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Status Indicator
                    Circle()
                        .fill(user.isActive ? Color.success : Color.gray400)
                        .frame(width: 8, height: 8)
                }
                
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Text(user.role.displayName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(roleColor(for: user.role))
                        .cornerRadius(6)
                    
                    if let specialty = user.specialty {
                        Text("•")
                            .foregroundColor(.textSecondary)
                        
                        Text(specialty)
                            .font(.system(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(user.isActive ? "Active" : "Inactive")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(user.isActive ? .success : .textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func roleColor(for role: UserRole) -> Color {
        switch role {
        case .owner:
            return Color.carPrimary
        case .admin:
            return Color.warning
        case .user:
            return Color.gray500
        case .superAdmin:
            return Color.error
        }
    }
}

// MARK: - User Detail View
struct UserDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let user: User
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // User Avatar and Basic Info
                    VStack(spacing: 16) {
                        AsyncImage(url: URL(string: user.profileImageUrl ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color.carPrimary.opacity(0.1))
                                .overlay(
                                    Text(user.firstName.prefix(1).uppercased())
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(.carPrimary)
                                )
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        
                        VStack(spacing: 8) {
                            Text(user.fullName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text(user.email)
                                .font(.system(size: 16))
                                .foregroundColor(.textSecondary)
                            
                            HStack(spacing: 12) {
                                Text(user.role.displayName)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(roleColor(for: user.role))
                                    .cornerRadius(8)
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(user.isActive ? Color.success : Color.gray400)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(user.isActive ? "Active" : "Inactive")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(user.isActive ? .success : .textSecondary)
                                }
                            }
                        }
                    }
                    
                    // User Details
                    VStack(spacing: 16) {
                        if let phone = user.phone {
                            DetailRow(title: "Phone", value: phone, icon: "phone.fill")
                        }
                        
                        if let specialty = user.specialty {
                            DetailRow(title: "Specialty", value: specialty, icon: "stethoscope")
                        }
                        
                        DetailRow(
                            title: "Date Joined",
                            value: DateFormatter.mediumDate.string(from: user.dateJoined),
                            icon: "calendar"
                        )
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        CustomButton(
                            title: "Edit User",
                            action: { isEditing = true },
                            style: .primary,
                            size: .large
                        )
                        
                        CustomButton(
                            title: user.isActive ? "Deactivate User" : "Activate User",
                            action: {
                                // Handle activation toggle
                            },
                            style: .secondary,
                            size: .large
                        )
                        
                        if user.role != .owner {
                            CustomButton(
                                title: "Remove User",
                                action: {
                                    // Handle user removal
                                },
                                style: .destructive,
                                size: .large
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.carPrimary)
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditUserView(user: user)
        }
    }
    
    private func roleColor(for role: UserRole) -> Color {
        switch role {
        case .owner:
            return Color.carPrimary
        case .admin:
            return Color.warning
        case .user:
            return Color.gray500
        case .superAdmin:
            return Color.error
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.carPrimary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.textSecondary)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

// MARK: - Invite User View
struct InviteUserView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var role: UserRole = .user
    @State private var specialty = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Invite New User")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Send an invitation to a new team member")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Email Address",
                            placeholder: "user@example.com",
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Role")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            Menu {
                                Button("User") { role = .user }
                                Button("Admin") { role = .admin }
                            } label: {
                                HStack {
                                    Text(role.displayName)
                                        .font(.system(size: 16))
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.backgroundSecondary)
                                .cornerRadius(12)
                            }
                        }
                        
                        CustomTextField(
                            title: "Specialty (Optional)",
                            placeholder: "Cardiology",
                            text: $specialty
                        )
                    }
                    
                    CustomButton(
                        title: "Send Invitation",
                        action: {
                            // Mock invitation
                            dismiss()
                        },
                        style: .primary,
                        size: .large,
                        isDisabled: email.isEmpty || firstName.isEmpty || lastName.isEmpty
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

// MARK: - Edit User View
struct EditUserView: View {
    @Environment(\.dismiss) private var dismiss
    let user: User
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var specialty = ""
    @State private var role: UserRole = .user
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Edit User")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Update user information")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
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
                            title: "Email Address",
                            placeholder: "user@example.com",
                            text: $email,
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )
                        
                        CustomTextField(
                            title: "Phone Number",
                            placeholder: "+1 (555) 123-4567",
                            text: $phone,
                            keyboardType: .phonePad
                        )
                        
                        CustomTextField(
                            title: "Specialty",
                            placeholder: "Cardiology",
                            text: $specialty
                        )
                        
                        if user.role != .owner {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Role")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                
                                Menu {
                                    Button("User") { role = .user }
                                    Button("Admin") { role = .admin }
                                } label: {
                                    HStack {
                                        Text(role.displayName)
                                            .font(.system(size: 16))
                                            .foregroundColor(.textPrimary)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(.textSecondary)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    CustomButton(
                        title: "Save Changes",
                        action: {
                            // Mock save
                            dismiss()
                        },
                        style: .primary,
                        size: .large
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
        .onAppear {
            // Pre-populate fields
            firstName = user.firstName
            lastName = user.lastName
            email = user.email
            phone = user.phone ?? ""
            specialty = user.specialty ?? ""
            role = user.role
        }
    }
}

// MARK: - User Sort Option Enum
enum UserSortOption: CaseIterable {
    case firstName
    case lastName
    case email
    case role
    
    var displayName: String {
        switch self {
        case .firstName: return "First Name"
        case .lastName: return "Last Name"
        case .email: return "Email"
        case .role: return "Role"
        }
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

#Preview {
    TenantUsersView()
}
