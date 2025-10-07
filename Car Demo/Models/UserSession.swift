//
//  UserSession.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import Foundation
import Combine

// MARK: - User Session Manager
class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var currentTenant: Tenant?
    @Published var userRole: UserRole = .user
    
    private init() {
        loadSession()
    }
    
    // MARK: - Session Management
    
    func login(email: String, password: String) -> Bool {
        // Mock login logic - in real app this would call an API
        
        // Determine user role based on email for demo purposes
        let isSuperAdmin = email.lowercased().contains("admin") || email.lowercased().contains("super")
        
        if isSuperAdmin {
            // Super Admin User
            self.currentUser = User(
                firstName: "Super",
                lastName: "Admin",
                email: email,
                phone: "+1 (555) 000-0000",
                role: .superAdmin,
                specialty: nil,
                profileImageUrl: nil,
                isActive: true,
                dateJoined: Date()
            )
            self.userRole = .superAdmin
            self.currentTenant = nil // Super admin doesn't belong to a specific tenant
        } else {
            // Regular tenant user - assign to first tenant for demo
            let tenant = MockData.tenants.first!
            self.currentTenant = tenant
            
            // Create user based on tenant's main user but with provided email
            self.currentUser = User(
                firstName: tenant.mainUser.firstName,
                lastName: tenant.mainUser.lastName,
                email: email,
                phone: tenant.mainUser.phone,
                role: tenant.mainUser.role,
                specialty: tenant.mainUser.specialty,
                profileImageUrl: tenant.mainUser.profileImageUrl,
                isActive: true,
                dateJoined: tenant.mainUser.dateJoined
            )
            self.userRole = tenant.mainUser.role
        }
        
        self.isLoggedIn = true
        saveSession()
        return true
    }
    
    func logout() {
        self.isLoggedIn = false
        self.currentUser = nil
        self.currentTenant = nil
        self.userRole = .user
        clearSession()
    }
    
    func switchToSuperAdminView() -> Bool {
        // Only allow if current user has super admin privileges
        guard let user = currentUser, user.role == .superAdmin else {
            return false
        }
        
        // Switch to super admin context
        self.currentTenant = nil
        self.userRole = .superAdmin
        saveSession()
        return true
    }
    
    func switchToTenantView(tenant: Tenant? = nil) -> Bool {
        // Super admins can switch to any tenant view
        if currentUser?.role == .superAdmin {
            self.currentTenant = tenant ?? MockData.tenants.first!
            self.userRole = .owner // Super admin acts as owner when viewing tenant
            saveSession()
            return true
        }
        
        // Regular users can only view their own tenant
        guard let userTenant = currentTenant else { return false }
        self.currentTenant = userTenant
        saveSession()
        return true
    }
    
    // MARK: - Helper Properties
    
    var isSuperAdmin: Bool {
        return currentUser?.role == .superAdmin
    }
    
    var canSwitchViews: Bool {
        return isSuperAdmin
    }
    
    var displayName: String {
        return currentUser?.fullName ?? "User"
    }
    
    var displayEmail: String {
        return currentUser?.email ?? ""
    }
    
    // MARK: - Persistence
    
    private func saveSession() {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        UserDefaults.standard.set(isSuperAdmin, forKey: "isSuperAdmin")
        UserDefaults.standard.set(currentUser?.email, forKey: "userEmail")
        UserDefaults.standard.set(userRole.rawValue, forKey: "userRole")
        
        if let userData = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
        
        if let tenantData = try? JSONEncoder().encode(currentTenant) {
            UserDefaults.standard.set(tenantData, forKey: "currentTenant")
        }
    }
    
    private func loadSession() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        }
        
        if let tenantData = UserDefaults.standard.data(forKey: "currentTenant"),
           let tenant = try? JSONDecoder().decode(Tenant.self, from: tenantData) {
            self.currentTenant = tenant
        }
        
        if let roleString = UserDefaults.standard.string(forKey: "userRole"),
           let role = UserRole(rawValue: roleString) {
            self.userRole = role
        }
    }
    
    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "isSuperAdmin")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userRole")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "currentTenant")
    }
}
