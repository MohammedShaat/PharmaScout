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
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
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
                    static let day = "day"
                    static let pharmacyId = "pharmacy_id"
                    static let opensAt = "opens_at"
                    static let closesAt = "closes_at"
                    static let timezone = "timezone"
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
        }
    }
}


typealias Table = SupabaseManager.Database.Table
