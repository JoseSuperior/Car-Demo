//
//  MockData.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import Foundation

// MARK: - Data Models
struct Tenant: Identifiable, Codable {
    let id = UUID()
    let practiceName: String
    let email: String
    let logoUrl: String?
    let mainUser: User
    let specialty: String
    let accountType: AccountType
    let activeSeats: Int
    let monthlyRevenue: Double
    let ytdRevenue: Double
    let dateRegistered: Date
    let missedPayment: Bool
    let lastPaymentDate: Date?
}

struct User: Identifiable, Codable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let role: UserRole
    let specialty: String?
    let profileImageUrl: String?
    let isActive: Bool
    let dateJoined: Date
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

struct SubscriptionPlan: Identifiable, Codable {
    let id = UUID()
    let name: String
    let basePrice: Double
    let seatPrice: Double
    let features: [String]
    let isActive: Bool
    let createdDate: Date
}

struct EmailMessage: Identifiable, Codable {
    let id = UUID()
    let from: String
    let to: String
    let subject: String
    let body: String
    let date: Date
    let isRead: Bool
    let isImportant: Bool
    let attachments: [String]
}

// MARK: - Enums
enum AccountType: String, CaseIterable, Codable {
    case trial = "Trial"
    case premium = "Premium"
    case enterprise = "Enterprise"
    
    var displayName: String {
        return self.rawValue
    }
}

enum UserRole: String, CaseIterable, Codable {
    case owner = "Owner"
    case admin = "Admin"
    case user = "User"
    case superAdmin = "SuperAdmin"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Mock Data
struct MockData {
    static let tenants: [Tenant] = [
        Tenant(
            practiceName: "Heart Care Medical Center",
            email: "admin@heartcare.com",
            logoUrl: nil,
            mainUser: User(
                firstName: "Dr. Sarah",
                lastName: "Johnson",
                email: "sarah.johnson@heartcare.com",
                phone: "+1 (555) 123-4567",
                role: .owner,
                specialty: "Cardiology",
                profileImageUrl: nil,
                isActive: true,
                dateJoined: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date()
            ),
            specialty: "Cardiology",
            accountType: .premium,
            activeSeats: 8,
            monthlyRevenue: 692.0,
            ytdRevenue: 4152.0,
            dateRegistered: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
            missedPayment: false,
            lastPaymentDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())
        ),
        Tenant(
            practiceName: "Pediatric Wellness Clinic",
            email: "contact@pedwellness.com",
            logoUrl: nil,
            mainUser: User(
                firstName: "Dr. Michael",
                lastName: "Chen",
                email: "michael.chen@pedwellness.com",
                phone: "+1 (555) 987-6543",
                role: .owner,
                specialty: "Pediatrics",
                profileImageUrl: nil,
                isActive: true,
                dateJoined: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
            ),
            specialty: "Pediatrics",
            accountType: .trial,
            activeSeats: 3,
            monthlyRevenue: 0.0,
            ytdRevenue: 0.0,
            dateRegistered: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
            missedPayment: false,
            lastPaymentDate: nil
        ),
        Tenant(
            practiceName: "Orthopedic Sports Medicine",
            email: "info@orthosports.com",
            logoUrl: nil,
            mainUser: User(
                firstName: "Dr. Emily",
                lastName: "Rodriguez",
                email: "emily.rodriguez@orthosports.com",
                phone: "+1 (555) 456-7890",
                role: .owner,
                specialty: "Orthopedics",
                profileImageUrl: nil,
                isActive: true,
                dateJoined: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date()
            ),
            specialty: "Orthopedics",
            accountType: .premium,
            activeSeats: 12,
            monthlyRevenue: 887.0,
            ytdRevenue: 7096.0,
            dateRegistered: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date(),
            missedPayment: true,
            lastPaymentDate: Calendar.current.date(byAdding: .day, value: -45, to: Date())
        ),
        Tenant(
            practiceName: "Family Medicine Associates",
            email: "admin@familymed.com",
            logoUrl: nil,
            mainUser: User(
                firstName: "Dr. James",
                lastName: "Wilson",
                email: "james.wilson@familymed.com",
                phone: "+1 (555) 321-0987",
                role: .owner,
                specialty: "Family Medicine",
                profileImageUrl: nil,
                isActive: true,
                dateJoined: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            ),
            specialty: "Family Medicine",
            accountType: .enterprise,
            activeSeats: 25,
            monthlyRevenue: 1474.0,
            ytdRevenue: 17688.0,
            dateRegistered: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date(),
            missedPayment: false,
            lastPaymentDate: Calendar.current.date(byAdding: .day, value: -8, to: Date())
        ),
        Tenant(
            practiceName: "Dermatology Specialists",
            email: "contact@dermspec.com",
            logoUrl: nil,
            mainUser: User(
                firstName: "Dr. Lisa",
                lastName: "Thompson",
                email: "lisa.thompson@dermspec.com",
                phone: "+1 (555) 654-3210",
                role: .owner,
                specialty: "Dermatology",
                profileImageUrl: nil,
                isActive: true,
                dateJoined: Calendar.current.date(byAdding: .month, value: -4, to: Date()) ?? Date()
            ),
            specialty: "Dermatology",
            accountType: .premium,
            activeSeats: 6,
            monthlyRevenue: 593.0,
            ytdRevenue: 2372.0,
            dateRegistered: Calendar.current.date(byAdding: .month, value: -4, to: Date()) ?? Date(),
            missedPayment: false,
            lastPaymentDate: Calendar.current.date(byAdding: .day, value: -22, to: Date())
        )
    ]
    
    static let subscriptionPlans: [SubscriptionPlan] = [
        SubscriptionPlan(
            name: "Trial Plan",
            basePrice: 0.0,
            seatPrice: 0.0,
            features: [
                "6 patients maximum",
                "3 visits per patient",
                "Basic recording features",
                "Video comparison",
                "Image annotation",
                "Voice commands"
            ],
            isActive: true,
            createdDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date()
        ),
        SubscriptionPlan(
            name: "Premium Plan",
            basePrice: 299.0,
            seatPrice: 49.0,
            features: [
                "Unlimited patients",
                "Unlimited visits",
                "Advanced recording features",
                "Video comparison",
                "Image annotation",
                "Voice commands",
                "Cloud storage",
                "Team collaboration",
                "Advanced analytics"
            ],
            isActive: true,
            createdDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date()
        ),
        SubscriptionPlan(
            name: "Enterprise Plan",
            basePrice: 599.0,
            seatPrice: 39.0,
            features: [
                "Everything in Premium",
                "Custom integrations",
                "Dedicated support",
                "Advanced security",
                "Custom branding",
                "API access",
                "Priority support"
            ],
            isActive: true,
            createdDate: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        )
    ]
    
    static let emailMessages: [EmailMessage] = [
        EmailMessage(
            from: "sarah.johnson@heartcare.com",
            to: "support@cartlann.com",
            subject: "Question about billing cycle",
            body: "Hi, I have a question about when our billing cycle starts. Could you please clarify?",
            date: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
            isRead: false,
            isImportant: true,
            attachments: []
        ),
        EmailMessage(
            from: "michael.chen@pedwellness.com",
            to: "support@cartlann.com",
            subject: "Trial extension request",
            body: "We're interested in extending our trial period to evaluate more features. Is this possible?",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            isRead: true,
            isImportant: false,
            attachments: []
        ),
        EmailMessage(
            from: "emily.rodriguez@orthosports.com",
            to: "support@cartlann.com",
            subject: "Payment issue - urgent",
            body: "Our payment failed last month. We need to update our payment method urgently to avoid service interruption.",
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            isRead: true,
            isImportant: true,
            attachments: ["payment_receipt.pdf"]
        ),
        EmailMessage(
            from: "james.wilson@familymed.com",
            to: "support@cartlann.com",
            subject: "Feature request - team management",
            body: "We would like to request enhanced team management features for our large practice.",
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            isRead: true,
            isImportant: false,
            attachments: []
        )
    ]
    
    static let tenantUsers: [User] = [
        User(
            firstName: "Dr. John",
            lastName: "Smith",
            email: "john.smith@heartcare.com",
            phone: "+1 (555) 111-2222",
            role: .admin,
            specialty: "Cardiology",
            profileImageUrl: nil,
            isActive: true,
            dateJoined: Calendar.current.date(byAdding: .month, value: -5, to: Date()) ?? Date()
        ),
        User(
            firstName: "Nurse Mary",
            lastName: "Davis",
            email: "mary.davis@heartcare.com",
            phone: "+1 (555) 333-4444",
            role: .user,
            specialty: nil,
            profileImageUrl: nil,
            isActive: true,
            dateJoined: Calendar.current.date(byAdding: .month, value: -4, to: Date()) ?? Date()
        ),
        User(
            firstName: "Dr. Robert",
            lastName: "Brown",
            email: "robert.brown@heartcare.com",
            phone: "+1 (555) 555-6666",
            role: .user,
            specialty: "Cardiology",
            profileImageUrl: nil,
            isActive: false,
            dateJoined: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        )
    ]
}
