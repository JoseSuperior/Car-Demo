//
//  FileManagerView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct FileManagerView: View {
    @State private var searchText = ""
    @State private var selectedFileType: FileType? = nil
    @State private var sortBy: FileSortOption = .dateModified
    @State private var showingUploadSheet = false
    @State private var selectedFile: FileItem? = nil
    
    private var filteredFiles: [FileItem] {
        var files = MockData.fileItems
        
        // Filter by search text
        if !searchText.isEmpty {
            files = files.filter { file in
                file.name.localizedCaseInsensitiveContains(searchText) ||
                file.owner.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by file type
        if let selectedType = selectedFileType {
            files = files.filter { $0.type == selectedType }
        }
        
        // Sort files
        switch sortBy {
        case .name:
            files = files.sorted { $0.name < $1.name }
        case .dateCreated:
            files = files.sorted { $0.dateCreated > $1.dateCreated }
        case .dateModified:
            files = files.sorted { $0.dateModified > $1.dateModified }
        case .size:
            files = files.sorted { $0.size > $1.size }
        case .owner:
            files = files.sorted { $0.owner < $1.owner }
        }
        
        return files
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with stats
            fileStatsHeader
            
            // Search and filters
            searchAndFiltersSection
            
            // Files list
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredFiles) { file in
                        FileRowView(file: file) {
                            selectedFile = file
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .background(Color.backgroundPrimary)
        .sheet(isPresented: $showingUploadSheet) {
            FileUploadView()
        }
        .sheet(item: $selectedFile) { file in
            FileDetailView(file: file)
        }
    }
    
    // MARK: - File Stats Header
    private var fileStatsHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("File Manager")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Manage all tenant files and documents")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Button {
                    showingUploadSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Upload File")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.carPrimary)
                    .cornerRadius(8)
                }
            }
            
            // Stats cards
            HStack(spacing: 12) {
                FileStatCard(
                    title: "Total Files",
                    value: "\(MockData.totalFiles)",
                    icon: "doc.fill",
                    color: .carPrimary
                )
                
                FileStatCard(
                    title: "Total Size",
                    value: MockData.totalFileSizeFormatted,
                    icon: "externaldrive.fill",
                    color: .success
                )
                
                FileStatCard(
                    title: "Shared Files",
                    value: "\(MockData.fileItems.filter { $0.isShared }.count)",
                    icon: "person.2.fill",
                    color: .warning
                )
                
                FileStatCard(
                    title: "Downloads",
                    value: "\(MockData.fileItems.reduce(0) { $0 + $1.downloadCount })",
                    icon: "arrow.down.circle.fill",
                    color: .primaryBlue
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Search and Filters
    private var searchAndFiltersSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.textSecondary)
                    
                    TextField("Search files...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.backgroundSecondary)
                .cornerRadius(8)
                
                // Sort menu
                Menu {
                    ForEach(FileSortOption.allCases, id: \.self) { option in
                        Button {
                            sortBy = option
                        } label: {
                            HStack {
                                Text(option.displayName)
                                if sortBy == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(8)
                }
            }
            
            // File type filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FileTypeFilterChip(
                        title: "All Files",
                        isSelected: selectedFileType == nil,
                        icon: nil
                    ) {
                        selectedFileType = nil
                    }
                    
                    ForEach(FileType.allCases, id: \.self) { type in
                        FileTypeFilterChip(
                            title: type.rawValue.capitalized,
                            isSelected: selectedFileType == type,
                            icon: type.icon
                        ) {
                            selectedFileType = selectedFileType == type ? nil : type
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

// MARK: - File Row View
struct FileRowView: View {
    let file: FileItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // File icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colorForType(file.type).opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: file.type.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(colorForType(file.type))
                }
                
                // File info
                VStack(alignment: .leading, spacing: 4) {
                    Text(file.name)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    HStack(spacing: 12) {
                        Text(file.owner)
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                        
                        Text("•")
                            .foregroundColor(.textSecondary)
                        
                        Text(file.sizeFormatted)
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                        
                        Text("•")
                            .foregroundColor(.textSecondary)
                        
                        Text(RelativeDateTimeFormatter().localizedString(for: file.dateModified, relativeTo: Date()))
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                Spacer()
                
                // Shared indicator
                if file.isShared {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.primaryBlue)
                }
                
                // More options
                Button {
                    // Handle more options
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .padding(8)
                }
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func colorForType(_ type: FileType) -> Color {
        switch type.color {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "red": return .red
        case "teal": return .teal
        case "indigo": return .indigo
        default: return .gray
        }
    }
}

// MARK: - Supporting Views
struct FileStatCard: View {
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
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.05))
        .cornerRadius(8)
    }
}

struct FileTypeFilterChip: View {
    let title: String
    let isSelected: Bool
    let icon: String?
    let onTap: () -> Void
    
    init(title: String, isSelected: Bool, icon: String? = nil, onTap: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.icon = icon
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.carPrimary : Color.backgroundSecondary)
            .cornerRadius(16)
        }
    }
}

// MARK: - Supporting Enums
enum FileSortOption: CaseIterable {
    case name
    case dateCreated
    case dateModified
    case size
    case owner
    
    var displayName: String {
        switch self {
        case .name: return "Name"
        case .dateCreated: return "Date Created"
        case .dateModified: return "Date Modified"
        case .size: return "Size"
        case .owner: return "Owner"
        }
    }
}

// MARK: - Placeholder Views
struct FileUploadView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "icloud.and.arrow.up")
                    .font(.system(size: 60))
                    .foregroundColor(.carPrimary)
                
                VStack(spacing: 8) {
                    Text("Upload Files")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Select files to upload to the system")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }
                
                Button("Select Files") {
                    // Handle file selection
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.carPrimary)
                .cornerRadius(8)
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Upload Files")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct FileDetailView: View {
    let file: FileItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // File preview placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundSecondary)
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: file.type.icon)
                                    .font(.system(size: 40))
                                    .foregroundColor(.textSecondary)
                                
                                Text("Preview not available")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                        )
                    
                    // File details
                    VStack(alignment: .leading, spacing: 16) {
                        FileDetailRow(title: "Name", value: file.name)
                        FileDetailRow(title: "Owner", value: file.owner)
                        FileDetailRow(title: "Size", value: file.sizeFormatted)
                        FileDetailRow(title: "Type", value: file.type.rawValue.capitalized)
                        FileDetailRow(title: "Created", value: DateFormatter.medium.string(from: file.dateCreated))
                        FileDetailRow(title: "Modified", value: DateFormatter.medium.string(from: file.dateModified))
                        FileDetailRow(title: "Downloads", value: "\(file.downloadCount)")
                        FileDetailRow(title: "Shared", value: file.isShared ? "Yes" : "No")
                        FileDetailRow(title: "Path", value: file.path)
                    }
                }
                .padding(20)
            }
            .navigationTitle("File Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct FileDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
    }
}

// MARK: - Extensions
extension DateFormatter {
    static let medium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    FileManagerView()
}
