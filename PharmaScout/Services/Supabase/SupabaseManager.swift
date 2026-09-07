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
    
    enum Database {
        enum Table {
            enum GenericDrug {
                static let name = "generic_drug"
                
                enum Column {
                    static let genericName = "generic_name"
                }
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
    }
}


typealias Table = SupabaseManager.Database.Table
