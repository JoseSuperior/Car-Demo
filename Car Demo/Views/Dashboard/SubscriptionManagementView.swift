//
//  SubscriptionManagementView.swift
//  Car Demo
//
//  Created by Jose Gregorio Flores on 10/7/25.
//

import SwiftUI

struct SubscriptionManagementView: View {
    @State private var selectedPlan: SubscriptionPlan?
    @State private var showingAddPlan = false
    
    private let mockPlans = MockData.subscriptionPlans
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Subscription Management")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Manage subscription plans and pricing")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Button(action: { showingAddPlan = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Text("Add Plan")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.carPrimary)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.backgroundPrimary)
            
            // Plans List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(mockPlans) { plan in
                        SubscriptionPlanCard(
                            plan: plan,
                            isSelected: selectedPlan?.id == plan.id,
                            onSelect: { selectedPlan = plan }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color.backgroundPrimary)
        }
        .sheet(isPresented: $showingAddPlan) {
            AddSubscriptionPlanView()
        }
    }
}

// MARK: - Subscription Plan Card
struct SubscriptionPlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        if plan.isActive {
                            Text("ACTIVE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.success)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.success.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Base Price")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            Text("$\(String(format: "%.0f", plan.basePrice))/month")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.carPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Per Seat")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textSecondary)
                            
                            Text("$\(String(format: "%.0f", plan.seatPrice))/month")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.carPrimary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button("Edit") {
                        onSelect()
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.carPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.carPrimary.opacity(0.1))
                    .cornerRadius(8)
                    
                    Button(plan.isActive ? "Deactivate" : "Activate") {
                        // Handle activation toggle
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(plan.isActive ? .error : .success)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background((plan.isActive ? Color.error : Color.success).opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // Features
            if !plan.features.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(plan.features, id: \.self) { feature in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.success)
                                
                                Text(feature)
                                    .font(.system(size: 14))
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.carPrimary : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

// MARK: - Add Subscription Plan View
struct AddSubscriptionPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var planName = ""
    @State private var basePrice = ""
    @State private var seatPrice = ""
    @State private var features: [String] = [""]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Create Subscription Plan")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Define a new subscription plan with pricing and features")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Plan Name",
                            placeholder: "Premium Plan",
                            text: $planName
                        )
                        
                        HStack(spacing: 12) {
                            CustomTextField(
                                title: "Base Price ($)",
                                placeholder: "299",
                                text: $basePrice,
                                keyboardType: .decimalPad
                            )
                            
                            CustomTextField(
                                title: "Per Seat ($)",
                                placeholder: "49",
                                text: $seatPrice,
                                keyboardType: .decimalPad
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Features")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                                HStack {
                                    TextField("Feature description", text: Binding(
                                        get: { features[index] },
                                        set: { features[index] = $0 }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    if features.count > 1 {
                                        Button(action: {
                                            features.remove(at: index)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.error)
                                        }
                                    }
                                }
                            }
                            
                            Button(action: {
                                features.append("")
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.carPrimary)
                                    
                                    Text("Add Feature")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.carPrimary)
                                }
                            }
                        }
                    }
                    
                    CustomButton(
                        title: "Create Plan",
                        action: {
                            // Mock creation
                            dismiss()
                        },
                        style: .primary,
                        size: .large,
                        isDisabled: planName.isEmpty || basePrice.isEmpty || seatPrice.isEmpty
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

#Preview {
    SubscriptionManagementView()
}
