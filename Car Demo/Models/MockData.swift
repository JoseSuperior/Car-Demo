//
//  MockData.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import Foundation

// MARK: - Data Models
struct Tenant: Identifiable, Codable, Equatable {
    var id = UUID()
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

struct User: Identifiable, Codable, Equatable {
    var id = UUID()
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

struct SubscriptionPlan: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let basePrice: Double
    let seatPrice: Double
    let features: [String]
    let isActive: Bool
    let createdDate: Date
}

struct EmailMessage: Identifiable, Codable, Equatable {
    var id = UUID()
    let from: String
    let to: String
    let subject: String
    let body: String
    let date: Date
    let isRead: Bool
    let isImportant: Bool
    let attachments: [String]
}

struct FileItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: FileType
    let size: Int64 // Size in bytes
    let dateCreated: Date
    let dateModified: Date
    let owner: String
    let tenantId: UUID?
    let isShared: Bool
    let downloadCount: Int
    let path: String
    
    var sizeFormatted: String {
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}

enum FileType: String, CaseIterable, Codable {
    case document = "document"
    case image = "image"
    case video = "video"
    case audio = "audio"
    case pdf = "pdf"
    case spreadsheet = "spreadsheet"
    case presentation = "presentation"
    case archive = "archive"
    case other = "other"
    
    var icon: String {
        switch self {
        case .document: return "doc.text.fill"
        case .image: return "photo.fill"
        case .video: return "video.fill"
        case .audio: return "music.note"
        case .pdf: return "doc.richtext.fill"
        case .spreadsheet: return "tablecells.fill"
        case .presentation: return "rectangle.stack.fill"
        case .archive: return "archivebox.fill"
        case .other: return "doc.fill"
        }
    }
    
    var color: String {
        switch self {
        case .document: return "blue"
        case .image: return "green"
        case .video: return "purple"
        case .audio: return "orange"
        case .pdf: return "red"
        case .spreadsheet: return "teal"
        case .presentation: return "indigo"
        case .archive: return "gray"
        case .other: return "gray"
        }
    }
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
    
    // MARK: - Super Admin Data
    static let superAdminUser = User(
        firstName: "Super",
        lastName: "Admin",
        email: "superadmin@cartlann.com",
        phone: "+1 (555) 000-0000",
        role: .superAdmin,
        specialty: nil,
        profileImageUrl: nil,
        isActive: true,
        dateJoined: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date()
    )
    
    // MARK: - Global Statistics for Super Admin
    static var totalActiveSeats: Int {
        return tenants.reduce(0) { $0 + $1.activeSeats }
    }
    
    static var totalMonthlyRevenue: Double {
        return tenants.reduce(0) { $0 + $1.monthlyRevenue }
    }
    
    static var totalYTDRevenue: Double {
        return tenants.reduce(0) { $0 + $1.ytdRevenue }
    }
    
    static var activeTenants: Int {
        return tenants.filter { !$0.missedPayment }.count
    }
    
    static var tenantsWithIssues: Int {
        return tenants.filter { $0.missedPayment }.count
    }
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
        ),
        User(
            firstName: "Dr. Amanda",
            lastName: "Wilson",
            email: "amanda.wilson@pedwellness.com",
            phone: "+1 (555) 777-8888",
            role: .user,
            specialty: "Pediatrics",
            profileImageUrl: nil,
            isActive: true,
            dateJoined: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date()
        ),
        User(
            firstName: "Dr. Kevin",
            lastName: "Martinez",
            email: "kevin.martinez@orthosports.com",
            phone: "+1 (555) 999-0000",
            role: .admin,
            specialty: "Orthopedics",
            profileImageUrl: nil,
            isActive: true,
            dateJoined: Calendar.current.date(byAdding: .month, value: -7, to: Date()) ?? Date()
        ),
        User(
            firstName: "Nurse Jennifer",
            lastName: "Lee",
            email: "jennifer.lee@familymed.com",
            phone: "+1 (555) 123-9876",
            role: .user,
            specialty: nil,
            profileImageUrl: nil,
            isActive: true,
            dateJoined: Calendar.current.date(byAdding: .month, value: -9, to: Date()) ?? Date()
        ),
        User(
            firstName: "Dr. Patricia",
            lastName: "Garcia",
            email: "patricia.garcia@dermspec.com",
            phone: "+1 (555) 456-1234",
            role: .user,
            specialty: "Dermatology",
            profileImageUrl: nil,
            isActive: true,
            dateJoined: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        )
    ]
    
    // MARK: - Helper function to get users for a specific tenant
    static func getUsersForTenant(_ tenant: Tenant) -> [User] {
        switch tenant.practiceName {
        case "Heart Care Medical Center":
            return [
                tenant.mainUser,
                tenantUsers[0], // Dr. John Smith
                tenantUsers[1], // Nurse Mary Davis
                tenantUsers[2]  // Dr. Robert Brown
            ]
        case "Pediatric Wellness Clinic":
            return [
                tenant.mainUser,
                tenantUsers[3]  // Dr. Amanda Wilson
            ]
        case "Orthopedic Sports Medicine":
            return [
                tenant.mainUser,
                tenantUsers[4]  // Dr. Kevin Martinez
            ]
        case "Family Medicine Associates":
            return [
                tenant.mainUser,
                tenantUsers[5]  // Nurse Jennifer Lee
            ]
        case "Dermatology Specialists":
            return [
                tenant.mainUser,
                tenantUsers[6]  // Dr. Patricia Garcia
            ]
        default:
            return [tenant.mainUser]
        }
    }
    
    // MARK: - File Management Data
    static let fileItems: [FileItem] = [
        FileItem(
            name: "Patient_Records_Q3_2024.pdf",
            type: .pdf,
            size: 2_456_789,
            dateCreated: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            owner: "Dr. Lisa Thompson",
            tenantId: tenants[0].id,
            isShared: true,
            downloadCount: 23,
            path: "/documents/medical/patient_records_q3_2024.pdf"
        ),
        FileItem(
            name: "Compliance_Report_2024.docx",
            type: .document,
            size: 1_234_567,
            dateCreated: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            owner: "Sarah Johnson",
            tenantId: tenants[0].id,
            isShared: false,
            downloadCount: 8,
            path: "/documents/compliance/compliance_report_2024.docx"
        ),
        FileItem(
            name: "Training_Video_New_Staff.mp4",
            type: .video,
            size: 45_678_901,
            dateCreated: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date(),
            owner: "Michael Chen",
            tenantId: tenants[1].id,
            isShared: true,
            downloadCount: 156,
            path: "/media/training/training_video_new_staff.mp4"
        ),
        FileItem(
            name: "Financial_Analysis_Q4.xlsx",
            type: .spreadsheet,
            size: 987_654,
            dateCreated: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            owner: "Emily Rodriguez",
            tenantId: tenants[2].id,
            isShared: true,
            downloadCount: 12,
            path: "/documents/financial/financial_analysis_q4.xlsx"
        ),
        FileItem(
            name: "System_Backup_Archive.zip",
            type: .archive,
            size: 123_456_789,
            dateCreated: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
            owner: "System Admin",
            tenantId: nil, // Global file
            isShared: false,
            downloadCount: 3,
            path: "/system/backups/system_backup_archive.zip"
        ),
        FileItem(
            name: "Marketing_Presentation.pptx",
            type: .presentation,
            size: 8_765_432,
            dateCreated: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
            owner: "David Kim",
            tenantId: tenants[3].id,
            isShared: true,
            downloadCount: 45,
            path: "/documents/marketing/marketing_presentation.pptx"
        ),
        FileItem(
            name: "Patient_Intake_Form.pdf",
            type: .pdf,
            size: 234_567,
            dateCreated: Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            owner: "Jennifer Wilson",
            tenantId: tenants[4].id,
            isShared: true,
            downloadCount: 89,
            path: "/forms/patient_intake_form.pdf"
        ),
        FileItem(
            name: "Equipment_Manual.pdf",
            type: .pdf,
            size: 5_432_109,
            dateCreated: Calendar.current.date(byAdding: .day, value: -120, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -120, to: Date()) ?? Date(),
            owner: "Technical Support",
            tenantId: nil, // Global file
            isShared: true,
            downloadCount: 67,
            path: "/manuals/equipment_manual.pdf"
        ),
        FileItem(
            name: "Office_Photos.jpg",
            type: .image,
            size: 3_456_789,
            dateCreated: Calendar.current.date(byAdding: .day, value: -180, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -180, to: Date()) ?? Date(),
            owner: "Marketing Team",
            tenantId: tenants[0].id,
            isShared: false,
            downloadCount: 15,
            path: "/media/images/office_photos.jpg"
        ),
        FileItem(
            name: "Policy_Updates_Audio.mp3",
            type: .audio,
            size: 12_345_678,
            dateCreated: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date(),
            dateModified: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date(),
            owner: "HR Department",
            tenantId: nil, // Global file
            isShared: true,
            downloadCount: 34,
            path: "/media/audio/policy_updates_audio.mp3"
        )
    ]
    
    // MARK: - Computed Properties for File Statistics
    static var totalFiles: Int {
        return fileItems.count
    }
    
    static var totalFileSize: Int64 {
        return fileItems.reduce(0) { $0 + $1.size }
    }
    
    static var totalFileSizeFormatted: String {
        return ByteCountFormatter.string(fromByteCount: totalFileSize, countStyle: .file)
    }
    
    static var filesByType: [FileType: Int] {
        var counts: [FileType: Int] = [:]
        for type in FileType.allCases {
            counts[type] = fileItems.filter { $0.type == type }.count
        }
        return counts
    }
}
