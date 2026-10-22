//
//  SupabaseManager.swift
//  PharmaScout
//
//  Created by Mohammed on 8/29/26.
//

import Foundation
import Supabase

struct SupabaseManager {
    static let shared = SupabaseManager()
    
    private let urlStr = "https://lwrpmlmfeyhglsniponn.supabase.co"
    private let key = "sb_publishable_q-LZxtCJa-lOCYk5CBm4tQ_zXKRNXZ-"
    
    let client: SupabaseClient
    
    private init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        
        let options = SupabaseClientOptions(
            db: .init(encoder: encoder, decoder: decoder),
            auth: .init(emitLocalSessionAsInitialSession: true)
        )
        
        client = SupabaseClient(
            supabaseURL: URL(string: urlStr)!,
            supabaseKey: key,
            options: options
        )
    }
}


extension SupabaseManager {
    enum Database {
        enum Table {
            enum GenericDrug {
                static let name = "generic_drug"
                
                enum Column {
                    static let genericName = "generic_name"
                }
            }
            
            enum DrugFormulation {
                static let name = "drug_formulation"
                
                enum Column {
                    static let id = "id"
                    static let genericDrugId = "generic_drug_id"
                    static let strength = "strength"
                    static let route = "route"
                    static let form = "form"
                }
            }
            
            enum Search {
                static let name = "search"
                
                enum Column {
                    static let id = "id"
                    static let userId = "user_id"
                    static let latitude = "latitude"
                    static let longitude = "longitude"
                    static let acceptSubstitute = "accept_substitute"
                    static let drugsCount = "drugs_count"
                    static let fulfilledDrugsCount = "fulfilled_drugs_count"
                    static let status = "status"
                    static let fulfilmentMode = "fulfilment_mode"
                    static let createdAt = "created_at"
                }
            }
            
            enum SearchItem {
                static let name = "search_item"
                
                enum Column {
                    static let id = "id"
                    static let searchId = "search_id"
                    static let drugFormulationId = "drug_formulation_id"
                    static let status = "status"
                    static let fulfilledPharmacyInquiryId = "fulfilled_pharmacy_inquiry_id"
                }
            }
            
            enum PharmacyContact {
                static let name = "pharmacy_contact"
                
                enum Column {
                    static let id = "id"
                    static let pharmacyId = "pharmacy_id"
                    static let title = "title"
                    static let type = "type"
                    static let value = "value"
                }
            }
            
            enum PharmacyHours {
                static let name = "pharmacy_hours"
                
                enum Column {
                    static let id = "id"
                    static let pharmacyId = "pharmacy_id"
                    static let day = "day"
                    static let opensAt = "opens_at"
                    static let closesAt = "closes_at"
                }
            }
            
            enum PharmacyStaff {
                static let name = "pharmacy_staff"
                
                enum Column {
                    static let id = "id"
                    static let userId = "user_id"
                    static let pharmacyId = "pharmacy_id"
                    static let role = "role"
                    static let status = "status"
                }
            }
            
            enum PharmacyInquiry {
                static let name = "pharmacy_inquiry"
                
                enum Column {
                    static let id = "id"
                    static let drugFormulationId = "drug_formulation_id"
                    static let pharmacyId = "pharmacy_id"
                    static let status = "status"
                    static let response = "response"
                    static let substituteDrugFormulationId = "substitute_drug_formulation_id"
                    static let createdAt = "created_at"
                    static let respondedAt = "responded_at"
                }
            }
            
            enum Pharmacy {
                static let name = "pharmacy"
                
                enum Column {
                    static let id = "id"
                    static let name = "name"
                    static let latitude = "latitude"
                    static let longitude = "longitude"
                    static let address = "address"
                    static let status = "status"
                    static let timezone = "timezone"
                }
            }
            
            enum deviceTokens {
                static let name = "device_tokens"
                
                enum Column {
                    static let id = "id"
                    static let user = "user"
                    static let token = "token"
                    static let platform = "platform"
                }
            }
            
            enum appConfig {
                static let name = "app_config"
                
                enum Column {
                    static let key = "key"
                    static let value = "value"
                }
                
                enum Key {
                    static let maxSearchRadiusMeters = "max_search_radius_meters"
                }
            }
            
            enum ownerApplication {
                static let name = "owner_application"
                
                enum Column {
                    static let id = "id"
                    static let code = "code"
                    static let createdBy = "created_by"
                    static let applicantId = "applicant_id"
                    static let status = "status"
                    static let expiresAt = "expires_at"
                    static let redeemedAt = "redeemed_at"
                    static let reviewedBy = "reviewed_by"
                    static let reviewedAt = "reviewed_at"
                    static let createdAt = "created_at"
                }
            }
        }
        
        
        enum Functions {
            enum SearchGenericDrug {
                static let name = "search_generic_drug"
                
                enum Params {
                    static let inputText = "input_text"
                }
            }
            
            enum SearchDrugFormulations {
                static let name = "search_drug_formulations"
                
                enum Params {
                    static let genericDrugId = "p_generic_drug_id"
                    static let inputText = "p_input_text"
                }
            }
            
            enum CreateSearch {
                static let name = "create_search"
                
                enum Params {
                    static let latitude = "p_latitude"
                    static let longitude = "p_longitude"
                    static let fulfilmentMode = "p_fulfilment_mode"
                    static let acceptSubstitute = "p_accept_substitute"
                    static let items = "p_items"
                    static let pharmacyIds  = "p_pharmacy_ids"
                }
            }
            
            enum findPharmaciesWithinDistance {
                static let name = "find_pharmacies_within_distance"
                
                enum Params {
                    static let latitude = "p_latitude"
                    static let longitude = "p_longitude"
                    static let radiusMeters = "p_radius_meters"
                }
            }
            
            enum findNearbyPharmacies {
                static let name = "find_nearby_pharmacies"
                
                enum Params {
                    static let latitude = "p_latitude"
                    static let longitude = "p_longitude"
                    static let radiusMeters = "p_radius_meters"
                    static let limit = "p_limit"
                    static let offset = "p_offset"
                }
            }
            
            enum getSearches {
                static let name = "get_searches"
                
                enum Params {
                    static let limit = "p_limit"
                    static let offset = "p_offset"
                    static let onlyPending = "p_only_pending"
                }
            }
            
            enum getSearch {
                static let name = "get_search"
                
                enum Params {
                    static let searchId = "p_search_id"
                }
            }
            
            enum getSearchDrugDetails {
                static let name = "get_search_drug_details"
                
                enum Params {
                    static let searchId = "p_search_id"
                    static let latitude = "latitude"
                    static let longitude = "longitude"
                }
            }
            
            enum getPharmacyInquiries {
                static let name = "get_pharmacy_inquiries"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                    static let limit = "p_limit"
                    static let offset = "p_offset"
                    static let statusFilter = "p_status_filter"
                }
            }
            
            enum getPharmacyInquiry {
                static let name = "get_pharmacy_inquiry"
                
                enum Params {
                    static let inquiryId = "p_inquiry_id"
                }
            }
            
            enum respondToPharmacyInquiry {
                static let name = "respond_to_pharmacy_inquiry"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                    static let response = "p_response"
                    static let substituteDrugFormulationId = "p_substitute_drug_formulation_id"
                }
            }
            
            enum getPharmacyDetails {
                static let name = "get_pharmacy_details"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                    static let latitude = "p_latitude"
                    static let longitude = "p_longitude"
                }
            }
            
            enum getPharmacyStaffMemberIfAvailable {
                static let name = "get_pharmacy_staff_member_if_available"
                
                enum Params {
                    static let userId = "p_user_id"
                }
            }
            
            enum getMyAccountState {
                static let name = "get_my_account_state"
            }
            
            enum getPharmacyStaff {
                static let name = "get_pharmacy_staff"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                }
            }
            
            enum updatePharmacyStaffMembers {
                static let name = "update_pharmacy_staff_members"
                
                enum Params {
                    static let staffMembers = "p_staff_members"
                }
            }
            
            enum generatePharmacyJoinCode {
                static let name = "create_pharmacy_join_code"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                }
            }
            
            enum getActivePharmacyJoinCode {
                static let name = "get_active_pharmacy_join_code"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                }
            }
            
            enum joinPharmacy {
                static let name = "join_pharmacy"
                
                enum Params {
                    static let code = "p_code"
                }
            }
            
            enum getRegionalDemandAnalytics {
                static let name = "get_regional_demand_analytics"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                    static let days = "p_days"
                    static let limit = "p_limit"
                }
            }
            
            enum getPharmacySearchAnalytics {
                static let name = "get_pharmacy_search_analytics"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                    static let days = "p_days"
                    static let limit = "p_limit"
                }
            }
            
            enum canEditPharmacyInquiry {
                static let name = "can_edit_pharmacy_inquiry"
                
                enum Params {
                    static let inquiryId = "p_inquiry_id"
                }
            }
            
            enum registerDeviceToken {
                static let name = "register_device_token"
                
                enum Params {
                    static let token = "p_token"
                    static let platform = "p_platform"
                }
            }
            
            enum continueSearch {
                static let name = "continue_search"
                
                enum Params {
                    static let searchId = "p_search_id"
                    static let radiusMeters = "p_radius_meters"
                }
            }
            
            enum createOwnerCode {
                static let name = "create_owner_code"
            }
            
            enum applyForPharmacyOwnership {
                static let name = "redeem_owner_code"
                
                enum Params {
                    static let code = "p_code"
                }
            }
            
            enum isAdmin {
                static let name = "is_admin"
            }
            
            enum getOwnerApplications {
                static let name = "get_owner_applications"
                
                enum Params {
                    static let limit = "p_limit"
                    static let offset = "p_offset"
                    static let filter = "p_filter"
                }
            }
            
            enum getOwnerApplication {
                static let name = "get_owner_application"
                
                enum Params {
                    static let id = "p_id"
                }
            }
            
            enum revokeOwnerApplication {
                static let name = "revoke_owner_code"
                
                enum Params {
                    static let applicationId = "p_application_id"
                }
            }
            
            enum reviewOwnerApplication {
                static let name = "review_owner_application"
                
                enum Params {
                    static let applicationId = "p_application_id"
                    static let approve = "p_approve"
                }
            }
            
            enum createPharmacy {
                static let name = "create_pharmacy"
            }
            
            enum getPharmacyApplications {
                static let name = "get_pharmacy_applications"
                
                enum Params {
                    static let status = "p_status"
                }
            }
            
            enum getPharmacyApplication {
                static let name = "get_pharmacy_application"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                }
            }
            
            enum reviewPharmacy {
                static let name = "review_pharmacy"
                
                enum Params {
                    static let pharmacyId = "p_pharmacy_id"
                    static let approve = "p_approve"
                    static let rejectionReason = "p_rejection_reason"
                }
            }
        }
    }
}


typealias Table = SupabaseManager.Database.Table
